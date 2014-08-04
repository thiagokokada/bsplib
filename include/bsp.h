





























#ifndef _BSP_H
#define _BSP_H
#include <stdio.h>
#ifdef __cplusplus
#define LINKAGE "C"
#else
#define LINKAGE 
#endif






extern LINKAGE int    bsp_pid();
extern LINKAGE int    bsp_nprocs();

extern LINKAGE void   bsp_abort(char*,...);
extern LINKAGE double bsp_time();
extern LINKAGE double bsp_cputime();
extern LINKAGE double bsp_dtime();

extern LINKAGE void   bsp_init(void (*)(void),int,char**);
extern LINKAGE void   bsp_init_cpp(void (*)(void),int,char**,
				   int,const char*);
extern LINKAGE void   bsp_fix_argv(int *, char ***);
extern LINKAGE void   bsp_begin(int);
extern LINKAGE void   bsp_end();

extern LINKAGE void   bsp_sync();
extern LINKAGE void   bsp_sync_end();
extern LINKAGE void   bsp_sync_cpp(int,const char*);

extern LINKAGE void   bsp_pushregister(const void*,int);
extern LINKAGE void   bsp_popregister(const void*);
extern LINKAGE void   bsp_push_reg(const void*,int);
extern LINKAGE void   bsp_pop_reg(const void*);
extern LINKAGE void   bsp_push_reg_cpp(const void*,int,int,const char*);
extern LINKAGE void   bsp_pop_reg_cpp(const void*,int,const char*);

extern LINKAGE void   bsp_qsize(int *,int *);
extern LINKAGE void   bsp_qsize_cpp(int *, int*,int,const char*);

extern LINKAGE void   bsp_get(int,const void*,int,void*,int);
extern LINKAGE void   bsp_get_cpp(int,const void*,int,void*,int,
                                  int,const char*);
extern LINKAGE void   _bsp_get(int,const void*,int,void*,int);

extern LINKAGE void   bsp_hpget(int,const void*,int,void*,int);
extern LINKAGE void   bsp_hpget_cpp(int,const void*,int,void*,int,
                                    int,const char*);

extern LINKAGE void   bsp_put(int,const void*,void*,int,int);
extern LINKAGE void   bsp_put_cpp(int,const void*,void*,int,int,
                                  int,const char*);
extern LINKAGE void  _bsp_put(int,const void*,int,int,int);

extern LINKAGE void   bsp_hpput(int,const void*,void*,int,int);
extern LINKAGE void   bsp_hpput_cpp(int,const void*,void*,int,int,
                                    int,const char*);

extern LINKAGE void   bsp_set_tag_size(int*);
extern LINKAGE void   bsp_set_tagsize(int*);
extern LINKAGE void   bsp_set_tagsize_cpp(int*,int,const char *);

extern LINKAGE void   bsp_send(int,const void*,const void*,int);
extern LINKAGE void   bsp_send_cpp(int,const void*,const void*,int,
                                   int,const char *);

extern LINKAGE void   bsp_get_tag(int *,void*);
extern LINKAGE void   bsp_get_tag_cpp(int *,void*,int,const char*);

extern LINKAGE void   bsp_move(void *,int);
extern LINKAGE void   bsp_move_cpp(void *,int,int,const char*);

extern LINKAGE int    bsp_hpmove(void**,void**);
extern LINKAGE int    bsp_hpmove_cpp(void**,void**,int,const char*);





extern LINKAGE void  bsp_debug(char*,...);
extern LINKAGE int   _bsp_constant(int);

extern LINKAGE char  *_bsp_register_global_to_local(int,int);
extern LINKAGE int   _bsp_register_local_to_global_cpp(const void*);
extern LINKAGE void  bsp_register_info(int,int,int*,int*,char**);
extern LINKAGE int   bsp_register_nbytes(int,int);
extern LINKAGE int   bsp_register_total();
extern LINKAGE void  bsp_changeregister(const void*,const void*,const int,int);

extern LINKAGE void  bsp_error_reg_small(int,int,int,int);
extern LINKAGE void  bsp_error_sync_out_of_phase(int lineno, char *filename);
extern LINKAGE void  bsp_debug_block(char*,...);
extern LINKAGE void  bsp_debug_start(char*);
extern LINKAGE void  bsp_debug_end(char*);
extern LINKAGE char *bsp_pprbytes(int);
extern LINKAGE char *bsp_strdup(const char*);
extern LINKAGE char *bsp_f77str_cstr(const char *,int);
extern LINKAGE int   hashpjw(const char*);

extern LINKAGE void bspprof_sstep_start();
extern LINKAGE void bspprof_sstep_fix();
extern LINKAGE void bspprof_sstep_end();
extern LINKAGE void bspstat_init();
extern LINKAGE void bspstat_create();
extern LINKAGE void bspstat_incoming(int,int);
extern LINKAGE void bspstat_outgoing(int,int);
extern LINKAGE void bspstat_finalise();
extern LINKAGE void bspstat_close();
extern LINKAGE void bsp_bcast_stat(FILE *);

