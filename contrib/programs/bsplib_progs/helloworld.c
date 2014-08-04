#include "bsp.h"
#include <stdio.h>

void main(void) {
  bsp_begin(bsp_nprocs());
    printf("Hello BSP Worldwide from process %d of %d\n",
           bsp_pid(),bsp_nprocs());
  bsp_end();
}

