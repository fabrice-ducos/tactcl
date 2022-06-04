# TacTCL 0.3.1
(pronounce "tactical")

A small, free Tcl/Tk distribution with some popular Tcl/Tk packages built from sources.

IT IS NOT A REPLACEMENT FOR ActiveState Tcl.
If you need a production-ready, stable version of Tcl, it's probably better to rely on commercially supported packages such as ActiveState's.

TacTCL's goal is to gather several popular, reasonably stable packages and compile them on your system with your available compiler, instead of relying on precompiled binaries.

The policy of TacTCL is that the default configuration should provide working, stable versions of main packages, but that the user should be able to easily try any configuration of her liking by editing a simple `build.cfg` text file. Contributors are welcome to propose newer default configurations after testing them. 

`tactcl` provides native and JVM builds for Tcl. For the JVM builds, it uses a TclJava fork from TacTCL's author, that supports recent versions of Tcl (8.6) and of the JDK (JDK 10 and newer, with support for JDK 4- dropped). It was tested successfully with JDK 17 and Tcl 8.6.12.

*The JVM builds with modern JDK and last versions of Tcl (8.6 with TclOO support) are a unique feature of TacTCL (currently not available in other Tcl distributions, at the author's knwoledge)*.

*Properly used, they can provide a safe environment with a server-side Java security manager, and Safe Tcl running on the JVM for the controlled execution of untrusted scripts (with smooth communication between Java and Tcl layers)*

This is a work in progress and still experimental (contributors are welcome).
It should work on any Unix-like system (Linux, BSD, OSX) with a Java Development Kit installed.
Windows native is not supported for the moment (the Unix make command is required, preferrably GNU make), but a workaround is to use Cygwin or a Linux image on Windows (on Windows 10+). One can install `make` and other tools on Windows with the [chocolatey](https://chocolatey.org) package manager. 

## To get started

### For the impatient

Copy the file `build.cfg.dist` under the name `build.cfg`, check it up and configure it according to your environment and needs.
The default values should be fine for Tcl, Tk and TclJava, but not for `make all`.

Just type `make`
The sources from a Tcl stable version will be extracted, and all what you need (binaries, libraries, header files) will be created in the `local` directory.
Especially, you will find the binaries under `local/bin`.

You can copy the directories wherever you need (e.g. under `/usr/local`).
`TacTCL` doesn't currently perform an automatic installation in system directories to avoid overwriting a working installation.
It is up to the user to copy the tools under their system directories.

For installing Tcl/Tk, type `make tk`

For installing TclJava (TclBlend and Jacl), type `make tcljava`

For installing everything, type `make all` (you may experience errors depending on your environment, this early version of TacTCL doesn't take care of missing dependencies of the packages it gathers).

For a list of all the available commands: `make help`

You can test `jtclsh` and `jaclsh` (the JVM Tcl interpreters from Tclblend and Jacl) with these commands:

```
$ ./local/bin/jtclsh 
% puts $tcl_version
8.6
```

```
$ ./local/bin/jaclsh 
% puts $tcl_version
8.0
```

### To get a more user's friendly tcl shell
(currently recognized by tclsh and jtclsh but not by jaclsh):

`cp tclshrc $HOME/.tclshrc # don't forget the dot in the target`

Edit the first line (lappend autopath) of `$HOME/.tclshrc` to the proper path of the Tcl package root on your system
(this must be currently done manually; this should be improved later)

### If you need more control

Edit `build.cfg`:
  - comment or uncomment the lines depending on the needed tools
  - edit the installation path: PREFIX

Edit `versions.cfg`
  - set the desired versions for the tools (so you can compile a prefered version of Tcl or of some packages for your system)

Once everything is set up, launch `make help` to see the list of available build targets, and check the configuration.

`make` will attempt to build all the targets specified in `build.cfg`

## Requirements
  - A modern JDK (JDK 5+, JDK 8+ recommended)
  - A modern version of Tcl (8.6+ recommended)
  - A system with `GNU make` installed (other versions of `make` may work, but none has been tested yet)
  - the following tools (usually available or easily installable on most Unix-like systems): unzip and tar
  - later on, wget and/or curl may be required for automatic downloading of new versions of packages

## What is installed by default by this version of TacTCL

  - tcl: the core langage
  - tk: the popular Tk toolkit
  - ck: a Tk clone for the console, based on curses (currently no version tag available)
  - tclreadline: a command line interpreter facility for tcl (syntax highlighthing and history-aware interpreter)
  - expect: the famous automation tool based on Tcl
  - tcllib: standard tcl library
  - bwidget: a cross-platform widget toolkit for Blender (currently GPL2)
  - critcl: package for on-the-fly compilation of tcl scripts
  - tclx: popular extensions for Tcl
  - jaclin: a TclJava fork (Tcl on the JVM), with Tclblend updated for Tcl 8.6 (jtclsh 8.6 and jaclsh 8.0)

## NOTES

  - Before version 0.3.0, TacTCL was relying on another project Jaclin (Jacl INside), that
    was a fork of [TclJava](https://sourceforge.net/projects/tcljava/files/), migrated from
    SVN to GIT with [reposurgeon](https://gitlab.com/esr/reposurgeon) and updated for modern
    versions of the JDK and of TCL. 
  - TacTCL started as a small TCL distribution including several general-purpose Tcl tools
    and TclJava.
  - Both projects proved difficult to maintain and build separately. TacTCL 0.3.0 is basically
    a merge of TacTCL 0.2.9 and Jaclin 0.1.4.

## TODO
  - Test on various Linux and BSD distributions
  - Port on Windows native (.bat, nmake)
