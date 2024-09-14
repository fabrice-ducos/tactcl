#!/bin/sh

exec jrunscript -cp __LIBDIR__/tcljava.jar:__LIBDIR__/jacl.jar -l jacl "$@"
