TAR=tar cvf
include ../build.cfg

.PHONY: all download help clean erase
.PHONY: tcl tk ck expect critcl tclx tcllib bwidget jtcl

all: download

download: $(TARGETS)

help:
	@echo
	@echo "Current configuration"
	@echo "====================="
	@echo
	@echo "download tool: $(DOWNLOAD_TOOL)"
	@echo
	@echo "tcl:      tcl $(TCL_VERSION)"
	@echo "tk:       tk $(TK_VERSION)"
	@echo "ck:       ck $(CK_VERSION)"
	@echo "tclreadline: tclreadline $(TCLREADLINE_VERSION)"
	@echo "expect:   expect $(EXPECT_VERSION)"
	@echo "tcllib:   tcllib $(TCLLIB_VERSION)"
	@echo "bwidget:  bwidget $(BWIDGET_VERSION)"
	@echo "critcl:   critcl $(CRITCL_VERSION)"
	@echo "tclx:     tclx $(TCLX_VERSION)"
	@echo "tclblend: tclblend $(TCLBLEND_VERSION)"
	@echo "jacl:     jacl $(JACL_VERSION)"
	@echo "jaclin:   jaclin $(JACLIN_VERSION)"

# https://prdownloads.sourceforge.net/tcl/tcl869-src.zip
# https://prdownloads.sourceforge.net/tcl/tcl8.6.9-src.tar.gz
#
# For getting the latest version on sourceforge:
# wget https://sourceforge.net/projects/tcl/files/latest/download
#
# Recommendations from sourceforge:
# https://sourceforge.net/p/forge/documentation/Downloading%20files%20via%20the%20command%20line/
tcl: tcl$(TCL_VERSION)-src.tar.gz

tcl$(TCL_VERSION)-src.tar.gz:
	$(DOWNLOAD_TOOL) https://prdownloads.sourceforge.net/tcl/tcl$(TCL_VERSION)-src.tar.gz

# https://prdownloads.sourceforge.net/tcl/tk869-src.zip
# https://prdownloads.sourceforge.net/tcl/tk8.6.9.1-src.tar.gz
tk: tk$(TK_VERSION)-src.tar.gz

tk$(TK_VERSION)-src.tar.gz:
	$(DOWNLOAD_TOOL) https://prdownloads.sourceforge.net/tcl/tk$(TK_VERSION)-src.tar.gz

ck: ck-$(CK_VERSION).zip

ck-$(CK_VERSION).zip:
	$(DOWNLOAD_TOOL) https://github.com/credil/ck/archive/$(CK_VERSION).zip -O ck-$(CK_VERSION).zip

# https://github.com/flightaware/tclreadline/archive/v2.3.8.zip
tclreadline: tclreadline-$(TCLREADLINE_VERSION).zip

tclreadline-$(TCLREADLINE_VERSION).zip:
	$(DOWNLOAD_TOOL) https://github.com/flightaware/tclreadline/archive/v$(TCLREADLINE_VERSION).zip -O tclreadline-$(TCLREADLINE_VERSION).zip

# https://sourceforge.net/projects/expect/files/Expect%204%20Windows/2008-06-10/expect-src.zip
# https://sourceforge.net/projects/expect/files/Expect/5.45.4/expect5.45.4.tar.gz
# https://sourceforge.net/projects/expect/files/Expect/5.45.4/expect5.45.4.tar.gz.SHA256
expect: expect$(EXPECT_VERSION).tar.gz

expect$(EXPECT_VERSION).tar.gz:
	$(DOWNLOAD_TOOL) https://sourceforge.net/projects/expect/files/Expect/$(EXPECT_VERSION)/expect$(EXPECT_VERSION).tar.gz

# https://github.com/andreas-kupries/critcl/archive/3.1.17.zip
# https://github.com/andreas-kupries/critcl/archive/3.1.17.tar.gz
critcl: critcl-$(CRITCL_VERSION).tar.gz

critcl-$(CRITCL_VERSION).tar.gz:
	$(DOWNLOAD_TOOL) https://github.com/andreas-kupries/critcl/archive/$(CRITCL_VERSION).tar.gz -O critcl-$(CRITCL_VERSION).tar.gz

# https://github.com/flightaware/tclx/archive/v8.4.2.zip
tclx: tclx-$(TCLX_VERSION).zip

tclx-$(TCLX_VERSION).zip:
	$(DOWNLOAD_TOOL) https://github.com/flightaware/tclx/archive/v$(TCLX_VERSION).zip -O tclx-$(TCLX_VERSION).zip

# https://sourceforge.net/projects/tcllib/files/tcllib/1.19/tcllib-1.19.zip
# https://sourceforge.net/projects/tcllib/files/tcllib/1.19/tcllib-1.19.tar.gz
# https://sourceforge.net/projects/tcllib/files/tcllib/1.19/tcllib-1.19.tar.xz
# https://sourceforge.net/projects/tcllib/files/tcllib/1.19/tcllib-1.19.kit
# https://sourceforge.net/projects/tcllib/files/tcllib/1.19/tcllib-1.19.SHA256
tcllib: tcllib-$(TCLLIB_VERSION).tar.gz

tcllib-$(TCLLIB_VERSION).tar.gz:
	$(DOWNLOAD_TOOL) https://sourceforge.net/projects/tcllib/files/tcllib/$(TCLLIB_VERSION)/tcllib-$(TCLLIB_VERSION).tar.gz

# https://sourceforge.net/projects/tcllib/files/BWidget/1.9.13/bwidget-1.9.13.zip
# https://sourceforge.net/projects/tcllib/files/BWidget/1.9.13/bwidget-1.9.13.tar.gz
bwidget: bwidget-$(BWIDGET_VERSION).tar.gz

bwidget-$(BWIDGET_VERSION).tar.gz:
	$(DOWNLOAD_TOOL) https://sourceforge.net/projects/tcllib/files/BWidget/$(BWIDGET_VERSION)/bwidget-$(BWIDGET_VERSION).tar.gz

# https://github.com/jtcl-project/jtcl/releases
# https://github.com/jtcl-project/jtcl/archive/2.8.0-release.tar.gz
jtcl: jtcl-$(JTCL_VERSION).tar.gz

jtcl-$(JTCL_VERSION).tar.gz:
	$(DOWNLOAD_TOOL) https://github.com/jtcl-project/jtcl/archive/$(JTCL_VERSION).tar.gz -O jtcl-$(JTCL_VERSION).tar.gz
clean:
	-rm -f *~

erase:
	-rm -vf *.tar.gz
	-rm -vf *.zip

