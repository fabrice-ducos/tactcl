# Jaclin 0.1.0

Jaclin is a fork of the TclJava project, who was developed and maintained by Mo Dejong and contributors until 2010.

## Installation

TclJava could be quite involved to build from the sources, because of its many dependencies (at least JDK and Tcl/Tk, each version of which coming with their own lot of idiosyncracies). Jaclin is no different.

In order to ease the process, Jaclin's maintainer is developing [tclbuild](https://github.com/fabrice-ducos/tclbuild), a build tool for Tcl/Tk and Jaclin. It downloads frozen (but configurable) versions of Tcl/Tk, Jaclin (and some Tcl popular modules) and builds them accordingly.

The brave ones (or those not wishing to try tclbuild, that is a work in progress and still unstable) can attempt to perform a manual installation. See [TclJava Documentation](docs/Topics/index.html).

## Context and motivation for this fork

TclJava provided a bridge between Java and Tcl technologies. Unfortunately, the project's lack of momentum
in the 2010-2020 decade made it difficult to simply build TclJava main tools (tclblend and jacl) with modern Java
Development Kits. Official [TclJava](http://tcljava.sourceforge.net/docs/website/index.html) on sourceforge lacks
Mo's last updates (between 2008 and 2010) and is not guaranteed to work with versions of Java newer than 5.
It doesn't support Tcl 8.5 and 8.6
An archive of TclJava can also be [found on github](https://github.com/scijava/tcljava).

Another fork, [JTcl](https://github.com/jtcl-project/jtcl), was started around 2015, included the support for Java 6 but seems to be dormant since 2017.

Interested in performing Tcl scripting on modern Java versions in the context of another project, I made some patches and [unsuccessfully attempted](https://sourceforge.net/p/tcljava/mailman/tcljava-dev/thread/CAPxFAHTkKiLxQGAVJUfY5hCGBoAbL47qnc0WfMsvcD%2BT6W2uJQ%40mail.gmail.com/#msg36653208) to contact the original developers for updating the original TclJava project. 

After one year of lack of reply, I decided to propose my own fork of the project, Jaclin (that can be interpreted as Jacl INside, or Jacl IS NOT TclJava), based on original TclJava.
The GIT repository was migrated from CVS (keeping the CVS history) with the help of [reposurgeon](https://gitlab.com/esr/reposurgeon).

The goal of Jaclin is to revive the TclJava project by fixing bugs, and providing a simpler installation process with support for modern versions of JDK (5 and more, tested up to 12) and Tcl (experimental support of 8.5 and 8.6) on most common operating systems (Windows, OSX, Linux, BSD).

## NEWS

        * Experimental support of latest versions of Tcl (at least Tcl 8.5
        and Tcl 8.6) and of modern JDK (10+);
        support of JDK 4- abandoned (use of auto-boxing);
        support of OSX systems added;
        details below

        * configuration (tcljava.m4, configure.in),
        and compilation (Makefile.in) templates updated for
        JDK 10+ (javah not available anymore).
        javah is still used when it is available (JDK 9-).
        * minor update of jtclsh.in (for OSX dynamic libraries)
        * many obsolescent constructs (mostly old-style boxing)
        removed in *.java under src/jacl/tcl/lang,
        src/tclblend/tcl/lang and src/tcljava/tcl/lang,
        in order to silence many warnings.
        (effect: support of JDK 4- abandoned)
        * src/native/javaInterp.c: 2010 implementation
        of Java_tcl_lang_Interp_initName() crashed on the
        example given at docs/website/getstart.html,
        because calling Tcl_GetNameOfExecutable
        before Tcl_FindExecutable gives rise to undefined
        behaviour, at least in latest versions of Tcl
        (crashes observed on several systems, at least with
        Tcl 8.6).
        Java_tcl_lang_Interp_initName() is now simplified and
        always calls Tcl_FindExecutable first.
        * all the occurences of interp->result have been
        replaced with Tcl_GetStringResult(interp).
        Accessing interp->result directly was deprecated in
        latest versions of the Tcl C API, and removed from
        Tcl 8.6 (another solution was to #define USE_INTERP_RESULT,
        but this would have been an easy-going, quick and dirty way)
        ref. https://www.tcl.tk/man/tcl/TclLib/Interp.htm

## Getting Started

An old (but still relevant) reference to TclJava: http://tcljava.sourceforge.net/docs/website/matchmadeforscripting.html

It is recommended to consult first docs/contents.html inside the project, then docs/Topics/index.html
for hints on building and installing TclJava (or Jaclin) on various environments.

See also the Installing section.

### Prerequisites

A modern JDK (at least 5, preferably 8 or newer).
A modern version of Tcl (at least 8.4 is recommended)

## Authors

* **Mo Dejong** - *TclJava's project lead up to 2010* - [Mo Dejong](https://github.com/mdejong)
See also the list of [contributors](https://github.com/fabrice-ducos/jaclin/contributors).

* **Fabrice Ducos** - *Jaclin* (TclJava updated for modern JDK) - [Fabrice Ducos](https://github.com/fabrice-ducos)

## License

See license files in the repo for TclJava's original licenses.
