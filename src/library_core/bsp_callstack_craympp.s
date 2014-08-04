	.ident $_cs_regfp
	.start cs_regfp
	.PSECT code_sec, code
cs_regfp::
	bis     R15,R15,r0
	ret     R31,(r26)
	.end  $_cs_regfp

