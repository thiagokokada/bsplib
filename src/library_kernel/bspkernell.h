


















#ifndef BSP_KERNELL_H
#define BSP_KERNELL_H

int bspkern_connect(int pid,bspeth_macaddr_t smac,
		    int nprocs,size_t space, 
		    int bufsize, int nobuffers);
char *bspkern_malloc(size_t size);
bspudp_buff_t *bspkern_buffer(void);
int bspkern_sendto(int pid, char *buff, int len,int lineno,char *file);
int bspkern_recv(bspudp_msghdr_t *buff);
int bspkern_select(struct timeval *timeout);
int bspkern_initfinish(void);
int bspkern_pktsent(bspudp_msghdr_t *msg);
int bspkern_markdata_withack(void);

#define recvfrom(sock,buff,len,flags,addr,addr_len) \
   (bspkern_recv((bspudp_msghdr_t*) (buff)))

#define sendto(sock,buff,len,flags,addr,addr_len)\
   bspkern_sendto(((bspudp_msghdr_t*) (buff))->msgdpid,(buff),(len),\
                  __LINE__,__FILE__)

#define select(n,readfds,writefds,exceptfds,timeout) \
   bspkern_select(timeout)
#endif


