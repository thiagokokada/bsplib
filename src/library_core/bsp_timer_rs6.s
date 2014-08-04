	   .globl  .rtc_upper
.rtc_upper: mfspr   3,4         # copy RTCU to return register
	    br


	   .globl  .rtc_lower
.rtc_lower: mfspr   3,5         # copy RTCL to return register
	    br
