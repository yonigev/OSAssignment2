#include traps.h
#include syscall.h


.globl call_sigret_syscall
.globl end_sigret_syscall
call_sigret_syscall:
    movl $SYS_sigret, %eax
    int $T_SYSCALL
end_sigret_syscall:



