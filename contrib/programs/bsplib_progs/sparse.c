#include "bsp.h"
#include <stdlib.h>

#define SIZE 10

void spmd_start();
char usage_str[] = "-p <number of processes> -n <local array size>";
int nprocs=0;
int size=5;

int all_gather_sparse_vec(float *dense,int n_over_p,
                          float **sparse_out,
                          int **sparse_ivec_out){
  int global_idx,i,j,tag_size,
      nonzeros,nonzeros_size,status, *sparse_ivec;
  float *sparse;
  
  tag_size = sizeof(int);
  bsp_set_tagsize(&tag_size);
  bsp_sync();

  for(i=0;i<n_over_p;i++) 
    if (dense[i]!=0.0) {
      global_idx = (n_over_p * bsp_pid())+i;
      for(j=0;j<bsp_nprocs();j++)
        bsp_send(j,&global_idx,&dense[i],sizeof(float));
    }
  bsp_sync();

  bsp_qsize(&nonzeros,&nonzeros_size);
  if (nonzeros>0) {
    sparse      = calloc(nonzeros,sizeof(float));
    sparse_ivec = calloc(nonzeros,sizeof(int));
    if (sparse==NULL || sparse_ivec==NULL)
      bsp_abort("Unable to allocate memory");
    for(i=0;i<nonzeros;i++) {
      bsp_get_tag(&status,&sparse_ivec[i]);
      if (status!=sizeof(float)) 
         bsp_abort("Should never get here");
      bsp_move(&sparse[i],sizeof(float));
    }
  }
  bsp_set_tagsize(&tag_size);
  *sparse_out      = sparse;
  *sparse_ivec_out = sparse_ivec;
  return nonzeros;
}

void spmd_start() {
  int i,j;
  float *sparse, *dense;
  int   *sparse_ivec,sparse_size;
  
  bsp_begin(nprocs);
    bsp_push_reg(&size,sizeof(int));
    bsp_sync();
    bsp_bcast(0,&size,&size,sizeof(int));
    dense = (float*) calloc(size,sizeof(int));
    if (dense==NULL) bsp_abort("Not enough memory");

    srand(bsp_pid()*1000);
    for(i=0;i<size;i++) dense[i]=(rand()>>2) % 3;

    sparse_size=all_gather_sparse_vec(dense,size, &sparse, &sparse_ivec);
    for(i=0;i<bsp_nprocs();i++) {
      if (bsp_pid()==i) { 
	printf("On %d local dense= ",bsp_pid());
	for(j=0;j<size;j++) printf("%.1f ",dense[j]);
        printf("\n"
	       "On %d all sparse = ",bsp_pid());
	for(j=0;j<sparse_size;j++)
	  printf("(%d,%.1f) ",sparse_ivec[j],sparse[j]);
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
      size = temp;
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

