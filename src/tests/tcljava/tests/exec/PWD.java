/*
 * PWD.java --
 *
 * jacl/tests/exec/PWD.java
 *
 * Copyright (c) 1998 by Moses DeJong
 *
 * See the file "license.terms" for information on usage and redistribution
 * of this file, and for a DISCLAIMER OF ALL WARRANTIES.
 *
 * RCS: @(#) $Id: PWD.java,v 1.2.1.1 1999/01/29 20:52:09 mo Exp $
 *
 */

package tests.exec;

public class PWD {
  public static void main(String[] argv) {
    String dirName = System.getProperty("user.dir");
    
    String os = System.getProperty("os.name");

    if (os.toLowerCase().startsWith("win")) {
      dirName = dirName.replace('\\', '/');
    }
    
    System.out.println( dirName );
    System.exit(0);
  }
}

