# TclBuild script: integration Makefile for Tcl
# Fabrice Ducos 2019, 2022

VERSIONS_CFG=versions.cfg

TCL_TARBALL=$(PACKAGES_DIR)/tcl$(TCL_VERSION)-src.tar.gz
TK_TARBALL=$(PACKAGES_DIR)/tk$(TK_VERSION)-src.tar.gz
CK_ZIPFILE=$(PACKAGES_DIR)/ck-$(CK_VERSION).zip
TCLREADLINE_ZIPFILE=$(PACKAGES_DIR)/tclreadline-$(TCLREADLINE_VERSION).zip
EXPECT_TARBALL=$(PACKAGES_DIR)/expect$(EXPECT_VERSION).tar.gz
CRITCL_TARBALL=$(PACKAGES_DIR)/critcl-$(CRITCL_VERSION).tar.gz
TCLX_ZIPFILE=$(PACKAGES_DIR)/tclx-$(TCLX_VERSION).zip
TCLLIB_TARBALL=$(PACKAGES_DIR)/tcllib-$(TCLLIB_VERSION).tar.gz
BWIDGET_TARBALL=$(PACKAGES_DIR)/bwidget-$(BWIDGET_VERSION).tar.gz

# tcl_lang_version must be of the form x.y, e.g. 8.6.9 -> 8.6
tcl_lang_version=$(shell echo $(TCL_VERSION) | sed 's/\([0-9]*\.[0-9]*\)\.[0-9]*/\1/')
tclsh=$(PREFIX)/bin/tclsh${tcl_lang_version}
wish=$(PREFIX)/bin/wish${tcl_lang_version}
libtk=tk${tcl_lang_version}
cwsh=$(PREFIX)/bin/cwsh
tclreadline-folder=$(PREFIX)/lib/tclreadline$(TCLREADLINE_VERSION)
thread_lib=$(PREFIX)/lib/thread$(THREADS_VERSION)
expect_cmd=$(PREFIX)/bin/expect
critcl_cmd=$(PREFIX)/bin/critcl
tclx_lib=$(PREFIX)/lib/tclx${tcl_lang_version}
tcllib_lib=$(PREFIX)/lib/tcllib$(TCLLIB_VERSION)
bwidget_lib=$(PREFIX)/lib/BWidget

ifeq (, $(BUILD_DIR))
$(error BUILD_DIR is not defined, please do not call this Makefile directly. Only the top level Makefile should be launched, that will load the proper configuration)
endif

TCL_SRCDIR=$(BUILD_DIR)/tcl$(TCL_VERSION)
TK_SRCDIR=$(BUILD_DIR)/tk$(TK_VERSION)
CK_SRCDIR=$(BUILD_DIR)/ck-$(CK_VERSION)
TCLREADLINE_SRCDIR=$(BUILD_DIR)/tclreadline-$(TCLREADLINE_VERSION)
EXPECT_SRCDIR=$(BUILD_DIR)/expect$(EXPECT_VERSION)
CRITCL_SRCDIR=$(BUILD_DIR)/critcl-$(CRITCL_VERSION)
TCLX_SRCDIR=$(BUILD_DIR)/tclx-$(TCLX_VERSION)
TCLLIB_SRCDIR=$(BUILD_DIR)/tcllib-$(TCLLIB_VERSION)
BWIDGET_SRCDIR=$(BUILD_DIR)/bwidget-$(BWIDGET_VERSION)

THREADS_SRCDIR=$(TCL_SRCDIR)/pkgs/thread$(THREADS_VERSION)
threads_pkgIndex=$(THREADS_SRCDIR)/pkgIndex.tcl

WITH_TCL=--with-tcl=$(TCL_SRCDIR)/$(TCL_PLATFORM)
WITH_TK=--with-tk=$(TK_SRCDIR)/$(TCL_PLATFORM)

.PHONY: all-packages help-packages
.PHONY: tcl tk ck tclreadline threads expect critcl tclx tcllib bwidget

# ck fails on a matherr link error in Glibc 2.27+ on Linux (see math manpage)
all-packages: stable-packages ck critcl

