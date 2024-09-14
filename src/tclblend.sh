#/bin/sh

LD_LIBRARY_PATH=__LIBDIR__:$LD_LIBRARY_PATH exec jrunscript -cp __LIBDIR__/tcljava.jar:__LIBDIR__/tclblend.jar -l tclblend "$@"
