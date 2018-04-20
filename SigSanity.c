//
// Created by gilan on 4/16/18.
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

#define SIG_DFL -1

int flag1=0, flag2=0, flag3=0;
char buf[4096];
int debug = 0;

//Assignment 2: task 2.1.4:
typedef void (*signalhandler_t)(int);

int
open_file(char *name){
    return open(name, O_CREATE|O_RDWR);
}

void
write_file(char *buffer){
    int fd = open("tmp", O_CREATE|O_RDWR);
    write(fd, buffer, strlen(buffer));
    close(fd);
}

void
compare_file(char *src){
    int fd = open("tmp", O_RDWR);
    read(fd, buf, strlen(src));
    int i, correct = 1;
    if (debug) {
        buf[strlen(src)] = '\0';
        printf(1,"Comparing string %s with string %s\n",src,buf);
    }
    for (i = 0 ; i < strlen(src) ; i++)
        if (*(src+i) != *(buf+i)){
            correct = 0;
            break;
        }
    close(fd);
    if (!correct){
        printf(1,"Test failed on compare(\"%s\")!\n",src);
        exit();
    }
}

void
loop1(){
    volatile int i;
    for(i=0; i<50000; i++){
        printf(1,"aaaaaaaaaaaaaaaa");
    }
}

void
loop2(){
    volatile int i;
    for(i=0; i<500000; i++){
        printf(1,"bbbbbbbbbbb");
    }
}

void
loop3(){
    volatile int i;
    for(i=0; i<5000000; i++){
        printf(1,"cccccccccc");
    }
}

signalhandler_t
custom_handler(int signum){
    if (debug) printf(1,"Entered custom_handler\n");
    write_file("1");
    flag1 = 1;
    return 0;
}

signalhandler_t
custom_handler2(int signum){
    if (debug) printf(1,"Entered custom_handler2\n");
    compare_file("1");
    write_file("2");
    flag2 = 1;
    return 0;
}

signalhandler_t
custom_handler3(int signum){
    if (debug) printf(1,"Entered custom_handler3\n");
    compare_file("2");
    write_file("3");
    flag3 = 1;
    return 0;
}

signalhandler_t
custom_handler4(int signum){
    if (debug) printf(1,"Entered custom_handler4\n");
    write_file("1");
    flag1 = 1;
    kill(getpid(),29);
    return 0;
}

void
kill_test(){
    printf(1,"kill_test\n");
    int father_pid = getpid();
    /*int fd = open("tmp", O_CREATE | O_RDWR);
    write(fd,"aaaaa",5);
    close(fd);*/
    /*write_file("aa");
    write_file("bbb");
    printf(1,"The compare got %s\n",compare_file("bbb")?"TRUE":"FALSE");*/
    int p = fork();
    if (p == 0){
        sleep(10);
        printf(1,"ERROR: Child process not killed!\n");
        kill(father_pid, SIGKILL);
        exit();
    }
    else{
        kill(p, SIGKILL);
        sleep(50);
        wait();
    }
    printf(1,"kill_test passed\n");
}

void
stop_test(){
    printf(1,"stop_test\n");
    int father_pid = getpid();
    int p = fork();
    if (p ==0){
        sleep(20);
        printf(1,"ERROR: child process not stopped!\n");
        kill(father_pid,SIGKILL);
        exit();
    }
    else {
        kill(p, SIGSTOP);
        sleep(10);
        kill(p, SIGKILL);
        kill(p, SIGCONT);
        wait();
    }
    printf(1,"stop_test passed\n");
}


void
cont_test(){
    printf(1,"cont_test\n");
    signal(2,(signalhandler_t)4);
    int p = fork();
    printf(1,"child is: %d\n",p);
    if (p ==0){
        sleep(10);
        sleep(10);
        printf(1,"child woke up-comparing 213\n");
        compare_file("213");
        printf(1,"child writing 3\n");
        write_file("3");
        /*   int p1 = fork();
         if (p1 == 0) {
              printf(1,"ERROR: SIGSTOP didn't work\n");
              exit();
          }*/
        exit();
    }
    else {
        printf(1,"father stops p\n");
        kill(p, SIGSTOP);
        printf(1,"father writing 12\n");
        write_file("12");
        sleep(100);
        printf(1,"father comparing to 12\n");
        compare_file("12");
        printf(1,"father writing 213\n");
        write_file("213");
        sleep(20);
        kill(p, SIGCONT);
        wait();
        compare_file("3");
    }
    printf(1,"cont_test passed\n");
}


