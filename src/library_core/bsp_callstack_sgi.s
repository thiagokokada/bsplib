#include <regdef.h>
#include <asm.h>

	# cs_regs(long int *ra,*sp)
LEAF(cs_regs)
	PTR_S	ra, 0(a0)
	PTR_S	sp, 0(a1)
	j	ra
	nada
	.end	cs_regs
