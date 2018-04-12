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

//indicates if signal 'signum' is blocked for handling
int isBlocked(int signum) {
    struct proc *curproc = myproc();
    if (curproc != 0) {
        if (curproc->mask & (1 << signum) > 0)
            return 1;
        return 0;
    }
}
//cancel a certain signal for a certain process!
void cancelSignal(struct proc* p,int signum){
    if(signum >= 0 && signum <= 31){
        p->pending = p->pending ^ (1 << signum);
    }
}
//called in kernel mode
void
check_kernel_sigs() {
    int i;
    struct proc *curproc = myproc();
    if (curproc != 0) {
        //first check for KERNEL signals
        //if this signal is pending
        if (((curproc->pending & (1 << SIGKILL)) > 0) && !isBlocked(SIGKILL)) {
            curproc->killed = 1;
            if (curproc->state == SLEEPING)
                curproc->state = RUNNABLE;
        } else if (hasSignal(curproc, SIGCONT) && !isBlocked(SIGCONT)) {
            if (hasSignal(curproc, SIGSTOP)) {
                //cancel the SIGSTOP signal
                //by XOR'ing the pending signals with the SIGSTOP signal
                cancelSignal(curproc,SIGSTOP);
                //cancel the SIGCONT signal, it's already handled
                cancelSignal(curproc,SIGCONT);
            } else {
                //cancel SIGCONT, it should be ignored (no SIGSTOP is present)
                curproc->pending = curproc->pending ^ (1 << SIGCONT);
            }
        } else if (((curproc->pending & (1 << SIGSTOP)) > 0) && !isBlocked(SIGSTOP)) {
            //yield();

        }


        for(i=0; i<32; i++){
            //if it's a user signal tha's NOT blocked
            if(i!=SIGSTOP && i!=SIGCONT && i!=SIGKILL && !isBlocked(i)){
                //handle user signal.
                if(curproc->handlers[i] == SIG_IGN) {              //ignore if required
                    cancelSignal(curproc,i);
                    continue;
                }
                else if(curproc->handlers[i]==SIG_DFL) {        // kill by default (according to instructions)
                    cancelSignal(curproc,i);
                    curproc->killed = 1;
                    break;
                }
                else{ //NOT default and NOT ignore. meaning it's some handler pointer.
                    //curproc->trap_backup=*curproc->tf;  //TODO: check if backing up a struct like this makes sense
                    memmove(&curproc->trap_backup,curproc->tf,sizeof(struct trapframe));
                    asm{
                    //TODO: push arguments and INJECT trapret and stuff :(

                    }



                }


            }
        }
    }

}


