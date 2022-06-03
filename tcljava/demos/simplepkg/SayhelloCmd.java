/*
 * SayhelloCmd.java
 *
 * Copyright (c) 1997 Sun Microsystems, Inc.
 *
 *   This file implements the SayhelloCmd class.
 *
 * See the file "license.terms" for information on usage and
 * redistribution of this file, and for a DISCLAIMER OF ALL
 * WARRANTIES.
 *
 * RCS: @(#) $Id: SayhelloCmd.java,v 1.2.1.2 1999/02/01 00:40:46 mo Exp $
 */

import tcl.lang.*;

/**
 * This class implements the "sayhello" command in SimplePackage.
 */

class SayhelloCmd implements Command {
    // This procedure is invoked to process the "sayhello" Tcl command.
    // It takes no arguments and returns "Hello World!" string as
    // its result.

    public void cmdProc(Interp interp, TclObject argv[])
	    throws TclException {
	if (argv.length != 1) {
	    throw new TclNumArgsException(interp, 1, argv, "");
	}
	interp.setResult("Hello World!");
    }
}
