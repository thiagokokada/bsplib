# Generated automatically from Makefile.in by configure.
###########################################################################
##      Copyright (C) 1995,1996,1997 University of Oxford                ##
##                                                                       ##
## Permission to use, copy, modify, and distribute this software,        ##
## and to incorporate it, in whole or in part, into other software,      ##
## is hereby granted without fee, provided that                          ##
##   (1) the above copyright notice and this permission notice appear in ##
##       all copies of the source code, and the above copyright notice   ##
##       appear in clearly visible form on all supporting documentation  ##
##       and distribution media;                                         ##
##   (2) modified versions of this software be accompanied by a complete ##
##       change history describing author, date, and modifications made; ##
##       and                                                             ##
##   (3) any redistribution of the software, in original or modified     ##
##       form, be without fee and subject to these same conditions.      ##
###########################################################################
SHELL    =/bin/sh

###########################################################################
##            D O N T  C H A N G E  A N Y T H I N G  !!                  ##
###########################################################################

prefix     = /amd/tmp_mnt/garnet/fs25/jonh/BSP
exec_prefix= ${prefix}
bindir     = ${exec_prefix}/bin
includedir = ${prefix}/include
libdir     = ${exec_prefix}/lib
top_srcdir = ..
mandir     = ${prefix}/man

PERL            = /users/jonh/bin/perl
PERL_DBMOK      = 1
DAVINCI         = /fs/fs10/bsplib/daVinci_V2.0.Solaris//daVinci
GCC             = gcc
G77             = f2c
GPLUSPLUS       = g++
INSTALL         = .././install-sh -c
INSTALL_PROGRAM = ${INSTALL}

BSP_DEFAULT_SLOTSIZE   = 140
BSP_DEFAULT_NOSLOTS    = 1
BSP_DEFAULT_ROUNDTRIP  = 200
BSP_DEFAULT_SENDLATENCY= 100
BSPARCH_DEFAULT_DEVICE = MPASS_TCPIP
BSPARCH_DEFAULT_ARCH   = Solaris

mpiincludedir   = 
mpilibdir       =  

editpl = sed -e 's,@''includedir''@,$(includedir),g'       \
             -e 's,@''bindir''@,$(bindir),g'               \
             -e 's,@''libdir''@,$(libdir),g'               \
             -e 's,@''mandir''@,$(mandir),g'               \
             -e 's,@''GCC''@,$(GCC),g'                     \
             -e 's,@''G77''@,$(G77),g'                     \
             -e 's,@''DAVINCI''@,$(DAVINCI),g'             \
             -e 's,@''GPLUSPLUS''@,$(GPLUSPLUS),g'         \
             -e 's,@''BSPARCH_DEFAULT_ARCH''@,$(BSPARCH_DEFAULT_ARCH),g' \
             -e 's,@''BSPARCH_DEFAULT_DEVICE''@,$(BSPARCH_DEFAULT_DEVICE),g' \
             -e 's,@''BSP_DEFAULT_SLOTSIZE''@,$(BSP_DEFAULT_SLOTSIZE),g' \
             -e 's,@''BSP_DEFAULT_NOSLOTS''@,$(BSP_DEFAULT_NOSLOTS),g' \
             -e 's,@''BSP_DEFAULT_ROUNDTRIP''@,$(BSP_DEFAULT_ROUNDTRIP),g' \
             -e 's,@''BSP_DEFAULT_SENDLATENCY''@,$(BSP_DEFAULT_SENDLATENCY),g'\
             -e 's,@''mpiincludedir''@,$(mpiincludedir),g' \
             -e 's,@''mpilibdir''@,$(mpilibdir),g'         \
             -e 's,@''PERL_DBMOK''@,$(PERL_DBMOK),g'       \
             -e 's,@''F77_LIBRARY''@,$(F77_LIBRARY),g'      \
             -e 's,@''I77_LIBRARY''@,$(I77_LIBRARY),g'      \
             -e 's,@''F2C_LIBRARY''@,$(F2C_LIBRARY),g'      \
             -e 's,@''F77_COMPILER_INCLUDE''@,$(F77_COMPILER_INCLUDE),g'    \
             -e 's,@''F77_COMPILER_DEFINE''@,$(F77_COMPILER_DEFINE),g'      \
             -e 's,@''F77_COMPILER_UNDEFINE''@,$(F77_COMPILER_UNDEFINE),g'  \
             -e 's,@''F77_COMPILER_COMPILE''@,$(F77_COMPILER_INCLUDE),g'    \
             -e 's,@''F77_LIBPATH_FLAG''@,$(F77_LIBPATH_FLAG),g'            \
             -e 's,@''COMPILER_INCLUDE''@,$(COMPILER_INCLUDE),g'    \
             -e 's,@''COMPILER_DEFINE''@,$(COMPILER_DEFINE),g'      \
             -e 's,@''COMPILER_UNDEFINE''@,$(COMPILER_UNDEFINE),g'  \
             -e 's,@''COMPILER_COMPILE''@,$(COMPILER_INCLUDE),g'    \
             -e 's,@''COMPILER_CPPONLY''@,$(COMPILER_CPPONLY),g'    \
             -e 's,@''LIBPATH_FLAG''@,$(LIBPATH_FLAG),g'            \
             -e 's,@''MOVE_COMMAND''@,$(MOVE_COMMAND),g'            \
             -e 's,@''OBJECT_FILE_SUFFIX''@,$(OBJECT_FILE_SUFFIX),g'\
             -e 's,@''NEED_FBSP_WIN32_AT_HEAD''@,$(NEED_FBSP_WIN32_AT_HEAD),g'\
             -e 's,@''PERL''@,$(PERL),g' 

