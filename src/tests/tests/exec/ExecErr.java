/* 
 * ExecErr.java --
 *
 *
 * Copyright (c) 1997 by Sun Microsystems, Inc.
 *
 * See the file "license.terms" for information on usage and redistribution
 * of this file, and for a DISCLAIMER OF ALL WARRANTIES.
 *
 * RCS: @(#) $Id$
 *
 */

package tests.exec;

public class ExecErr {
  public static void main(String[] argv) {
    System.out.println("!stdout!");
    System.err.println("!stderr!");
    System.exit(-1);
  }
}

