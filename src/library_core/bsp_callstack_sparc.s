.text
	.global cs_regsp
	.global _cs_regsp
/* int cs_regsp()  returns sp
This ensures that all windows are saved on the stack, so that the return
addresses of the functions can be examined. If there are more than 10 windows
on the particular processor, then some more pairs of save-restore should be 
added.  */
	
_cs_regsp:
cs_regsp:
	save %sp, -64, %sp
	save %sp, -64, %sp
	save %sp, -64, %sp
	save %sp, -64, %sp
	save %sp, -64, %sp
	save %sp, -64, %sp
	save %sp, -64, %sp
	save %sp, -64, %sp
	restore
	restore
	restore
	restore
	restore
	restore
	restore
	restore

/* As there is no save-restore made, this function uses its parent''s
registers. I.e. before save and after restore, %o0=%i0 . Therefore the return
value should be in %o0 instead of %i0. */
	
	mov	%sp,%o0

	retl
	nop

/* return from leaf subroutine	;  executes 1 instruction after the jump */
