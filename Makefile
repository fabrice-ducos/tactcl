ifeq (, $(wildcard build.cfg))
$(warning build.cfg is not found. It is probably a fresh installation. It will be created from build.cfg.dist)
$(shell cp build.cfg.dist build.cfg)
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

include detect_os.mk
include build.cfg
include platforms/$(PLATFORM).cfg
include versions.cfg

# $(PACKAGES_DIR) defined in build.cfg
include $(PACKAGES_DIR)/packages.mk

TCLJAVA_TEST_SCRIPT=tcljava/Test.tcl

# for backward compatibility
PREFIX=$(BUILD_PREFIX)

JAR=$(JAVA_HOME)/bin/jar

TCL_SRCDIR=$(BUILD_DIR)/tcl$(TCL_VERSION)
TK_SRCDIR=$(BUILD_DIR)/tk$(TK_VERSION)

# tcl_lang_version must be of the form x.y, e.g. 8.6.9 -> 8.6
tcl_lang_version=$(shell echo $(TCL_VERSION) | sed 's/\([0-9]*\.[0-9]*\)\.[0-9]*/\1/')
tclsh=$(BUILD_PREFIX)/bin/tclsh${tcl_lang_version}
wish=$(BUILD_PREFIX)/bin/wish${tcl_lang_version}

jtclsh=$(BUILD_PREFIX)/bin/jtclsh
jaclsh=$(BUILD_PREFIX)/bin/jaclsh

TCLJAVA_DIR=$(shell pwd)/tcljava
THREADS_SRCDIR=$(TCL_SRCDIR)/pkgs/thread$(THREADS_VERSION)
threads_pkgIndex=$(THREADS_SRCDIR)/pkgIndex.tcl

WITH_TCL=--with-tcl=$(TCL_SRCDIR)/$(TCL_PLATFORM)
WITH_TK=--with-tk=$(TK_SRCDIR)/$(TCL_PLATFORM)

BINDIR=$(BUILD_PREFIX)/bin
LIBDIR=$(BUILD_PREFIX)/lib/tcljava$(TCLJAVA_VERSION)
TCLBLEND_JAR=$(LIBDIR)/tclblend.jar
TCLBLEND_SO_BASE=$(LIB_BUILD_PREFIX)tclblend.$(LIB_EXT)
TCLBLEND_SO=$(LIBDIR)/$(TCLBLEND_SO_BASE)
TCLBLEND_SO_IN_NATIVE=$(NATIVE_SUBDIR)/$(LIB_BUILD_PREFIX)tclblend.$(LIB_EXT)
JACL_JAR=$(LIBDIR)/jacl.jar

# For MacOSX only (where Java looks for .dylib)
# for system-wide installations (requires superuser permissions)
#JAVA_EXTENSIONS_DIR=/Library/Java/Extensions

JAVA_EXTENSIONS_DIR=$(HOME)/Library/Java/Extensions

.PHONY: default
default: tcljava

.PHONY: tcljava
tcljava: tclblend jacl

.PHONY: all
all: tcl tk tcljava all-packages

.PHONY: stable
stable: tcl tk tcljava stable-packages

$(BINDIR):
	$(MKDIR) $@

