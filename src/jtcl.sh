#/bin/sh

exec jrunscript -cp __LIBDIR__/tcljava.jar:__LIBDIR__/tclblend.jar -l tclblend "$@"
