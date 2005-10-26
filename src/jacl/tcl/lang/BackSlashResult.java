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
 * RCS: @(#) $Id: BackSlashResult.java,v 1.1.1.1 1998/10/14 21:09:19 cvsadmin Exp $
 *
 */

package tcl.lang;

class BackSlashResult {
    char c;
    int nextIndex;
    boolean isWordSep;
    int count;

    BackSlashResult(char c, int nextIndex, int count) {
	this.c = c;
	this.nextIndex = nextIndex;
	this.isWordSep = false;
	this.count = count;
    }

    BackSlashResult(char c, int nextIndex, boolean isWordSep, int count) {
	this.c = c;
	this.nextIndex = nextIndex;
	this.isWordSep = false;
	this.count = count;
    }
}

