#include "types.h"
#include "user.h"
#include "stat.h"

void infinite(){
    signal(3,got3);
    while(1){


    }
}
void got3(){
    printf(1,"Got signal 3\n");
    exit();
}

int main(){


    int pid1;
    if((pid1=fork())==0){
        infinite();
    }
    else {
        printf(1, "Child pid: %d\n", pid1);


    }




    exit();
}