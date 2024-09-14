#/bin/sh

PREFIX=$PWD/local
LD_LIBRARY_PATH=$PREFIX/lib/tcljava1.5.0:$LD_LIBRARY_PATH exec jrunscript -cp $PREFIX/lib/tcljava1.5.0/tcljava.jar:$PREFIX/lib/tcljava1.5.0/tclblend.jar -l tclblend "$@"
