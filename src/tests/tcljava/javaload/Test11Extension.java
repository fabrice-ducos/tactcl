/*
 * Test11Extension.java
 *
 *    Test the loading of a class file that depends on another
 *    .class file that can't be resolved.
 *
 * Copyright (c) 2004 Mo DeJong
 *
 * See the file "license.terms" for information on usage and
 * redistribution of this file, and for a DISCLAIMER OF ALL
 * WARRANTIES.
 * 
 * RCS: @(#) $Id: Test11Extension.java,v 1.0 1999/05/10 04:08:54 dejong Exp $
 *
 */

import tcl.lang.*; 

public class
Test11Extension extends Extension {
    public void init(Interp interp) {
        // Dep can't be satisfied since we deleted the .class file!
        Test11ExtensionDep dep = new Test11ExtensionDep();
    }
}

class Test11ExtensionDep {}