void
ignore_signals_test(){
    printf(1,"ignore_signals_test\n");
    int father_pid = getpid();
    int p = fork();
    if (p == 0) {
        
        signal(SIGKILL,(signalhandler_t)SIG_IGN);//1 - child ignores SIGKILL
        write_file("Child didn't ignore SIGKILL"); //3 - child is supposed to print this message
        sleep(20);
        compare_file("b");
        write_file("c");
        signal(SIGKILL,(signalhandler_t)SIGKILL); //4 - child restores SIGKILL handler to default (process should die)
        sleep(50);//child handles SIGKILL after this line
        write_file("d");
        sleep(50);//safety wait
        printf(1,"ERROR: Ignoring SIGKILL!\n");
        kill(father_pid,SIGKILL);
        exit();
    }
    else {
        printf(1,"CHILD ID: %d\n",p);
        sleep(5);
        kill(p,SIGKILL);//2 - father tries to send SIGKILL to child, should be ignored
        compare_file("Child didn't ignore SIGKILL");
        write_file("b");
        sleep(40);
        kill(p,SIGKILL);//5 - father tries to send SIGKILL to child, should be executed
        wait();
        compare_file("c");
    }
    printf(1,"ignore_signals_test passed\n");
}

void
custom_handler_test(){
    printf(1,"custom_handler_test\n");
    int p = fork();
    int n;
    if (p == 0) {
        if ((int)(n = ((int)signal(1, (signalhandler_t)custom_handler))) != (int)SIG_DFL) {
            printf(1,"Error: expected signal func return value is %x but got %x\n",SIG_DFL,n);
            exit();
        }
        sleep(10);//3 - After this sleep, the custom handler should execute
        sleep(80);
        compare_file("2");//6
        sleep(50);
        write_file("3");//7
        exit();
    }
    else {
        sleep(5);
        kill(p, 1); //2
        sleep(50);
        compare_file("1"); //4 - making sure custom handler executed
        write_file("2");//5
        wait();
        compare_file("3");//8
        printf(1,"custom_handler_test passed\n");
    }
}

void
multiple_handlers_test(){
    printf(1,"multiple_handlers_test\n");
    int father_pid = getpid();
    int p = fork();
    if (p == 0) {
        signal(24, (signalhandler_t)(custom_handler));
        signal(26, (signalhandler_t)(custom_handler2));
        signal(28, (signalhandler_t)(custom_handler3));
        sleep(50);//After this sleep, the custom handlers should execute
        if (!flag1 || !flag2 || !flag3){ //all custom handlers should set the flags to 1 -> condition should fail
            kill(father_pid, SIGKILL);
            printf(1,"ERROR: custom handlers didn't execute\n");
        }
        exit();
    }
    else {
        sleep(20);
        kill(p,24);
        kill(p,26);
        kill(p,28);
        wait();
        compare_file("3");
        printf(1,"multiple_handlers_test passed\n");
    }
}

//Irrelevant according to forum query subject: "Ignoring and changing SIGSTOP, SIGCONT and SIGKIL" by azrielsh
void
custom_cont_test(){    
    printf(1,"custom_cont_test\n");
    int p = fork();
    if (p == 0){
        signal(SIGCONT, (signalhandler_t)custom_handler4); //1
        //signal(29,(signalhandler_t)SIGCONT);
        sleep(10);
        sleep(50);
        write_file("b");//6
        exit();
    }
    else {
        sleep(10);
        printf(1,"tesest\n");
        kill(p, SIGSTOP); //2
        write_file("a"); //3
        sleep(100);
        compare_file("a"); //4 - p should be sleeping
        kill(p,SIGCONT);
        sleep(80);
        compare_file("1"); //5 - SIGCONT should provoke p's custom handler
        wait();
        compare_file("b");//7
    }
    printf(1,"custom_cont_test passed\n");
}

void
shell_signal_test(){
    printf(1,"shell_signal_test\n");
    int p = fork();
    if (p == 0) {
        sigprocmask(~(1<<22));
        exec("sh",(char*[]){ "sh", 0 });
        exit();
    }
    else {
        sleep(10);
        printf(1,"Please enter \"kill %d 22\" to screen\n",p);
        wait();
    }
    printf(1,"shell_signal_test passed\n");
}

