#include "bsp.h"

void spmd_start();
char usage_str[] = "-p <number of processes>";
int nprocs=0;

int reverse(int x) {
  bsp_push_reg(&x,sizeof(int));
  bsp_sync();
  
  bsp_put(bsp_nprocs()-bsp_pid()-1,&x,&x,0,sizeof(int));
  bsp_sync();
  bsp_pop_reg(&x);
  return x;
}

void spmd_start() {
  int xbefore, xafter, i;
  
  bsp_begin(nprocs);
    xbefore = bsp_pid();
    xafter  = reverse(xbefore);
    for(i=0;i<bsp_nprocs();i++) {
      if (bsp_pid()==i) 
        printf("On %d Reverse(%d)=%d\n",bsp_pid(),xbefore,xafter);
      fflush(stdout);
      bsp_sync();
    } 
  bsp_end();   
}

void main(int argc, char* argv[]) {
  int i,temp, command_line_opts=1;
  double trash;

  bsp_init(spmd_start,argc,argv);
  i=1;
  while (command_line_opts) {
    if (i >= argc) {
      command_line_opts = 0;
    } else if ( (strcmp(argv[i],"-p")==0) &&
                (sscanf(argv[i+1],"%d",&temp))) {
      nprocs = temp;
      i += 2;
    } else {
      bsp_abort("{%s}: unknown option \"%s\"\n\t%s\n",
                argv[0],argv[i],usage_str);
    }
  }
  if (nprocs<1) bsp_abort("{%s} usage: %s",argv[0],usage_str);
  spmd_start();
  exit(0);
}
