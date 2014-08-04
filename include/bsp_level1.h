




















#ifdef __cplusplus
#define LINKAGE "C"
#else
#define LINKAGE 
#endif








extern LINKAGE void bsp_bcast(int,void*,void*,int);
extern LINKAGE void bsp_bcast_cpp(int,void*,void*,int,int,char*);
extern LINKAGE void bsp_gather(int,void*,void*,int);
extern LINKAGE void bsp_scatter(int,void*,void*,int);
/* 
extern void bsp_scan(void (*)(),void*,void*,int);
extern void bsp_fold(void (*)(),void*,void*,int);
*/
extern LINKAGE int    bsp_all(int);
extern LINKAGE int    bsp_any(int);
extern LINKAGE int    bsp_constantI(int);
extern LINKAGE int    bsp_sumI(int);
extern LINKAGE float  bsp_sumR(float);
extern LINKAGE double bsp_sumD(double);
extern LINKAGE int    bsp_sumI_prefix(int);
extern LINKAGE float  bsp_sumR_prefix(float);
extern LINKAGE double bsp_sumD_prefix(double);
extern LINKAGE int    bsp_productI(int);
extern LINKAGE float  bsp_productR(float);
extern LINKAGE double bsp_productD(double);
extern LINKAGE int    bsp_productI_prefix(int);
extern LINKAGE float  bsp_productR_prefix(float);
extern LINKAGE double bsp_productD_prefix(double);
extern LINKAGE int    bsp_minI(int);
extern LINKAGE float  bsp_minR(float);
extern LINKAGE double bsp_minD(double);
extern LINKAGE int    bsp_maxI(int);
extern LINKAGE float  bsp_maxR(float);
extern LINKAGE double bsp_maxD(double);
extern LINKAGE int    bsp_minI_prefix(int);
extern LINKAGE float  bsp_minR_prefix(float);
extern LINKAGE double bsp_minD_prefix(double);
extern LINKAGE int    bsp_maxI_prefix(int);
extern LINKAGE float  bsp_maxR_prefix(float);
extern LINKAGE double bsp_maxD_prefix(double);

/* extern void   bsp_sort(int (*), void*,void*,int); */
extern LINKAGE int    bsp_sortI(int);
extern LINKAGE float  bsp_sortR(float);
extern LINKAGE double bsp_sortD(double);
extern LINKAGE char   bsp_sortC(char);

extern LINKAGE double  bsp_s();
extern LINKAGE double  bsp_l();
extern LINKAGE double  bsp_g();
extern LINKAGE int     bsp_nhalf();

#define bsp_bcast(p,s,d,n) bsp_bcast_cpp(p,s,d,n,__LINE__,__FILE__)
#define bsp_fold(f,s,d,n)  bsp_fold_cpp(f,s,d,n,__LINE__,__FILE__)


