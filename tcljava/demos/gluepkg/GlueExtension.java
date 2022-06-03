/*
 * GUIExtension.java --
 *
 * Copyright (c) 1997 Sun Microsystems, Inc.
 *
 * See the file "license.terms" for information on usage and
 * redistribution of this file, and for a DISCLAIMER OF ALL
 * WARRANTIES.
 * 
 * RCS: @(#) $Id: GlueExtension.java,v 1.2.1.2 1999/02/01 00:40:46 mo Exp $
 */

import tcl.lang.*; 

/**
 * This class implements a simple Tcl extension package "GUIExtension". This
 * package contains one Tcl command "sayhello". See the API documentation of
 * the tcl.lang.Extension class for details.
 */

public class GlueExtension extends Extension {

    // init --
    // Create all the commands in the Simple package. 

    public void init(Interp interp) {
      	interp.createCommand("filedialog", new FileDialogCmd());
	interp.createCommand("listbox",    new ListboxCmd());
	interp.createCommand("jar",        new JarCmd());
    }
}