.PHONY: install
install: $(BUILD_PREFIX)
	$(MKDIR) $(INSTALL_PREFIX)
	$(RECURSIVE_CP) $(BUILD_PREFIX)/* $(INSTALL_PREFIX)/


.PHONY: help
help:
	@echo "The following targets are available:"
	@echo ""
	@echo "make [default]: build tcljava - will build tcl and threads as dependencies"
	@echo ""
	@echo "For native Tcl distribution:"
	@$(MAKE) help-packages
	@echo ""
	@echo "For tests:"
	@echo "make test: run all the tests"
	@echo "make test-jacl|test-jtcl|test-jaclsh|test-jtclsh: run specific tests"
	@echo ""
	@echo "For TclJava:"
	@echo "make tcljava: build tclblend and jacl"
	@echo "make tclblend: build tclblend (with the jtcl interpreter)"
	@echo "make jacl: build jacl (with the jacl interpreter)"
	@echo "make maven-install: install tcljava (tclblend and jacl) in the local maven repo"
	@echo "make maven-uninstall: remove tcljava (tclblend and jacl) from the local maven repo"
	@echo ""
	@echo "make clean: clean tcljava source directory from build artifacts"
	@echo "make cleanall|clean-all: remove all the build artifacts"
	@echo "make all: build tcljava and everything in $(PACKAGES_DIR)"
	@echo "          This is likely to fail without some trial and error"
	@echo "          because of package dependencies missing on your system,"
	@echo "          or installed in non-default locations."
	@echo "          You may need to edit your build.cfg file."
	@echo "make stable: builds only packages with no known build issue"
	@echo "make help: this help"
	@echo ""
	@echo "The following settings can be redefined on the command line,"
	@echo "e.g make BUILD_PREFIX=/other/BUILD_PREFIX JAVA_HOME=/other/java/home"
	@echo "or: [sudo] make install INSTALL_PREFIX=/other/prefix"
	@echo ""
	@echo "Detected OS: $(OS)"
	@echo "INSTALL_PREFIX: $(INSTALL_PREFIX)"
	@echo "BUILD_PREFIX=$(BUILD_PREFIX)"
	@echo "JAVA_HOME=$(JAVA_HOME)"
	@echo "BUILD_DIR=$(BUILD_DIR)"
	@echo "TCLJAVA_VERSION=$(TCLJAVA_VERSION)"
	@echo "M2_ROOT: $(M2_ROOT)"

.PHONY: test
test: test-tcljava

.PHONY: test-tcljava
test-tcljava: test-jaclsh test-jtclsh test-jacl test-jtcl

.PHONY: test-jaclsh
test-jaclsh: $(jaclsh)
	$(jaclsh) $(TCLJAVA_TEST_SCRIPT)

.PHONY: test-jtclsh
test-jtclsh: $(jtclsh)
	$(jtclsh) $(TCLJAVA_TEST_SCRIPT)

.PHONY: test-jacl
test-jacl: $(BINDIR)/jacl
	$(BINDIR)/jacl $(TCLJAVA_TEST_SCRIPT)

.PHONY: test-jtcl
test-jtcl: $(BINDIR)/jtcl
	$(BINDIR)/jtcl $(TCLJAVA_TEST_SCRIPT)

.PHONY: tclblend
tclblend: $(jtclsh) $(BINDIR)/jtcl

$(BINDIR)/jtcl: src/jtcl.sh tcl threads libtclblend $(BINDIR)
	sed "s|__LIBDIR__|$(LIBDIR)|g" $< > $@ && chmod +x $@

# $(jtclsh) is deprecated, use jtcl instead
$(jtclsh): $(JAVA_HOME) tcl threads libtclblend

# one must check for both tclblend.so and libtclblend.so
# and build the missing one from the other one. Unfortunately, this
# depends on the system: on Windows, tclblend.so will be built first,
# and on POSIX systems, it's libtclblend.so that will be built first.

.PHONY: libtclblend
libtclblend:
	cd $(TCLJAVA_DIR) && ./configure --enable-tclblend --prefix=$(BUILD_PREFIX) $(WITH_TCL) --with-thread=$(THREADS_SRCDIR) --with-jdk=$(JAVA_HOME) && $(MAKE) && $(MAKE) install

.PHONY: jacl
jacl: $(jaclsh) $(BINDIR)/jacl

$(BINDIR)/jacl: src/jacl.sh tcl threads $(BINDIR)
	sed "s|__LIBDIR__|$(LIBDIR)|g" $< > $@ && chmod +x $@

#$(jaclsh) is deprecated, use jacl instead
$(jaclsh): $(JAVA_HOME) tcl threads
	cd $(TCLJAVA_DIR) && ./configure --enable-jacl --prefix=$(BUILD_PREFIX) $(WITH_TCL) --with-thread=$(THREADS_SRCDIR) --with-jdk=$(JAVA_HOME) && $(MAKE) && $(MAKE) install

.PHONY: maven-install
maven-install: maven-install-tcljava maven-install-tclblend maven-install-jacl maven-install-itcl maven-install-janino maven-install-tjc

.PHONY: maven-uninstall
maven-uninstall:
	-rm -rfv $(M2_ROOT)/repository/$(TCLJAVA_REPO)

.PHONY: maven-install-tclblend
maven-install-tclblend:
	mvn install:install-file -Dfile=$(TCLBLEND_JAR) -DgroupId=$(TCLJAVA_GROUPID) -DartifactId=tclblend -Dversion=$(TCLJAVA_VERSION) -Dpackaging=jar

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

.PHONY: clean
clean: clean-tcljava
# for safety reasons, never erase $(BUILD_DIR) and $(BUILD_PREFIX) (e.g. /usr/local!!). That's why 'build' and 'local' are hardcoded here.
	rm -rf local
	rm -rf native
	rm -f *~

.PHONY: cleanall clean-all
cleanall clean-all: clean
	rm -rf build 

.PHONY: clean-tcljava
clean-tcljava:
	-cd $(TCLJAVA_DIR) && test -f Makefile && $(MAKE) clean
	-cd $(TCLJAVA_DIR) && test -f Makefile && $(MAKE) distclean
	rm -f tcljava/jdk.cfg # generated automatically