stable-packages: tcl tk tclreadline threads expect tclx tcllib bwidget

help-packages:
	@echo "make tcl: build tcl"
	@echo "make tk: build tk (will build tcl first if needed)"
	@echo "make ck: build ck (a link error on matherr may occur on Linux systems running Glibc 2.27+)"
	@echo "make tclreadline: build tclreadline"
	@echo "make threads: build tcl threads (a subpackage of tcl)"
	@echo "make expect: build expect"
	@echo "make critcl: build critcl"
	@echo "make tclx: build tclx"
	@echo "make tcllib: build tcllib"
	@echo "make bwidget: build bwidget"

tcl: $(tclsh)

$(tclsh):
	$(MAKE) $(TCL_SRCDIR) && cd $(TCL_SRCDIR)/$(TCL_PLATFORM) && ./configure --prefix=$(PREFIX) $(X11_FLAGS) $(THREADS_FLAGS) $(MORE_TCL_FLAGS) && $(MAKE) && $(MAKE) install

tk: $(wish)

# LIB_RUNTIME_DIR must be specified to circumvent a bug in Tk's configure (TCL_LD_SEARCH_FLAGS is never defined in configure.in and prevents conversion from : to -L in LIB_RUNTIME_DIR)
# This bug occurs in MacOSX only
$(wish): $(tclsh)
	$(MAKE) $(TK_SRCDIR) && cd $(TK_SRCDIR)/$(TCL_PLATFORM) && ./configure --prefix=$(PREFIX) $(WITH_TCL) $(X11_FLAGS) $(THREADS_FLAGS) $(MORE_TCL_FLAGS) $(MORE_TK_FLAGS) && $(MAKE) LIB_RUNTIME_DIR=$(PREFIX)/lib && $(MAKE) install

ck: $(cwsh)

tclreadline: $(tclreadline-folder)

# explicit CFLAGS is necessary with tclreadline because tclreadline's configure doesn't recognize --with-x-includes
$(tclreadline-folder): tcl tk
	$(MAKE) $(TCLREADLINE_SRCDIR) && cd $(TCLREADLINE_SRCDIR) && ./configure --prefix=$(PREFIX) $(WITH_TCL) $(WITH_TK) $(READLINE_FLAGS) $(X11_FLAGS) --enable-tclshrl --enable-wishrl $(THREADS_FLAGS) $(MORE_TCL_FLAGS) $(MORE_TK_FLAGS) CFLAGS=-I$(X11_PREFIX)/include && $(MAKE) && $(MAKE) install


$(cwsh): $(tclsh)
	$(MAKE) $(CK_SRCDIR) && cd $(CK_SRCDIR) && ./configure --prefix=$(PREFIX) $(WITH_TCL) $(X11_FLAGS) && $(MAKE) && $(MAKE) install 

threads: $(threads_pkgIndex)

$(threads_pkgIndex):
	$(MAKE) $(THREADS_SRCDIR) && cd $(THREADS_SRCDIR) && ./configure --prefix=$(PREFIX) $(THREADS_FLAGS) $(MORE_TCL_FLAGS) $(WITH_TCL) && $(MAKE) && $(MAKE) install

expect: $(expect_cmd)

$(expect_cmd): $(tclsh)
	$(MAKE) $(EXPECT_SRCDIR) && cd $(EXPECT_SRCDIR) && ./configure --prefix=$(PREFIX) $(THREADS_FLAGS) $(MORE_TCL_FLAGS) $(WITH_TCL) && $(MAKE) && $(MAKE) install

critcl: $(critcl_cmd)

$(critcl_cmd): $(tclsh)
	$(MAKE) $(CRITCL_SRCDIR) && cd $(CRITCL_SRCDIR) && $(tclsh) ./build.tcl install

tclx: $(tclx_lib)

$(tclx_lib): $(tclsh)
	$(MAKE) $(TCLX_SRCDIR) && cd $(TCLX_SRCDIR) && ./configure --prefix=$(PREFIX) $(THREADS_FLAGS) $(MORE_TCL_FLAGS) $(WITH_TCL) && $(MAKE) && $(MAKE) install

