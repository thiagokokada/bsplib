SHELL=/bin/sh

all:
	if [ ! -d `bsparch -arch` ];                     \
        then                                             \
           mkdir `bsparch -arch`;                        \
           (cd `bsparch -arch`;                          \
            if test `bsparch -arch` = "WindowsNT"; then  \
               cp -r  ../../src/* . ;                    \
            else                                         \
               lndir ../../src;                          \
            fi);                                         \
        fi

clean:
	if [ -d `bsparch -arch` ];    \
        then rm -r `bsparch -arch`;fi
