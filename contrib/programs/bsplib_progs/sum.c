#include "bsp.h"
#include <stdlib.h>

void spmd_start();
char usage_str[] = "-p <number of processes>";
int nprocs=0;

int bsp_sum(int *xs, int nelem) {
  int *local_sums,i,j,result=0;
  for(j=0;j<nelem;j++) result += xs[j];
  bsp_push_reg(&result,sizeof(int));
  bsp_sync();

  local_sums = calloc(bsp_nprocs(),sizeof(int));
  if (local_sums==NULL)
    bsp_abort("{bsp_sum} no memory for %d int",bsp_nprocs());
  for(i=0;i<bsp_nprocs();i++)
    bsp_hpget(i,&result,0,&local_sums[i],sizeof(int));
  bsp_sync();

  result=0;
  for(i=0;i<bsp_nprocs();i++) result += local_sums[i];
  bsp_pop_reg(&result); 
  free(local_sums);
  return result;
}

void spmd_start() {
  int i,j,*xs,size,sum;
  
  bsp_begin(nprocs);
    size = bsp_nprocs()+bsp_pid();
    xs   = calloc(size,sizeof(int));
    for(i=0;i<size;i++) xs[i]=i;

    sum = bsp_sum(xs,size);
    for(i=0;i<bsp_nprocs();i++) {
      if (bsp_pid()==i) {
        printf("On %d Sum(",bsp_pid());
        for(j=0;j<size;j++) printf("%d ",xs[j]);
        printf(")=%d\n",sum);
      }
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

