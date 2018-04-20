#include "types.h"
#include "user.h"
#include "stat.h"
#include "x86.h"
typedef   void (*sighandler_t ) (int) ;








void gotTen(int signum);
void infinite();
void handler1();
int increment();

void handler2(){
    printf(1,"this is handler TWO!\n");
}
int globalInt=0;
int main(){

    int res1=increment();
    printf(1,"res1 is: %d\n",res1);
    int res2=increment();
    printf(1,"res1 is: %d\n",res2);
    int res3=increment();    
    printf(1,"res1 is: %d\n",res3);
    printf(1,"globalInt is: %d\n",globalInt);



    
    // printf(1,"GOTTEN IS: %d\n",gotTen);
    // int pid1;
    // if((pid1=fork())==0){
    //     infinite();
    // }
    // printf(1,"Child pid: %d\n",pid1);



    //wait();
    exit();
}
int increment(){
    return cas(&globalInt,globalInt,globalInt+1);
}

void gotTen(int signum){
    printf(1,"Got signal 10, changing handler to Handler1\n");
    signal(10,(sighandler_t)handler1);
    printf(1,"...Changed!. \n");
//    register int sp asm ("sp");
//    int *a=(int*)sp;
//    printf(1,"SP IS %p", a[0]);
    return;
    //exit();
}



void infinite(){
    sighandler_t pointer= (sighandler_t)gotTen;
    printf(1,"signaling..\n");
    signal(10,pointer);
    printf(1,"Infinite....\n");
    while(1){
        printf(1,"in infinite() .........\n");
        sleep(200);

    }
}
void handler1(){
    printf(1,"this is handler ONE!\n");
    exit();
}