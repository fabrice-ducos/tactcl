/*
 * Test4Extension.java
 *
 *    Loads a class from a different classpath
 *
 * Copyright (c) 1997 Sun Microsystems, Inc.
 *
 * See the file "license.terms" for information on usage and
 * redistribution of this file, and for a DISCLAIMER OF ALL
 * WARRANTIES.
 * 
 * RCS: @(#) $Id: Test4Extension.java,v 1.2.1.1 1999/01/29 20:52:09 mo Exp $
 *
 */

import tcl.lang.*; 

public class
Test4Extension extends Extension {
    public void init(Interp interp) {
	interp.createCommand("test4", new tests.javaload.Test1Cmd());
    }
}

