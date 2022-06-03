/*
 *  Test1.java
 *
 * Copyright (c) 1997 Sun Microsystems, Inc.
 *
 * See the file "license.terms" for information on usage and
 * redistribution of this file, and for a DISCLAIMER OF ALL
 * WARRANTIES.
 * 
 * RCS: @(#) $Id: Test1Cmd.java,v 1.2.1.1 1999/01/29 20:52:09 mo Exp $
 *
 */

package tests.javaload;
import tcl.lang.*;


public class
Test1Cmd implements Command {
    public void cmdProc(Interp interp, TclObject argv[]) throws TclException {
	interp.setResult("test works");
    }
}

