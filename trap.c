#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"
#include "traps.h"
#include "spinlock.h"

// Interrupt descriptor table (shared by all CPUs).
struct gatedesc idt[256];
extern uint vectors[];  // in vectors.S: array of 256 entry pointers

extern void call_sigret_syscall(void);
extern void end_sigret_syscall(void);

struct spinlock tickslock;
uint ticks;

void
tvinit(void) {
    int i;

    for (i = 0; i < 256; i++) SETGATE(idt[i], 0, SEG_KCODE << 3, vectors[i], 0);
    SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);

    initlock(&tickslock, "time");
}

void
idtinit(void) {
    lidt(idt, sizeof(idt));
}

//PAGEBREAK: 41
void
trap(struct trapframe *tf) {

    if (tf->trapno == T_SYSCALL) {

        if (myproc()->killed)
            exit();
        myproc()->tf = tf;
        syscall();
        if (myproc()->killed)
            exit();
        return;
    }

    switch (tf->trapno) {
        case T_IRQ0 + IRQ_TIMER:
            if (cpuid() == 0) {
                acquire(&tickslock);
                ticks++;
                wakeup(&ticks);
                release(&tickslock);
            }
            lapiceoi();
            break;
        case T_IRQ0 + IRQ_IDE:
            ideintr();
            lapiceoi();
            break;
        case T_IRQ0 + IRQ_IDE + 1:
            // Bochs generates spurious IDE1 interrupts.
            break;
        case T_IRQ0 + IRQ_KBD:
            kbdintr();
            lapiceoi();
            break;
        case T_IRQ0 + IRQ_COM1:
            uartintr();
            lapiceoi();
            break;
        case T_IRQ0 + 7:
        case T_IRQ0 + IRQ_SPURIOUS:
            cprintf("cpu%d: spurious interrupt at %x:%x\n",
                    cpuid(), tf->cs, tf->eip);
            lapiceoi();
            break;

            //PAGEBREAK: 13
        default:
            if (myproc() == 0 || (tf->cs & 3) == 0) {
                // In kernel, it must be our mistake.
                cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
                        tf->trapno, cpuid(), tf->eip, rcr2());
                panic("trap");
            }
            if(myproc()){
                cprintf("NOW EIP IS: %d\n",myproc()->tf->eip);
            }
            // In user space, assume process misbehaved.
            cprintf("pid %d %s: trap %d err %d on cpu %d "
                            "eip 0x%x addr 0x%x--kill proc\n",
                    myproc()->pid, myproc()->name, tf->trapno,
                    tf->err, cpuid(), tf->eip, rcr2());
            myproc()->killed = 1;
    }

    // Force process exit if it has been killed and is in user space.
    // (If it is still executing in the kernel, let it keep running
    // until it gets to the regular system call return.)
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
        exit();

    // Force process to give up CPU on clock tick.
    // If interrupts were on while locks held, would need to check nlock.
    if (myproc() && myproc()->state == RUNNING &&
        tf->trapno == T_IRQ0 + IRQ_TIMER)
        yield();

    // Check if the process has been killed since we yielded
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
        exit();
}



//return 1 if process p has received signal 'signum'
int hasSignal(struct proc *p, int signum) {

    if ((p->pending & (1 << signum)) > 0)
        return 1;
    return 0;
}

//indicates if signal 'signum' is blocked for handling
int isBlocked(int signum) {
    struct proc *curproc = myproc();
    
    if (curproc != 0) {
        if ((curproc->mask & (1 << signum)) > 0)
            return 0;
        return 1;
    }
    return 1;
}

//cancel a certain signal for a certain process!
void cancelSignal(struct proc *p, int signum) {
    if (signum >= 0 && signum <= 31) {
        p->pending = p->pending ^ (1 << signum);
    }
}

//called in kernel mode
void
check_kernel_sigs() {


    struct proc *curproc = myproc();

    if (curproc == 0 || curproc->mask == 0 || curproc->pending == 0)
        return;


    int i;
    //check each possible signal
    for (i = 0; i < 32; i++) {

        if( !(hasSignal(curproc, i) && !isBlocked(i)) ){       //if signal i should NOT be handled right now, go to the next one
            continue;
        }

        curproc->mask_backup = curproc->mask;
        curproc->mask = 0;
        //handle signals which require DEFAULT handling

        switch (i) {
            case SIGKILL:
                if (curproc->handlers[i] == (void*)SIG_DFL) {
                    curproc->killed = 1;
                    if (curproc->state == SLEEPING)
                        curproc->state = RUNNABLE;
                }
                break;
            case SIGCONT:
                if (curproc->handlers[i] == (void*)SIG_DFL) {
                    if (hasSignal(curproc, SIGSTOP))
                        cancelSignal(curproc, SIGSTOP);
                    cancelSignal(curproc, SIGCONT);
                }
                break;
            case SIGSTOP:
                if (curproc->handlers[i] == (void*)SIG_DFL)
                    while ((!hasSignal(curproc, SIGCONT)) && (!hasSignal(curproc, SIGKILL))){
                        yield();
                    }
                break;
            default:
                if (curproc->handlers[i] == (void *) SIG_DFL) {

                    cancelSignal(curproc, i);
                    curproc->killed = 1;
                    if (curproc->state == SLEEPING)
                        curproc->state = RUNNABLE;
                }
                break;
        }
        //if should ignore this signal
        if (curproc->handlers[i] == (void *) SIG_IGN) {
            cancelSignal(curproc, i);
        }
            // custom handlers
        else if (curproc->handlers[i] != (void*)SIG_DFL) {           //user handler


            memmove(curproc->trap_backup, curproc->tf, sizeof(struct trapframe));

            void *handler_pointer = curproc->handlers[i];
            //"push" the code of the sigret injection program
            uint sigret_size = (uint)&end_sigret_syscall - (uint)&call_sigret_syscall;   //size of the "injected" program
            curproc->tf->esp -= sigret_size;
            void *injected_pointer = (void *) curproc->tf->esp;                    //points to the injected function's code.

            memmove((void *) curproc->tf->esp, call_sigret_syscall, sigret_size);   //copy the code to the stack


            //push the signum
            curproc->tf->esp -= 4;
            *((int *) curproc->tf->esp) = i;
            curproc->tf->eip = (uint) handler_pointer;
            //push a pointer to the injected function
            curproc->tf->esp -= 4;
            *((int *) curproc->tf->esp) = (int) injected_pointer;
            cancelSignal(curproc,i);            //cancel the signal, it's handled right now.
            return;
        }
        curproc->mask = curproc->mask_backup;     //restore the mask
    }
}




