#include "bsp.h"
#include <stdlib.h>

void spmd_start();
char usage_str[] = "-p <number of processes> -n <global array size>";
int nprocs=0;
int N=10;

void get_array(int *xs, int n) {
  int i,pid,local_idx,n_over_p=n/bsp_nprocs();
  if (n % bsp_nprocs()) 
    bsp_abort("{get_array} %d not divisible by %d",
              n,bsp_nprocs());
  bsp_push_reg(xs,n_over_p*sizeof(int));
  bsp_sync();

  for(i=0;i<n_over_p;i++) {
    pid       = xs[i]/n_over_p;
    local_idx = xs[i]%n_over_p;
    bsp_get(pid,xs,local_idx*sizeof(int),&xs[i],sizeof(int));
  }
  bsp_sync();
  bsp_pop_reg(xs);
}

void spmd_start() {
  int i,j,*xs,*ys,sum,n_over_p;
  
  bsp_begin(nprocs);
    bsp_push_reg(&N,sizeof(int));
    bsp_sync();
    bsp_bcast(0,&N,&N,sizeof(int));
    n_over_p=N/bsp_nprocs();
    xs   = calloc(n_over_p,sizeof(int));
    ys   = calloc(n_over_p,sizeof(int));
    if (xs==NULL || ys==NULL) bsp_abort("Not enough memory");
    for(i=0;i<n_over_p;i++) {
      xs[i]=(n_over_p*(bsp_nprocs()-1-bsp_pid()))+(n_over_p-1-i);
      ys[i]=xs[i];
    }

    get_array(xs,N);
    for(i=0;i<bsp_nprocs();i++) {
      if (bsp_pid()==i) {
        printf("On %d before=",bsp_pid());
        for(j=0;j<n_over_p;j++) printf("%d ",ys[j]); 
        printf("\n");
        printf("On %d after =",bsp_pid());
        for(j=0;j<n_over_p;j++) printf("%d ",xs[j]); 
        printf("\n\n");
        fflush(stdout);
      }
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
    } else if ( (strcmp(argv[i],"-n")==0) &&
                (sscanf(argv[i+1],"%d",&temp))) {
      N = temp;
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