###########################################################################

.SUFFIXES: .lprl .prl

.prl:
	@rm -f $@ $@.tmp;	\
	$(editpl) $< > $@.tmp && chmod +x $@.tmp && mv $@.tmp $@; \
	${PERL} -c $@

.lprl.prl:
	@litToPgm $<

###########################################################################

all::   litToPgm litToTex runstdtest \
        bsputil.prl bsputil          \
        bspfrontenv.prl bspfrontenv  \
        bspfront.prl bspfront        \
        bspfpp.prl bspfpp            \
        bsparch.prl bsparch          \
        bspprof.prl bspprof          \
        bspudpvis.prl bspudpvis      \
        ipcclean.prl ipcclean        \
        bspsig.prl bspsig            \
        bspcgprof.prl bspcgprof      \
        bspparam.prl bspparam        \
        bsprun.prl   bsprun	     \
	bspnm.prl   bspnm	     \
	bsplibd.prl bsplibd          \
	bspload.prl bspload          \
	bspkill.prl bspkill          \
        bspshutd.prl bspshutd        \
        bspkstats.prl bspkstats
	rm -f bspcc bspf77 bspc++;	\
	if test `bsparch -arch` = "Windows_NT"; then \
	   cp bspfront bspcc;		\
	   cp bspfront bspf77;		\
	   cp bspfront bspc++;          \
	else                            \
	   ln -s bspfront bspcc;	\
	   ln -s bspfront bspf77;	\
	   ln -s bspfront bspc++;	\
	fi;				\
	if [ -x $(bindir)/bsparch ]; then ./bspfrontenv; fi


configarch:
	@rm -f bsparch bsparch.prl litToPgm;			\
	make PERL="${PERL}" litToPgm;				\
	./litToPgm bsparch.lprl;				\
	./litToPgm bsputil.lprl;				\
	make bindir="${bindir}" PERL="${PERL}" bsputil;		\
	make bindir="${bindir}" PERL="${PERL}" bsparch

install: all
	@for i in bsparch bspcgprof bspfpp bspfront bspfrontenv \
                 bspkill bspkstats bsplibd bspload bspnm        \
		 bspparam bspprof bspprof_ggraph.prl 	  	\
		 bspprof_strata.prl bspprof_theory.prl 		\
		 bsprun bspshutd bspsig bspudpvis               \
                 bsputil ipcclean                      		\
                 litToPgm litToTex mpc++ runstdtest; do	        \
	   ${INSTALL_PROGRAM} $$i ${bindir}/$$i;		\
	done;							\
        if [ ! -d ${bindir}/`bsparch -arch` ];                  \
        then mkdir -p ${bindir}/`bsparch -arch`;fi;	        \
	if test -n "${DAVINCI}"; then				\
	   ${INSTALL_PROGRAM} `bsparch -arch`/cgprof		\
			      $(bindir)/`bsparch -arch`/cgprof;	\
	fi;							\
	if test `bsparch -device` = "MPASS_TCPIP" ||            \
           test `bsparch -device` = "MPASS_UDPIP" ||		\
	   test `bsparch -device` = "MPASS_3C905B"; then	\
	   ${INSTALL_PROGRAM} `bsparch -arch`/bspnowd		\
		            $(bindir)/`bsparch -arch`/bspnowd;	\
	   ${INSTALL_PROGRAM} `bsparch -arch`/bspportd		\
		            $(bindir)/`bsparch -arch`/bspportd;	\
	   ${INSTALL_PROGRAM} `bsparch -arch`/bsploadd		\
		            $(bindir)/`bsparch -arch`/bsploadd;	\
	   ${INSTALL_PROGRAM} `bsparch -arch`/bspnows		\
		            $(bindir)/`bsparch -arch`/bspnows;	\
	   ${INSTALL_PROGRAM} `bsparch -arch`/bspnowm		\
		            $(bindir)/`bsparch -arch`/bspnowm;	\
	   ${INSTALL_PROGRAM} `bsparch -arch`/bsp_nowstartup	\
		      $(bindir)/`bsparch -arch`/bsp_nowstartup;	\
	   ${INSTALL_PROGRAM} `bsparch -arch`/bspshutd        	\
		      $(bindir)/`bsparch -arch`/bspshutd;	\
	fi;							\
	(cd ${bindir};						\
	rm -f bspcc bspf77 bspc++;				\
	if test `bsparch -arch` = "Windows_NT"; then \
	   cp bspfront bspcc;		\
	   cp bspfront bspf77;		\
	   cp bspfront bspc++;          \
	else                            \
	   ln -s bspfront bspcc;	\
	   ln -s bspfront bspf77;	\
	   ln -s bspfront bspc++;	\
	fi;				\
	./bspfrontenv)

clean:
	@rm -f litToPgm litToTex bspfront bspfront.prl \
              bspfpp bspprof bspprof.prl bspfpp.prl bspcpp bspcpp.prl \
              bsparch bspfrontenv.prl bspfrontenv \
	      bspudpvis.prl bspudpvis \
              ipcclean bspprof_ggraph.prl bspprof_strata.prl \
	      bspprof_theory.prl bspsig bspsig.prl ipcclean ipcclean.prl \
              bspcgprof.prl bspcgprof bsputil bsputil.prl \
              bspparam bspparam.prl bsprun.prl bsprun runstdtest \
	      bsplibd.prl bsplibd bspnm bspnm.prl bspshutd bspshutd.prl \
	      bspload.prl bspload bspkill.prl bspkill

bspprof.prl: bspprof_ggraph.prl bspprof_strata.prl bspprof_theory.prl
