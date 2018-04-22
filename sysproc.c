#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int
sys_fork(void) {
    return fork();
}

int
sys_exit(void) {
    exit();
    return 0;  // not reached
}

int
sys_wait(void) {
    cprintf("CPU    --- %d, in sys_wait, calling wait()\n",cpuid);
    return wait();
}

int
sys_kill(void) {
    int pid;
    int signum;
    if (argint(0, &pid) < 0 || argint(1, &signum) < 0)
        return -1;
    return kill(pid, signum);
}

int
sys_getpid(void) {
    return myproc()->pid;
}

int
sys_sbrk(void) {
    int addr;
    int n;

    if (argint(0, &n) < 0)
        return -1;
    addr = myproc()->sz;
    if (growproc(n) < 0)
        return -1;
    return addr;
}

int
sys_sleep(void) {
    int n;
    uint ticks0;

    if (argint(0, &n) < 0)
        return -1;
    cprintf("in sysproc!  acquire ticklock with: %d\n",myproc());
    acquire(&tickslock);
    ticks0 = ticks;
    while (ticks - ticks0 < n) {
        if (myproc()->killed || (hasSignal(myproc(),SIGKILL) && !isBlocked(SIGKILL))) {
            release(&tickslock);
            return -1;
        }
        cprintf("in sysproc!  calling sleep with proc: %d\n",myproc());
        sleep(&ticks, &tickslock);
    }
    release(&tickslock);
    return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void) {
    uint xticks;

    acquire(&tickslock);
    xticks = ticks;
    release(&tickslock);
    return xticks;
}

//Task 2.1.3
int sys_sigprocmask(void) {
    int sigmask;
    if (argint(0, &sigmask) < 0)
        return -1;
    return sigprocmask((uint)sigmask);
}

//Task 2.1.4
int sys_signal(void) {
    int signum;
    int handler=7;
    //TODO:make sure 'argint' is ok

    if (argint(0, &signum) < 0 || argint(1,  &handler) < 0)
        return -1;
    return (int)signal(signum, (sighandler_t)handler);
}

int sys_sigret(void) {

    sigret();
    return 1;

}