tcllib: $(tcllib_lib)

$(tcllib_lib): $(tclsh)
	$(MAKE) $(TCLLIB_SRCDIR) && cd $(TCLLIB_SRCDIR) && ./configure --prefix=$(PREFIX) --with-tclsh=$(tclsh) && $(MAKE) && $(MAKE) install

bwidget: $(bwidget_lib)

$(bwidget_lib): $(PREFIX)
	$(MAKE) $(BWIDGET_SRCDIR) && mkdir -p -v $(PREFIX)/lib && mv $(BWIDGET_SRCDIR) $(PREFIX)/lib/BWidget

$(THREADS_SRCDIR): $(TCL_SRCDIR)

$(PREFIX):
	mkdir -p -v $@

############## EXTRACT ARCHIVES INTO BUILD_DIR ###############
$(TCL_SRCDIR): $(TCL_TARBALL)
	$(MAKE) $(BUILD_DIR) && $(UNTAR) $< -C $(BUILD_DIR)

$(TK_SRCDIR): $(TK_TARBALL)
	$(MAKE) $(BUILD_DIR) && $(UNTAR) $< -C $(BUILD_DIR)

$(CK_SRCDIR): $(CK_ZIPFILE)
	$(MAKE) $(BUILD_DIR) && $(UNZIP) $< -d $(BUILD_DIR)

$(TCLREADLINE_SRCDIR): $(TCLREADLINE_ZIPFILE)
	$(MAKE) $(BUILD_DIR) && $(UNZIP) $< -d $(BUILD_DIR)

$(EXPECT_SRCDIR): $(EXPECT_TARBALL)
	$(MAKE) $(BUILD_DIR) && $(UNTAR) $< -C $(BUILD_DIR)

$(CRITCL_SRCDIR): $(CRITCL_TARBALL)
	$(MAKE) $(BUILD_DIR) && $(UNTAR) $< -C $(BUILD_DIR)

$(TCLX_SRCDIR): $(TCLX_ZIPFILE)
	$(MAKE) $(BUILD_DIR) && $(UNZIP) $< -d $(BUILD_DIR)

$(TCLLIB_SRCDIR): $(TCLLIB_TARBALL)
	$(MAKE) $(BUILD_DIR) && $(UNTAR) $< -C $(BUILD_DIR)

$(BWIDGET_SRCDIR): $(BWIDGET_TARBALL)
	$(MAKE) $(BUILD_DIR) && $(UNTAR) $< -C $(BUILD_DIR)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

################## ARCHIVES ###################

$(TCL_TARBALL):
	@echo "$(TCL_TARBALL) not found. Please download it first, or update the $(VERSIONS_CFG) file" 1>&2 && false

$(TK_TARBALL):
	@echo "$(TK_TARBALL) not found. Please download it first, or update the $(VERSIONS_CFG) file" 1>&2 && false

$(CK_ZIPFILE):
	@echo "$(CK_ZIPFILE) not found. Please download it first, or update the $(VERSIONS_CFG) file" 1>&2 && false

$(TCLREADLINE_ZIPFILE):
	@echo "$(TCLREADLINE_ZIPFILE) not found. Please download it first, or update the $(VERSIONS_CFG) file" 1>&2 && false

$(EXPECT_TARBALL):
	@echo "$(EXPECT_TARBALL) not found. Please download it first, or update the $(VERSIONS_CFG) file" 1>&2 && false

$(CRITCL_TARBALL):
	@echo "$(CRITCL_TARBALL) not found. Please download it first, or update the $(VERSIONS_CFG) file" 1>&2 && false

$(TCLX_ZIPFILE):
	@echo "$(TCLX_ZIPFILE) not found. Please download it first, or update the $(VERSIONS_CFG) file" 1>&2 && false

$(TCLLIB_TARBALL):
	@echo "$(TCLLIB_TARBALL) not found. Please download it first, or update the $(VERSIONS_CFG) file" 1>&2 && false

$(BWIDGET_TARBALL):
	@echo "$(BWIDGET_TARBALL) not found. Please download it first, or update the $(VERSIONS_CFG) file" 1>&2 && false

