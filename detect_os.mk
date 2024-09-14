# include this partial Makefile in your main Makefile and add a default rule, like this:
# include detect_os.mk
#
# .PHONY: default
# default: <any_dependency_you_need>
#     <any_action_you_need>

NATIVE_DIR=native
MAIN_TARGET=failed

ifeq ($(OS),Windows_NT)
  PLATFORM=windows
  JAVA_HOME:=$(subst \,\\,$(JAVA_HOME))
  # LIB_PREFIX is empty for Windows
  LIB_PREFIX=
  LIB_EXT=dll
  NATIVE_SUBDIR=$(NATIVE_DIR)/windows
  LIB_OPTION=shared
  MAIN_TARGET=default
  HOMEPATH_SAFE=$(subst \,/,$(HOMEPATH))
  M2_ROOT=$(HOMEDRIVE)$(HOMEPATH_SAFE)/.m2
  MAKE_ALIAS=cp
  MKDIR=mkdir
  RECURSIVE_CP=robocopy /S
else
  UNAME_S := $(shell uname -s)
  UNAME_P := $(shell uname -p)
  OS=$(UNAME_S)
  ifeq ($(UNAME_S), Darwin)
    PLATFORM=unix
    LIB_PREFIX=lib
    LIB_EXT=dylib
    NATIVE_SUBDIR=$(NATIVE_DIR)/macos
    LIB_OPTION=shared
    MAIN_TARGET=default
    M2_ROOT=$(HOME)/.m2
    MAKE_ALIAS=ln -sf
    MKDIR=mkdir -p
    RECURSIVE_CP=cp -R
  endif
  ifeq ($(UNAME_S),Linux)
    PLATFORM=unix
    LIB_PREFIX=lib
    LIB_EXT=so
    NATIVE_SUBDIR=$(NATIVE_DIR)/linux
    LIB_OPTION=shared
    MAIN_TARGET=default
    M2_ROOT=$(HOME)/.m2
    # On Linux, ln can create relative links with -r
    MAKE_ALIAS=ln -sfr
    MKDIR=mkdir -p
    RECURSIVE_CP=cp -r
  endif
endif

.PHONY: start
start: $(MAIN_TARGET)

.PHONY: failed
failed:
	@echo "System $(OS) not recognized or not supported for the time being"
