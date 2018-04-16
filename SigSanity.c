#include "types.h"
#include "user.h"
#include "stat.h"

typedef   void (*sighandler_t ) (int) ;








int gotTen(){
    printf(1,"Got signal 10\n");
    exit();
}

void infinite(){
    sighandler_t pointer= (sighandler_t)gotTen;
    signal(10,pointer);
    printf(1,"got10 is: %p\n",pointer);
    while(1){


    }
}

int main(){

    printf(1,"GOTTEN IS: %d\n",gotTen);
    int pid1;
    if((pid1=fork())==0){
        infinite();
    }
    printf(1,"Child pid: %d\n",pid1);




    exit();
}