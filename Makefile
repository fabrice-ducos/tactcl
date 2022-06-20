ifeq (, $(wildcard build.cfg))
$(error build.cfg is not found. It is probably a fresh installation. Please copy build.cfg.dist to build.cfg, check up the file and edit it if necessary, then retry.)
endif

TCLJAVA_GROUPID=com.github.fabriceducos.tactcl.tcljava
TCLJAVA_REPO=com/github/fabriceducos/tactcl/tcljava

# the version is extracted from tcljava/configure.in that should be
# the main source for the version number (reconfiguring updates
# the version in several source files)
# the variable is suffixed by _MK in order to avoid a strange
# circular dependency between the variable and the grep expression 
# (that contains TCLJAVA_VERSION=)
TCLJAVA_VERSION:=$(shell grep 'TCLJAVA_VERSION=' tcljava/configure.in | cut -d'=' -f2)

MAIN_TARGET=failed
ifeq ($(OS),Windows_NT)
  PLATFORM=windows
  JAVA_HOME:=$(subst \,\\,$(JAVA_HOME))
  LIB_EXT=dll
  LIB_OPTION=shared
  MAIN_TARGET=default
  HOMEPATH_SAFE=$(subst \,/,$(HOMEPATH))
  M2_ROOT=$(HOMEDRIVE)$(HOMEPATH_SAFE)/.m2
  MAKE_ALIAS=cp
else
  UNAME_S := $(shell uname -s)
  UNAME_P := $(shell uname -p)
  OS=$(UNAME_S)
  ifeq ($(UNAME_S), Darwin)
    PLATFORM=unix
    LIB_EXT=dylib
    LIB_OPTION=shared
    MAIN_TARGET=default
    M2_ROOT=$(HOME)/.m2
    MAKE_ALIAS=ln -sf
  endif
  ifeq ($(UNAME_S),Linux)
    PLATFORM=unix
    LIB_EXT=so
    LIB_OPTION=shared
    MAIN_TARGET=default
    M2_ROOT=$(HOME)/.m2
    # On Linux, ln can create relative links with -r
    MAKE_ALIAS=ln -sfr
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

LIBDIR=$(PREFIX)/lib/tcljava$(TCLJAVA_VERSION)
TCLBLEND_JAR=$(LIBDIR)/tclblend.jar
TCLBLEND_JAR_MAVEN_BASE=tclblend-$(TCLJAVA_VERSION).jar
TCLBLEND_SO_BASE=tclblend.$(LIB_EXT)
TCLBLEND_SO_MAVEN_BASE=tclblend-$(TCLJAVA_VERSION).$(LIB_EXT)
TCLBLEND_SO=$(LIBDIR)/$(TCLBLEND_SO_BASE)
TCLBLEND_LIB_SO=$(LIBDIR)/lib$(TCLBLEND_SO_BASE)
TCLBLEND_LIB_SO_MAVEN_BASE=libtclblend-$(TCLJAVA_VERSION).$(LIB_EXT)
JACL_JAR=$(LIBDIR)/jacl.jar
JACL_JAR_MAVEN_BASE=jacl-$(TCLJAVA_VERSION).jar

.PHONY: start
start: $(MAIN_TARGET)

.PHONY: failed
failed:
	@echo "System $(OS) not recognized or not supported for the time being"

.PHONY: default
default: tcljava

include $(PACKAGES_DIR)/packages.mk

.PHONY: tcljava
tcljava: tclblend jacl

.PHONY: all
all: tcl tk tcljava all-packages

.PHONY: stable
stable: tcl tk tcljava stable-packages

.PHONY: help
help:
	@echo "The following targets are available:"
	@echo
	@echo "make [default]: build tcljava - will build tcl and threads as dependencies"
	@echo
	@echo "For native Tcl distribution:"
	@$(MAKE) help-packages
	@echo
	@echo "For TclJava:"
	@$(MAKE) help-tcljava
	@echo "make clean: clean tcljava source directory from build artifacts"
	@echo "make cleanall|clean-all: remove all the build artifacts"
	@echo "make all: build tcljava and everything in $(PACKAGES_DIR)"
	@echo "          This is likely to fail without some trial and error"
	@echo "          because of package dependencies missing on your system,"
	@echo "          or installed in non-default locations."
	@echo "          You may need to edit your build.cfg file."
	@echo "make stable: builds only packages with no known build issue"
	@echo "make help: this help"

.PHONY: help-tcljava
help-tcljava:
	@echo "make tcljava: build tclblend and jacl"
	@echo "make tclblend: build tclblend (with the jtclsh interpreter)"
	@echo "make jacl: build jacl (with the jaclsh interpreter)"
	@echo "make maven-install: install tcljava (tclblend and jacl) in the local maven repo"
	@echo "make maven-uninstall: remove tcljava (tclblend and jacl) from the local maven repo"
	@echo	
	@echo "The following settings can be redefined on the command line, e.g make PREFIX=/other/prefix JAVA_HOME=/other/java/home"
	@echo "PREFIX=$(PREFIX)"
	@echo "JAVA_HOME=$(JAVA_HOME)"
	@echo "BUILD_DIR=$(BUILD_DIR)"
	@echo "TCLJAVA_VERSION=$(TCLJAVA_VERSION)"
	@echo "M2_ROOT: $(M2_ROOT)"
	@echo

.PHONY: tclblend
tclblend: $(jtclsh)

