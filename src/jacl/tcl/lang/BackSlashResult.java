/*
 * BackSlashResult.java
 *
 * Copyright (c) 1997 Cornell University.
 * Copyright (c) 1997 Sun Microsystems, Inc.
 *
 * See the file "license.terms" for information on usage and
 * redistribution of this file, and for a DISCLAIMER OF ALL
 * WARRANTIES.
 * 
 * RCS: @(#) $Id$
 *
 */

package tcl.lang;

class BackSlashResult {
    char c;
    int nextIndex;
    boolean isWordSep;
    BackSlashResult(char ch, int w) {
	c = ch;
	nextIndex = w;
	isWordSep = false;
    }
    BackSlashResult(char ch, int w, boolean b) {
	c = ch;
	nextIndex = w;
	isWordSep = b;
    }
}

