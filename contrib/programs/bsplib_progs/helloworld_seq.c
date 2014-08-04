#include "bsp.h"

void main(void) {
  int i;
  bsp_begin(bsp_nprocs());
    for(i=0; i<bsp_nprocs(); i++) {
      if (bsp_pid()==i) 
        printf("Hello BSP Worldwide from process %d of %d\n",
               i,bsp_nprocs()); 
      fflush(stdout);
      bsp_sync();
    }  
  bsp_end();   
}
