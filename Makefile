ifeq (, $(wildcard build.cfg))
$(error build.cfg is not found. It is probably a fresh installation. Please copy build.cfg.dist to build.cfg, check up the file and edit it if necessary, then retry.)
endif

MAIN_TARGET=failed
ifeq ($(OS),Windows_NT)
  PLATFORM=windows
  JAVA_HOME:=$(subst \,\\,$(JAVA_HOME))
  # no "lib" prefix expected on Windows
  LIB_PREFIX=
  LIB_EXT=dll
  LIB_OPTION=shared
  MAIN_TARGET=default
else
  UNAME_S := $(shell uname -s)
  UNAME_P := $(shell uname -p)
  OS=$(UNAME_S)
  ifeq ($(UNAME_S), Darwin)
    PLATFORM=unix
    LIB_PREFIX=lib
	LIB_EXT=dylib
	LIB_OPTION=shared
	MAIN_TARGET=default
  endif
  ifeq ($(UNAME_S),Linux)
    PLATFORM=unix
    LIB_PREFIX=lib
	LIB_EXT=so
	LIB_OPTION=shared
	MAIN_TARGET=default
  endif
endif
  

include build.cfg
include platforms/$(PLATFORM).cfg
include versions.cfg

TCL_SRCDIR=$(BUILD_DIR)/tcl$(TCL_VERSION)
TK_SRCDIR=$(BUILD_DIR)/tk$(TK_VERSION)

# tcl_lang_version must be of the form x.y, e.g. 8.6.9 -> 8.6
tcl_lang_version=$(shell echo $(TCL_VERSION) | sed 's/\([0-9]*\.[0-9]*\)\.[0-9]*/\1/')
tclsh=$(PREFIX)/bin/tclsh${tcl_lang_version}
wish=$(PREFIX)/bin/wish${tcl_lang_version}

jtclsh=$(PREFIX)/bin/jtclsh
jaclsh=$(PREFIX)/bin/jaclsh

TCLJAVA_DIR=$(shell pwd)/tcljava
THREADS_SRCDIR=$(TCL_SRCDIR)/pkgs/thread$(THREADS_VERSION)
threads_pkgIndex=$(THREADS_SRCDIR)/pkgIndex.tcl

WITH_TCL=--with-tcl=$(TCL_SRCDIR)/$(TCL_PLATFORM)
WITH_TK=--with-tk=$(TK_SRCDIR)/$(TCL_PLATFORM)

.PHONY: start
start: $(MAIN_TARGET)

.PHONY: failed
failed:
	@echo "System $(OS) not recognized or not supported for the time being"

.PHONY: default
default: tcl threads

include $(PACKAGES_DIR)/packages.mk

.PHONY: tcljava
tcljava: tclblend jacl

.PHONY: all
all: tcl tk tcljava all-packages

stable: tcl tk tcljava stable-packages

help:
	@echo "The following targets are available:"
	@echo
	@echo make [default]: build tcl and its threads subpackage
	@echo
	@echo "For native Tcl distribution:"
	@$(MAKE) help-packages
	@echo
	@echo "For TclJava:"
	@$(MAKE) help-tcljava
	@echo "make clean: remove all the build artifacts"
	@echo "make clean-tcljava: remove tcljava build artifacts"
	@echo "make all: build tcljava and everything in $(PACKAGES_DIR)"
	@echo "          This is likely to fail without some trial and error"
	@echo "          because of package dependencies missing on your system,"
	@echo "          or installed in non-default locations."
	@echo "          You may need to edit your build.cfg file."
	@echo "make stable: builds only packages with no known build issue"
	@echo "make help: this help"

help-tcljava:
	@echo "make tcljava: build tclblend and jacl"
	@echo "make tclblend: build tclblend (with the jtclsh interpreter)"
	@echo "make jacl: build jacl (with the jaclsh interpreter)"
	@echo	
	@echo "The following settings can be redefined on the command line, e.g make PREFIX=/other/prefix JAVA_HOME=/other/java/home"
	@echo "PREFIX=$(PREFIX)"
	@echo "JAVA_HOME=$(JAVA_HOME)"
	@echo "BUILD_DIR=$(BUILD_DIR)"
	@echo

.PHONY: tclblend
tclblend: $(jtclsh)

$(jtclsh): $(JAVA_HOME) tcl threads
	cd $(TCLJAVA_DIR) && ./configure --enable-tclblend --prefix=$(PREFIX) $(WITH_TCL) --with-thread=$(THREADS_SRCDIR) --with-jdk=$(JAVA_HOME) && $(MAKE) && $(MAKE) install

.PHONY: jacl
jacl: $(jaclsh)

$(jaclsh): $(JAVA_HOME) tcl threads
	cd $(TCLJAVA_DIR) && ./configure --enable-jacl --prefix=$(PREFIX) $(WITH_TCL) --with-thread=$(THREADS_SRCDIR) --with-jdk=$(JAVA_HOME) && $(MAKE) && $(MAKE) install

#############################################################

$(JAVA_HOME):
	@echo "\$$JAVA_HOME: '$(JAVA_HOME)' not found: You must set \$$JAVA_HOME to a proper JDK root directory in your environment, or optionally in build.cfg" 1>&2 && false

# for safety reasons, never erase $(BUILD_DIR) and $(PREFIX) (e.g. /usr/local!!). That's why 'build' and 'local' are hardcoded here.
clean: clean-tcljava
	rm -rf build
	rm -rf local
	rm -f *~ 

clean-tcljava:
	-cd $(TCLJAVA_DIR) && test -f Makefile && $(MAKE) clean
	-cd $(TCLJAVA_DIR) && test -f Makefile && $(MAKE) distclean
	rm -f tcljava/jdk.cfg # generated automatically

