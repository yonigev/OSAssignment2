
//
// Created by moriel on 4/27/18.
//
#include "param.h"
#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"
#include "fcntl.h"
#include "syscall.h"
#include "traps.h"
#include "memlayout.h"

//int flag1 = 0, flag2 = 0, flag3 = 0;
//char buf[4096];
//int debug = 0;

//Assignment 2: task 2.1.4:
typedef void (*sighandler_t)(int);

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
    }
    printf(1, "test_signal_change_handler passed\n");
}

void test_signal_ret_val(int main_pid) {
    printf(1, "Starting test_signal_ret_val\n");
    sighandler_t prevHand = signal(1, (sighandler_t) SIGKILL);
    if(prevHand!=(sighandler_t)SIG_DFL){
        printf(1,"E :: wrong signal handler returned from signal()\n" );
        kill(main_pid,1);
        exit();
    }
    prevHand= signal(1, (sighandler_t)SIG_IGN);
    if(prevHand!=(sighandler_t)SIGKILL){
        printf(1,"E :: wrong signal handler returned from signal()\n" );
        kill(main_pid,1);
        exit();
    }
    printf(1, "test_signal_ret_val passed\n");
}

void test_sigprocmask_ret_val(int main_pid){
    printf(1, "Starting test_sigprocmask_ret_val\n");
    uint prev_sigprocmask= sigprocmask(~(1<<SIGKILL));
    if(prev_sigprocmask!= -1){
        printf(1,"E :: wrong mask returned from sigprocmask()\n" );
        kill(main_pid,1);
        exit();
    }
    prev_sigprocmask= sigprocmask(~(1<<SIGSTOP));
    if(prev_sigprocmask!= ~(1<<SIGKILL)){
        printf(1,"E :: wrong mask returned from sigprocmask()\n" );
        kill(main_pid,1);
        exit();
    }
    printf(1, "test_sigprocmask_ret_val passed\n");
}

void test_sigprocmask_blocking(){
    printf(1, "Starting test_sigprocmask_blocking\n");
    int parent_pid = getpid();
    int pid = fork();
    if (pid == 0) {
        sleep(10);
        kill(parent_pid, SIGKILL); //(2) send SIGKILL to Parent (should ignore now)
        sleep(60);
        printf(1, "E:: parent died before killing child , should not be here\n");
        exit();
    } else {
        sigprocmask(~(1<<SIGKILL));//(1) change parent mask to ignore SIGKILL
        sleep(30);
        kill(pid, SIGKILL); //(3) send SIGKILL to child (should *not* ignore now)
        wait();
    }
    printf(1, "test_sigprocmask_blocking passed\n");
}


int main() {
   // int main_pid = getpid();
    int pid = fork();
    if (pid == 0) {
        //test_SIGKILL();
        //test_SIGSTOP_SIGCONT();
        //test_signal_with_SIGKILL();
        //test_signal_change_handler();
        //test_signal_ret_val(main_pid);
        //test_sigprocmask_ret_val(main_pid);
        test_sigprocmask_blocking();
        printf(1, "All Tests PASSED\n");
        exit();
    } else
        wait();
    exit();
}