$(jtclsh): $(JAVA_HOME) tcl threads libtclblend

# one must check for both tclblend.so and libtclblend.so
# and build the missing one from the other one. Unfortunately, this
# depends on the system: on Windows, tclblend.so will be built first,
# and on POSIX systems, it's libtclblend.so that will be built first.

.PHONY: libtclblend
libtclblend:
	cd $(TCLJAVA_DIR) && ./configure --enable-tclblend --prefix=$(PREFIX) $(WITH_TCL) --with-thread=$(THREADS_SRCDIR) --with-jdk=$(JAVA_HOME) && $(MAKE) && $(MAKE) install
	test -f $(TCLBLEND_SO) || cp $(TCLBLEND_LIB_SO) $(TCLBLEND_SO)
	test -f $(TCLBLEND_LIB_SO) || cp $(TCLBLEND_SO) $(TCLBLEND_LIB_SO)

.PHONY: jacl
jacl: $(jaclsh)

$(jaclsh): $(JAVA_HOME) tcl threads
	cd $(TCLJAVA_DIR) && ./configure --enable-jacl --prefix=$(PREFIX) $(WITH_TCL) --with-thread=$(THREADS_SRCDIR) --with-jdk=$(JAVA_HOME) && $(MAKE) && $(MAKE) install

.PHONY: maven-install
maven-install: maven-install-tcljava maven-install-tclblend maven-install-jacl maven-install-itcl maven-install-janino maven-install-tjc

.PHONY: maven-uninstall
maven-uninstall:
	-rm -rfv $(M2_ROOT)/repository/$(TCLJAVA_REPO)

.PHONY: maven-install-tclblend
maven-install-tclblend: maven-install-tclblend-so
	mvn install:install-file -Dfile=$(TCLBLEND_JAR) -DgroupId=$(TCLJAVA_GROUPID) -DartifactId=tclblend -Dversion=$(TCLJAVA_VERSION) -Dpackaging=jar

# the creation of the link (that adds a "lib" prefix to the native library) is required for a portable access to the native
# library: the "lib" prefix is expected on POSIX systems (including Linux and OSX) and not on Windows
# This portability issue is a real pain...
# For more details:
# https://jornvernee.github.io/java/panama-ffi/panama/jni/native/2021/09/13/debugging-unsatisfiedlinkerrors.html
.PHONY: maven-install-tclblend-so
maven-install-tclblend-so:
	mvn install:install-file -Dfile=$(TCLBLEND_SO) -DgroupId=$(TCLJAVA_GROUPID) -DartifactId=tclblend -Dversion=$(TCLJAVA_VERSION) -Dpackaging=$(LIB_EXT) && \
	$(MAKE_ALIAS) $(M2_ROOT)/repository/$(TCLJAVA_REPO)/tclblend/$(TCLJAVA_VERSION)/$(TCLBLEND_SO_MAVEN_BASE) $(M2_ROOT)/repository/$(TCLJAVA_REPO)/tclblend/$(TCLJAVA_VERSION)/$(TCLBLEND_LIB_SO_MAVEN_BASE)

.PHONY: maven-install-jacl
maven-install-jacl:
	mvn install:install-file -Dfile=$(JACL_JAR) -DgroupId=$(TCLJAVA_GROUPID) -DartifactId=jacl -Dversion=$(TCLJAVA_VERSION) -Dpackaging=jar

.PHONY: maven-install-tcljava
maven-install-tcljava:
	mvn install:install-file -Dfile=$(LIBDIR)/tcljava.jar -DgroupId=$(TCLJAVA_GROUPID) -DartifactId=tcljava -Dversion=$(TCLJAVA_VERSION) -Dpackaging=jar

.PHONY: maven-install-itcl
maven-install-itcl:
	mvn install:install-file -Dfile=$(LIBDIR)/itcl.jar -DgroupId=$(TCLJAVA_GROUPID) -DartifactId=itcl -Dversion=$(TCLJAVA_VERSION) -Dpackaging=jar

.PHONY: maven-install-janino
maven-install-janino:
	mvn install:install-file -Dfile=$(LIBDIR)/janino.jar -DgroupId=$(TCLJAVA_GROUPID) -DartifactId=janino -Dversion=$(TCLJAVA_VERSION) -Dpackaging=jar

.PHONY: maven-install-tjc
maven-install-tjc:
	mvn install:install-file -Dfile=$(LIBDIR)/tjc.jar -DgroupId=$(TCLJAVA_GROUPID) -DartifactId=tjc -Dversion=$(TCLJAVA_VERSION) -Dpackaging=jar


#############################################################

$(JAVA_HOME):
	@echo "\$$JAVA_HOME: '$(JAVA_HOME)' not found: You must set \$$JAVA_HOME to a proper JDK root directory in your environment, or optionally in build.cfg" 1>&2 && false

clean: clean-tcljava

# for safety reasons, never erase $(BUILD_DIR) and $(PREFIX) (e.g. /usr/local!!). That's why 'build' and 'local' are hardcoded here.
cleanall clean-all: clean-tcljava
	rm -rf build
	rm -rf local
	rm -f *~ 

clean-tcljava:
	-cd $(TCLJAVA_DIR) && test -f Makefile && $(MAKE) clean
	-cd $(TCLJAVA_DIR) && test -f Makefile && $(MAKE) distclean
	rm -f tcljava/jdk.cfg # generated automatically

