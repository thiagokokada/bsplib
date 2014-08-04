

















#ifndef BSPTYPES_H
#define BSPTYPES_H

#if SIZEOF_UNSIGNED_CHAR == 1
typedef unsigned char bsp_uint8;
#endif

#if SIZEOF_UNSIGNED_SHORT_INT == 2
typedef unsigned short int bsp_uint16;
#endif

#ifdef CRAYMPP
typedef unsigned short int bsp_uint32;
#else
#if SIZEOF_UNSIGNED_INT == 4
typedef unsigned int bsp_uint32;
#else
#if SIZEOF_UNSIGNED_LONG_INT == 4
typedef unsigned long int bsp_uint32;
#endif
#endif
#endif

#if SIZEOF_UNSIGNED_LONG_LONG_INT == 8
typedef unsigned long long int bsp_uint64;
#endif



#if SIZEOF_SHORT_INT == 2
typedef short int bsp_int16;
#endif

#ifdef CRAYMPP
typedef short int bsp_int32;
#else
#if SIZEOF_INT == 4
typedef int bsp_int32;
#else
#if SIZEOF_LONG_INT == 4
typedef long int bsp_int32;
#endif
#endif
#endif

#if SIZEOF_LONG_LONG_INT == 8
typedef long long int bsp_int64;
#endif


#define BIT0                   0x00000001
#define BIT1                   0x00000002
#define BIT2                   0x00000004
#define BIT3                   0x00000008
#define BIT4                   0x00000010
#define BIT5                   0x00000020
#define BIT6                   0x00000040
#define BIT7                   0x00000080
#define BIT8                   0x00000100
#define BIT9                   0x00000200
#define BIT10                  0x00000400
#define BIT11                  0x00000800
#define BIT12                  0x00001000
#define BIT13                  0x00002000
#define BIT14                  0x00004000
#define BIT15                  0x00008000
#define BIT16                  0x00010000
#define BIT17                  0x00020000
#define BIT18                  0x00040000
#define BIT19                  0x00080000
#define BIT20                  0x00100000
#define BIT21                  0x00200000
#define BIT22                  0x00400000
#define BIT23                  0x00800000
#define BIT24                  0x01000000
#define BIT25                  0x02000000
#define BIT26                  0x04000000
#define BIT27                  0x08000000
#define BIT28                  0x10000000
#define BIT29                  0x20000000
#define BIT30                  0x40000000
#define BIT31                  0x80000000

typedef struct bspeth_macaddr bspeth_macaddr_t;
struct bspeth_macaddr { unsigned char macaddr[6]; };
#endif


