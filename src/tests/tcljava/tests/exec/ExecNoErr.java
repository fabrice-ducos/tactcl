/*
 * ExecNoErr.java --
 *
 * jacl/tests/exec/ExecNoErr.java
 *
 * Copyright (c) 1998 by Moses DeJong
 *
 * See the file "license.terms" for information on usage and redistribution
 * of this file, and for a DISCLAIMER OF ALL WARRANTIES.
 *
 * RCS: @(#) $Id: ExecNoErr.java,v 1.2.1.1 1999/01/29 20:52:09 mo Exp $
 *
 */


package tests.exec;

public class ExecNoErr {
  public static void main(String[] argv) {
    System.out.println("!stdout!");
    System.err.println("!stderr!");
    System.exit(0);
  }
}

