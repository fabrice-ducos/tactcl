/*
 * PrintArgs.java --
 *
 * jacl/tests/exec/PrintArgs.java
 *
 * Copyright (c) 1998 by Moses DeJong
 *
 * See the file "license.terms" for information on usage and redistribution
 * of this file, and for a DISCLAIMER OF ALL WARRANTIES.
 *
 * RCS: @(#) $Id: PrintArgs.java,v 1.2.1.1 1999/01/29 20:52:09 mo Exp $
 *
 */


package tests.exec;

public class PrintArgs {
  public static void main(String[] argv) {
    for (int i=0;i<argv.length;i++) {
      System.out.println(argv[i]);
    }
    System.exit(0);
  }
}