void
signal_inheritance_test(){
    printf(1,"signal_inheritance_test\n");
    //int n;

    /*if ((n = ((int)signal(10, (signalhandler_t)SIG_IGN))) != SIG_DFL) {
        printf(1,"Error: expected signal func return value is -1 but got %d",n);
            exit();
    }*/

    //Ignoring signals 10,15,20,25
    signal(10, (signalhandler_t)SIG_IGN);
    signal(15, (signalhandler_t)SIG_IGN);
    signal(20, (signalhandler_t)SIG_IGN);
    signal(25, (signalhandler_t)SIG_IGN);

    //Changing signal handler of signals 11,16,21,26
    signal(11, (signalhandler_t)112);
    signal(16, (signalhandler_t)113);
    signal(21, (signalhandler_t)114);
    signal(26, (signalhandler_t)115);

    int p = fork();
    if (p == 0) {
        if (sigprocmask(0) != ((1 << 10) | (1 << 15) | (1 << 20) | (1 << 25))){
            printf(1,"ERROR: Child process did not inherit mask array\n");
            exit();
        }
        if (((int)(signal(11,(signalhandler_t)SIG_DFL)) != 112) ||
            ((int)(signal(16,(signalhandler_t)SIG_DFL)) != 113) ||
            ((int)(signal(21,(signalhandler_t)SIG_DFL)) != 114) ||
            ((int)(signal(26,(signalhandler_t)SIG_DFL)) != 115)){
            printf(1,"ERROR: Child process did not inherit signal handlers\n");
            exit();
        }
        write_file("Inheritance");
        exit();
    }
    else {
        if (sigprocmask(0) != ((1 << 10) | (1 << 15) | (1 << 20) | (1 << 25))){
            printf(1,"ERROR: Parent process did not keep mask array\n");
            exit();
        }
        if (((int)(signal(11,(signalhandler_t)SIG_DFL)) != 112) ||
            ((int)(signal(16,(signalhandler_t)SIG_DFL)) != 113) ||
            ((int)(signal(21,(signalhandler_t)SIG_DFL)) != 114) ||
            ((int)(signal(26,(signalhandler_t)SIG_DFL)) != 115)){
            printf(1,"ERROR: Parent process did not keep signal handlers\n");
            exit();
        }
        wait();
        compare_file("Inheritance");
    }

    /*if (debug) printf(1,"Checking exec inheritance\n");
    
    //Checking that exec returns custom handlers to normal
    signal(6,(signalhandler_t)custom_handler);
    signal(SIGKILL,(signalhandler_t)custom_handler2);
    p = fork();
    if (p == 0){
        sleep(5);
        exec("ls",(char*[]){ "ls", 0 });
    }
    else {
        printf(1,"Please press Enter\n");
        sleep(10);
        write_file("Signal handler didn't return to default");
        sleep(50);
        kill(p,6);
        sleep(100);
        compare_file("Signal handler didn't return to defaul");
        kill(p,SIGKILL);
        wait();
    }*/
    printf(1,"signal_inheritance_test passed\n");
}

void
Various_signalhandler_tests(){
    printf(1,"Various_signalhandler_tests\n");
    int n;
    //TODO RESTORE NEXT CHECK!
    if ((n = (int)signal(SIGCONT,(signalhandler_t)50)) != SIGCONT){ 
        printf(1,"Wrong return value! Expected SIGCONT(%d) but got %d\n",SIGCONT,n);
        exit();
    }
    if ((n = (int)signal(32,(signalhandler_t)SIG_DFL)) != -2){
        printf(1,"Wrong return value! Expected -2 but got %d\n",n);
        exit();
    }

    if ((n = (int)signal(SIGCONT,(signalhandler_t)120))!= 50) {
        printf(1,"Wrong return value! Expected 50 but got %d\n",n);
        exit();
    }
    if ((n = (int)sigprocmask((1<<SIGKILL) | (1<<SIGSTOP))) != 0){
        printf(1,"Wrong sigprokmask return value! Expected 0 but got %d\n",n);
        exit();
    }
    int father_pid = getpid();
    int p = fork();
    if (p == 0){
        sleep(10);
        write_file("testing");
        kill(father_pid, SIGKILL);
        sleep(40);
        compare_file("123");
        if (sigprocmask(0) != ((1<<SIGKILL) | (1<<SIGSTOP))){
            printf(1,"Wrong sigprokmask return value!\n");
            exit();
        }
        if ((n = (int)signal(SIGCONT,(signalhandler_t)SIGCONT))!= 120) {
            printf(1,"Wrong return value! Expected 120 but got %d\n",n);
            exit();
        }
        write_file("done");
        exit();
    }
    else {
        //TODO RESTORE KILL
        kill(p,SIGKILL); //should be ignored as mask is inherited
        sleep(20);
        compare_file("testing");
        sleep(20);
        write_file("123");
        wait();
        compare_file("done");
        if (sigprocmask(0) != ((1<<SIGKILL) | (1<<SIGSTOP))){
            printf(1,"Wrong sigprokmask return value!\n");
            exit();
        }
    }
    if ((n = kill(p,SIGKILL)) != -1){
        printf(1,"Wrong kill syscall return value! Expected -1 but got %d\n",n);
        exit();
    }
    if ((n = kill(p,32)) != -1){
        printf(1,"Wrong kill syscall return value! Expected -1 but got %d\n",n);
        exit();
    }

    printf(1,"Various_signalhandler_tests passed\n");
}

int
main(int argc, char *argv[])
{
    // kill_test();
    // stop_test();
    cont_test();
    ignore_signals_test();
    custom_handler_test();
    multiple_handlers_test();
    //custom_cont_test();
    shell_signal_test();
    signal_inheritance_test();
    Various_signalhandler_tests();
    printf(1,"ALL TESTS PASSED!\n");
    exit();
}