extern LINKAGE void bspparams_init();
extern LINKAGE void bsp_bcast_init();
extern LINKAGE void bsp_scan_init();
extern LINKAGE void bsp_fold_init();
extern LINKAGE void bsp_fold_funs_init();
extern LINKAGE void bsp_f77_init();





extern LINKAGE double bsp_s();
extern LINKAGE double bsp_l();
extern LINKAGE double bsp_g();
extern LINKAGE int   bsp_nhalf();




extern LINKAGE void _bsp_dissemination_barrier();
extern LINKAGE void _bsp_busywait_counter_barrier();
extern LINKAGE void _bsp_nonbusywait_counter_barrier();
extern LINKAGE void _bsp_busywait_vector_counter_barrier();
extern LINKAGE void _bsp_atomic_counter_barrier();
extern LINKAGE void _bsp_software_barrier();
extern LINKAGE int  _bsp_software_gather(int,int,int,const void*,void*,int);
extern LINKAGE int  _bsp_software_broadcast(int,int,int,void*,int);
extern LINKAGE void _bsp_software_nonblocksend_blockrecv(const void*,int,int,
                                                         int,void*,int,
                                                         int*,int*);






extern LINKAGE int   _bsp_pid;
extern LINKAGE int   _bsp_nprocs;
extern LINKAGE int   _bsp_fork_nprocs;
extern LINKAGE int   _bsp_lineno;
extern LINKAGE char *_bsp_filename;

/* Used when tuneing performance */
extern LINKAGE int BSP_SNOOZE_TILL_SLEEP;
extern LINKAGE int BSP_SNOOZE_MIN;












#define bsp_init(fn,argc,argv)                     \
  do {                                             \
    bsp_init_cpp(fn,argc,argv,__LINE__,__FILE__);  \
    bsp_fix_argv(&(argc),&(argv));                 \
  } while(0)

#define bsp_sync()             bsp_sync_cpp(__LINE__,__FILE__)
#define bsp_push_reg(id,s)     bsp_push_reg_cpp(id,s,__LINE__,__FILE__)
#define bsp_pop_reg(id)        bsp_pop_reg_cpp(id,__LINE__,__FILE__)
#define bsp_put(p,s,d,o,n)     bsp_put_cpp(p,s,d,o,n,__LINE__,__FILE__)
#define bsp_hpput(p,s,d,o,n)   bsp_hpput_cpp(p,s,d,o,n,__LINE__,__FILE__)
#define bsp_get(p,s,o,d,n)     bsp_get_cpp(p,s,o,d,n,__LINE__,__FILE__)
#define bsp_hpget(p,s,o,d,n)   bsp_hpget_cpp(p,s,o,d,n,__LINE__,__FILE__)
#define bsp_send(p,t,d,n)      bsp_send_cpp(p,t,d,n,__LINE__,__FILE__)
#define bsp_get_tag(s,t)       bsp_get_tag_cpp(s,t,__LINE__,__FILE__) 
#define bsp_move(p,r)          bsp_move_cpp(p,r,__LINE__,__FILE__)
#define bsp_hpmove(p,r)        bsp_hpmove_cpp(p,r,__LINE__,__FILE__)
#define bsp_set_tagsize(t)     bsp_set_tagsize_cpp(t,__LINE__,__FILE__)
#define bsp_qsize(p,s)         bsp_qsize_cpp(p,s,__LINE__,__FILE__)




#define bsp_pushregister(id,s) bsp_push_reg_cpp(id,s,__LINE__,__FILE__)
#define bsp_popregister(id)    bsp_pop_reg_cpp(id,__LINE__,__FILE__)
#define bsp_set_tag_size(t)    bsp_set_tagsize_cpp(t,__LINE__,__FILE__)
#define bsp_bsmp_info(p,s)     bsp_qsize_cpp(p,s,__LINE__,__FILE__)







extern LINKAGE void   bspfetch(int,void*,void*,int);
extern LINKAGE void   bspstore(int,void*,void*,int);
extern LINKAGE void   bspsstep(int);
extern LINKAGE void   bspsstep_end(int);
extern LINKAGE void   bspstart(int,char**,int,int*,int*);
extern LINKAGE void   bspfinish();
extern LINKAGE double bsptime();
extern LINKAGE double bspdtime();
extern LINKAGE void   bspreduce(void (*)(void*,void*,void*,int),
                                void *, void *, int);
extern LINKAGE void   bspbroadcast(int, void *, void *, int);

extern char _bsp_miller_reference;
#define bspstore(pid,src,dst,nbytes)                \
  bsp_put_cpp(pid,src,&_bsp_miller_reference,       \
              (char*)dst - &_bsp_miller_reference,  \
               nbytes,__LINE__,__FILE__)

#define bspfetch(pid,src,dst,nbytes)              \
  bsp_get_cpp(pid,&_bsp_miller_reference,         \
              (char*)src-&_bsp_miller_reference,  \
              dst,nbytes,__LINE__,__FILE__)

#define bspsstep(sstepid)     /* Do nothing */
#define bspsstep_end(sstepid) bsp_sync_cpp(__LINE__,__FILE__)
#endif


