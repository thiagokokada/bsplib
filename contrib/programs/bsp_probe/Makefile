

SRCS_LC       = bsp_probe.lc 
BINARY_TARGET = bspprobe
LIBRARY_OBS   = 
LIBRARIES     =  
INCLUDES      = 

#############################################################
##             Flags and conversions                       ##
#############################################################

SRCS_O   = $(SRCS_LC:.lc=.o)
SRCS_TEX = $(SRCS_LC:.lc=.c.tex) 

CC     =  bspcc
CFLAGS = -flibrary-level 2 -O3 
 

.SUFFIXES: .lc .lh .c .tex .c.tex .h.tex

#############################################################
##             Compilation rules                           ##
#############################################################

.lc.o:
	${CC} ${CFLAGS} $(INCLUDES) -c $*.lc;

.lc.c.tex:
	litToTex $<

#############################################################
##             Compilation targets                         ##
#############################################################

$(BINARY_TARGET): $(SRCS_O) $(LIBRARY_OBS)
	${CC}  ${CFLAGS} -o ${BINARY_TARGET} $(SRCS_O) $(LIBRARIES)

all:: $(BINARY_TARGET)

root.dvi: root.aux $(SRCS_TEX)
	latex root.tex

clean::
	rm -f $(SRCS_O) $(BINARY_TARGET) $(SRCS_C) $(SRCS_TEX) bsp_probe.c \
		PROF.bsp STAT.bsp


#############################################################
##             Dependencies                                ##
#############################################################

