/*
 * TclRuntimeError.java
 *
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

/**
 * Signals that a unrecoverable run-time error in the interpreter.
 * Similar to the panic() function in C.
 */
public class TclRuntimeError extends RuntimeException {
    /**
     * Constructs a TclRuntimeError with the specified detail
     * message.
     *
     * @param s the detail message.
     */
    public TclRuntimeError(String s) {
	super(s);
    }
}

