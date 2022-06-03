include build.cfg

jtclsh=$(PREFIX)/bin/jtclsh
jaclsh=$(PREFIX)/bin/jaclsh
wish=$(PREFIX)/bin/wish${tcl_lang_version}

TCLJAVA_DIR=tcljava
THREADS_SRCDIR=$(shell echo $(TCL_SRCDIR)/pkgs/thread*)
threads_pkgIndex=$(THREADS_SRCDIR)/pkgIndex.tcl

WITH_TCL=--with-tcl=$(TCL_SRCDIR)/$(TCL_PLATFORM)
WITH_TK=--with-tk=$(TK_SRCDIR)/$(TCL_PLATFORM)

.PHONY: all
all: tclblend jacl

help:
	@echo "Current configuration:"
	@echo "jtclsh: $(jtclsh)"
	@echo "jaclsh: $(jaclsh)"
	@echo "wish: $(wish)"
	@echo
	@echo "THREADS_SRCDIR: $(THREADS_SRCDIR)"
	@echo "threads_pkgIndex: $(threads_pkgIndex)"
	@echo
	@echo "The following settings can be redefined on the command line, e.g make PREFIX=/other/prefix JAVA_HOME=/other/java/home"
	@echo "PREFIX=$(PREFIX)"
	@echo "JAVA_HOME=$(JAVA_HOME)"
	@echo "BUILD_DIR=$(BUILD_DIR)"

.PHONY: tclblend
tclblend: $(jtclsh)

$(jtclsh): $(JAVA_HOME) $(TCL_SRCDIR) $(threads_pkgIndex)
	cd $(TCLJAVA_DIR) && ./configure --enable-tclblend --prefix=$(PREFIX) $(WITH_TCL) --with-thread=$(THREADS_SRCDIR) --with-jdk=$(JAVA_HOME) && $(MAKE) && $(MAKE) install

.PHONY: jacl
jacl: $(jaclsh)

$(jaclsh): $(JAVA_HOME) $(TK_SRCDIR)
	cd $(TCLJAVA_DIR) && ./configure --enable-jacl --prefix=$(PREFIX) $(WITH_TCL) --with-thread=$(THREADS_SRCDIR) --with-jdk=$(JAVA_HOME) && $(MAKE) && $(MAKE) install

.PHONY: tcl
tcl: $(tclsh)

$(tclsh): $(JAVA_HOME) $(TCL_SRCDIR) $(threads_pkgIndex)
	cd $(TCL_SRCDIR)/$(TCL_PLATFORM) && ./configure --prefix=$(PREFIX) $(WITH_TCL) --with-thread=$(THREADS_SRCDIR) --with-jdk=$(JAVA_HOME) && $(MAKE) && $(MAKE) install

.PHONY: threads
threads: $(threads_pkgIndex)

$(threads_pkgIndex): $(THREADS_SRCDIR)
	cd $(THREADS_SRCDIR) && ./configure --prefix=$(PREFIX) $(THREADS_FLAGS) $(MORE_TCL_FLAGS) $(WITH_TCL) && $(MAKE) && $(MAKE) install

$(THREADS_SRCDIR): $(TCL_SRCDIR)

.PHONY: tk
tk: $(wish)

# LIB_RUNTIME_DIR must be specified to circumvent a bug in Tk's configure (TCL_LD_SEARCH_FLAGS is never defined in configure.in and prevents conversion from : to -L in LIB_RUNTIME_DIR)
# This bug occurs in MacOSX only
$(wish): $(tclsh)
	cd $(TK_SRCDIR)/$(TCL_PLATFORM) && ./configure --prefix=$(PREFIX) $(WITH_TCL) $(X11_FLAGS) $(THREADS_FLAGS) $(MORE_TCL_FLAGS) $(MORE_TK_FLAGS) && $(MAKE) LIB_RUNTIME_DIR=$(PREFIX)/lib && $(MAKE) install

$(TCL_SRCDIR):
	@echo "\$$TCL_SRCDIR: '$(TCL_SRCDIR)' not found. You must set \$$TCL_SRCDIR to a proper tcl source directory in build.cfg" 1>&2 && false

$(TK_SRCDIR):
	@echo "\$$TK_SRCDIR: '$(TK_SRCDIR)' not found. You must set \$$TK_SRCDIR to a proper tk source directory in build.cfg (optional)" 1>&2 && false

$(JAVA_HOME):
	@echo "\$$JAVA_HOME: '$(JAVA_HOME)' not found: You must set \$$JAVA_HOME to a proper JDK root directory in your environment, or optionally in build.cfg" 1>&2 && false

