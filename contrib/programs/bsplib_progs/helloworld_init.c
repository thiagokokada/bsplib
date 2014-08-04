#include "bsp.h"
#include "bsp_level1.h"
#include <stdio.h>

int nprocs; /* global variable */

int ReadInteger() {
  int result;
  scanf("%d",&result);
  return result;
}

void spmd_part(void) {
  bsp_begin(nprocs);
    printf("Hello BSP Worldwide from process %d of %d\n",
           bsp_pid(),bsp_nprocs());      
  bsp_end();   
}

void main(int argc, char *argv[]) {
  bsp_init(spmd_part,argc,argv);
  printf("How many processes should I start ? ");fflush(stdout);
  nprocs=ReadInteger();
  spmd_part();
}
