#include "types.h"
#include "user.h"

typedef void (*sighandler_t)(int);

int number = 1;

void test_SIGKILL() {
    printf(1, "Starting test_SIGKILL\n");
    int parent_pid = getpid();
    int pid = fork();
    if (pid == 0) {
        sleep(10);
        printf(1, "E ::process not killed, should not get here\n");
        kill(parent_pid, SIGKILL);
        exit();

    } else {
        kill(pid, SIGKILL);
        wait();
    }
    printf(1, "test_SIGKILL passed\n");
}

void test_SIGSTOP_SIGCONT() {
    printf(1, "Starting test_SIGSTOP_SIGCONT\n");
    int parent_pid = getpid();
    int pid = fork();
    if (pid == 0) {
        sleep(10);
        printf(1, "E ::process not stopped, should not get here\n");
        kill(parent_pid, SIGKILL);
        exit();

    } else {
        kill(pid, SIGSTOP);
        sleep(40);
        kill(pid, SIGKILL);
        wait();
    }
    printf(1, "test_SIGSTOP_SIGCONT passed\n");
}

void test_signal_with_SIGKILL() {
    printf(1, "Starting test_signal_with_SIGKILL\n");
    signal(1, (sighandler_t) SIGKILL);
    int parent_pid = getpid();
    int pid = fork();
    if (pid == 0) {
        sleep(10);
        printf(1, "E ::process not killed, should not get here\n");
        kill(parent_pid, 1);
        exit();

    } else {
        kill(pid, 1);
        wait();
    }
    printf(1, "test_signal_with_SIGKILL passed\n");
}

void test_signal_change_handler() {
    printf(1, "Starting test_signal_change_handler\n");

    int parent_pid = getpid();
    int pid = fork();
    if (pid == 0) {
        sleep(10);
        kill(parent_pid, SIGKILL); //(2) send SIGKILL to Parent (should ignore now)
        signal(SIGKILL, (sighandler_t) SIGKILL); //(3) change child SIGKILL to SIG_DFL
        sleep(60);
        printf(1, "E:: parent died before killing child , should not be here\n");
        exit();
    } else {
        signal(SIGKILL, (sighandler_t) SIG_IGN); //(1) change parent SIGKILL to ignore
        sleep(30);
        kill(pid, SIGKILL); //(4) send SIGKILL to child (should *not* ignore now)
        wait();
        signal(SIGKILL, (sighandler_t) SIGKILL); //(1) change parent SIGKILL to ignore
    }
    printf(1, "test_signal_change_handler passed\n");
}

void test_signal_ret_val(int main_pid) {
    printf(1, "Starting test_signal_ret_val\n");
    sighandler_t prevHand = signal(3, (sighandler_t) SIGKILL);
    if (prevHand != (sighandler_t) SIG_DFL) {
        printf(1, "E :: wrong signal handler returned from signal()\n");
        kill(main_pid, 3);
        exit();
    }
    prevHand = signal(3, (sighandler_t) SIG_IGN);
    if (prevHand != (sighandler_t) SIGKILL) {
        printf(1, "E :: wrong signal handler returned from signal()\n");
        kill(main_pid, 3);
        exit();
    }
    printf(1, "test_signal_ret_val passed\n");
}

void test_sigprocmask_ret_val(int main_pid) {
    printf(1, "Starting test_sigprocmask_ret_val\n");
    uint prev_sigprocmask = sigprocmask(~(1 << SIGKILL));
    if (prev_sigprocmask != -1) {
        printf(1, "E :: wrong mask returned from sigprocmask()\n");
        kill(main_pid, 1);
        exit();
    }
    prev_sigprocmask = sigprocmask(~(1 << SIGSTOP));
    if (prev_sigprocmask != ~(1 << SIGKILL)) {
        printf(1, "E :: wrong mask returned from sigprocmask()\n");
        kill(main_pid, 1);
        exit();
    }
    sigprocmask(-1);
    printf(1, "test_sigprocmask_ret_val passed\n");
}

void test_sigprocmask_blocking() {
    printf(1, "Starting test_sigprocmask_blocking\n");
    int parent_pid = getpid();
    int pid = fork();
    if (pid == 0) {
        signal(8, (sighandler_t) SIGKILL);
        sleep(20);
        kill(parent_pid, 8); //(2) send SIGKILL to Parent (should ignore now)
        sleep(80);
        printf(1, "E:: parent died before killing child , should not be here\n");
        exit();
    } else {
        sigprocmask(~(1 << 8));//(1) change parent mask to ignore SIGKILL
        signal(8, (sighandler_t) SIGKILL);
        sleep(30);
        kill(pid, 8); //(3) send SIGKILL to child (should *not* ignore now)
        wait();
        signal(8, (sighandler_t) SIG_IGN);
        sigprocmask(-1);
    }
    printf(1, "test_sigprocmask_blocking passed\n");
}

void func() {
    ++number;
}


void test_user_func_signal(int main_pid) {
    printf(1, "starting test_user_func_signal\n");
    int pid = fork();
    if (pid == 0) {
        signal(7, (sighandler_t) func);
        sleep(60);
        if (number != 2) {
            printf(1, "E:: func didn't work, num expected 2, but got %d\n", number);
            kill(main_pid, SIGKILL);
        }
        exit();
    } else {
        sleep(10);
        kill(pid, 7);
        wait();
    }
    printf(1, "test_user_func_signal passed\n");
}


void test_shell_signal() {
    printf(1, "starting test_shell_signal\n");
    int pid = fork();
    if (pid == 0) {
        sigprocmask((1 << 27));
        exec("sh", (char *[]) {"sh", 0});
    } else {
        sleep(10);
        printf(1, "Please enter \"kill %d 27\" to screen\n", pid);
        wait();
    }
    printf(1, "test_shell_signal passed\n");
}


int main() {
    int main_pid = getpid();
    int pid = fork();
    if (pid == 0) {
        test_SIGKILL();
        test_SIGSTOP_SIGCONT();
        test_signal_with_SIGKILL();
        test_signal_change_handler();
        test_signal_ret_val(main_pid);
        test_sigprocmask_ret_val(main_pid);
        test_sigprocmask_blocking();
        test_user_func_signal(main_pid);
        test_shell_signal();
        printf(1, "All Tests PASSED\n");
        exit();
    } else
        wait();
    exit();
}