include build.cfg
include platforms/$(PLATFORM).cfg

TCL_SRCDIR=$(BUILD_DIR)/tcl$(TCL_VERSION)
TK_SRCDIR=$(BUILD_DIR)/tk$(TK_VERSION)

# tcl_lang_version must be of the form x.y, e.g. 8.6.9 -> 8.6
tcl_lang_version=$(shell echo $(TCL_VERSION) | sed 's/\([0-9]*\.[0-9]*\)\.[0-9]*/\1/')
tclsh=$(PREFIX)/bin/tclsh${tcl_lang_version}
wish=$(PREFIX)/bin/wish${tcl_lang_version}

jtclsh=$(PREFIX)/bin/jtclsh
jaclsh=$(PREFIX)/bin/jaclsh

TCLJAVA_DIR=$(PWD)/tcljava
THREADS_SRCDIR=$(TCL_SRCDIR)/pkgs/thread$(THREADS_VERSION)
threads_pkgIndex=$(THREADS_SRCDIR)/pkgIndex.tcl

WITH_TCL=--with-tcl=$(TCL_SRCDIR)/$(TCL_PLATFORM)
WITH_TK=--with-tk=$(TK_SRCDIR)/$(TCL_PLATFORM)

.PHONY: default
default: tcl threads

.PHONY: tcljava
tcljava: tclblend jacl

.PHONY: tcltk
tcltk: default tk

.PHONY: all
all: tcltk tcljava

help:
	@echo "Current configuration:"
	@echo "TCL_SRCDIR: $(TCL_SRCDIR)"
	@echo "TK_SRCDIR: $(TK_SRCDIR)"
	@echo "THREADS_SRCDIR: $(THREADS_SRCDIR)"
	@echo
	@echo "tcl_lang_version: $(tcl_lang_version)"
	@echo "tclsh: $(tclsh)"
	@echo "wish: $(wish)"
	@echo "jtclsh: $(jtclsh)"
	@echo "jaclsh: $(jaclsh)"
	@echo
	@echo "The following settings can be redefined on the command line, e.g make PREFIX=/other/prefix JAVA_HOME=/other/java/home"
	@echo "PREFIX=$(PREFIX)"
	@echo "JAVA_HOME=$(JAVA_HOME)"
	@echo "BUILD_DIR=$(BUILD_DIR)"
	@echo
	@echo "The following targets are available:"
	@echo "make [default]: build tcl and threads"
	@echo "make tcl: build tcl"
	@echo "make threads: build threads (a subpackage of tcl)"
	@echo "make tk: build tk (with the wish interpreter)"
	@echo "make tcltk: build tcl/tk"
	@echo "make tcljava: build tclblend and jacl"
	@echo "make tclblend: build tclblend (with the jtclsh interpreter)"
	@echo "make jacl: build jacl (with the jaclsh interpreter)"
	@echo "make all: build all the available tools"
	@echo "make help: this help"

.PHONY: tclblend
tclblend: $(jtclsh)

$(jtclsh): $(JAVA_HOME) $(tclsh) threads
	cd $(TCLJAVA_DIR) && ./configure --enable-tclblend --prefix=$(PREFIX) $(WITH_TCL) --with-thread=$(THREADS_SRCDIR) --with-jdk=$(JAVA_HOME) && $(MAKE) && $(MAKE) install

.PHONY: jacl
jacl: $(jaclsh)

$(jaclsh): $(JAVA_HOME) $(tclsh) threads
	cd $(TCLJAVA_DIR) && ./configure --enable-jacl --prefix=$(PREFIX) $(WITH_TCL) --with-thread=$(THREADS_SRCDIR) --with-jdk=$(JAVA_HOME) && $(MAKE) && $(MAKE) install

.PHONY: tcl
tcl: $(tclsh)

$(tclsh): $(TCL_SRCDIR)
	cd $(TCL_SRCDIR)/$(TCL_PLATFORM) && ./configure --prefix=$(PREFIX) $(X11_FLAGS) $(THREADS_FLAGS) $(MORE_TCL_FLAGS) && $(MAKE) && $(MAKE) install

.PHONY: threads
threads: $(threads_pkgIndex)

$(threads_pkgIndex): $(THREADS_SRCDIR) tcl
	cd $(THREADS_SRCDIR) && ./configure --prefix=$(PREFIX) $(THREADS_FLAGS) $(MORE_TCL_FLAGS) $(WITH_TCL) && $(MAKE) && $(MAKE) install

$(THREADS_SRCDIR): $(TCL_SRCDIR)

.PHONY: tk
tk: $(wish)

# LIB_RUNTIME_DIR must be specified to circumvent a bug in Tk's configure (TCL_LD_SEARCH_FLAGS is never defined in configure.in and prevents conversion from : to -L in LIB_RUNTIME_DIR)
# This bug occurs in MacOSX only
$(wish): $(tclsh) $(TK_SRCDIR)
	cd $(TK_SRCDIR)/$(TCL_PLATFORM) && ./configure --prefix=$(PREFIX) $(WITH_TCL) $(X11_FLAGS) $(THREADS_FLAGS) $(MORE_TCL_FLAGS) $(MORE_TK_FLAGS) && $(MAKE) LIB_RUNTIME_DIR=$(PREFIX)/lib && $(MAKE) install

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

#############################################################

$(TCL_SRCDIR): $(TCL_TARBALL) $(BUILD_DIR)
	cd $(BUILD_DIR) && $(UNTAR) $< 

$(TK_SRCDIR): $(TK_TARBALL) $(BUILD_DIR)
	cd $(BUILD_DIR) && $(UNTAR) $<

$(TCL_TARBALL):
	@echo "\$$TCL_TARBALL: '$(TCL_TARBALL)' not found. You must set \$$TCL_TARBALL to a proper tcl source directory in build.cfg" 1>&2 && false

$(TK_TARBALL):
	@echo "\$$TK_TARBALL: '$(TK_TARBALL)' not found. You must set \$$TK_TARBALL to a proper tk source directory in build.cfg (optional)" 1>&2 && false

$(JAVA_HOME):
	@echo "\$$JAVA_HOME: '$(JAVA_HOME)' not found: You must set \$$JAVA_HOME to a proper JDK root directory in your environment, or optionally in build.cfg" 1>&2 && false

clean:
	cd $(PACKAGES_DIR) && $(MAKE) clean
	cd $(TCLJAVA_DIR) && $(MAKE) clean distclean
	rm -rf $(BUILD_DIR)
	rm -rf local
	rm -f *~

