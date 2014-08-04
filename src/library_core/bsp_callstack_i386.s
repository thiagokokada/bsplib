.text
.globl	cs_regsp		/* long int cs_getsp(); */
.type	cs_regsp,@function	
.globl	_cs_regsp		/* long int cs_getsp(); */
.type	_cs_regsp,@function	

cs_regsp:	
_cs_regsp:
	movl	%ebp,%eax
	ret
	
