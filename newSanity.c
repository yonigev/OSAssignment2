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

int flag1 = 0, flag2 = 0, flag3 = 0;
char buf[4096];
int debug = 0;

//Assignment 2: task 2.1.4:
typedef void (*sighandler_t)(int);

test_SIGKILL() {
    printf(1, "Starting test_SIGKILL\n");
    int parent_pid = getpid();
    int pid = fork();
    if (pid == 0) {
        sleep(10);
        printf(1, "E :process killed, should not get here\n");
    } else {
        kill(pid, SIGKILL);
        wait();
    }
    printf(1, "test_SIGKILL passed");
}



int main(){
    test_SIGKILL();
    printf(1, "All Tests PASSED\n");
}