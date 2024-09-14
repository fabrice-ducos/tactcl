#!/bin/sh

PREFIX=$PWD/local
exec jrunscript -cp $PREFIX/lib/tcljava1.5.0/tcljava.jar:$PREFIX/lib/tcljava1.5.0/jacl.jar -l jacl "$@"
