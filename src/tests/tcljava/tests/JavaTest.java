/* 
 * JavaTest.java --
 *
 *	This file contains the JavaTest class used by java.test.
 *
 * Copyright (c) 1997 by Sun Microsystems, Inc.
 *
 * See the file "license.terms" for information on usage and redistribution
 * of this file, and for a DISCLAIMER OF ALL WARRANTIES.
 *
 * RCS: @(#) $Id: JavaTest.java,v 1.2.2.2 1999/03/18 07:30:46 mo Exp $
 */

package tests;
import tcl.lang.*;
import java.util.*;

public class JavaTest implements CommandWithDispose {

    // Constructors.

    public JavaTest() {}
    public JavaTest(String s) {}
    public JavaTest(String s, int i) {}
    public JavaTest(boolean b) {
	throw new NullPointerException();
    }

    // Constants.

    public static final int JT1 = 3;
    public final int JT2 = 4;
    private static final int JT3 = 5;
    private final int JT4 = 6;

    // Static fields for each primitive type.

    public static boolean sboolean;
    public static byte sbyte;
    public static short sshort;
    public static int sint;
    public static long slong;
    public static float sfloat;
    public static double sdouble;
    public static char schar;
    public static String sstr;

    public static JavaTest sobj;

    // Static methods.

    public static String smethod() { return "static"; }
    public static String nullsmethod() { return null; }
    public static void voidsmethod() { return; }

    // Instance fields for each type.

    public int iint		= 123;
    public boolean iboolean	= false;
    public long ilong		= 123;
    public short ishort		= 123;
    public byte ibyte		= 123;
    public float ifloat		= (float)123.0;
    public double idouble	= 123.0;
    public char ichar		= 'J';
    public String istr		= "test string";

    public Integer iobj1	= new Integer(123);
    public String iobj2		= new String("test string obj");
    public Object iobj3		= new Vector();
    public Object iobjnull	= null;


    public JavaTest iobj;


    // Instance methods.

    public int imethod() { return 6; }
    public int imethod(int i) { return i+1; }
    public String nullimethod() { return null; }
    public void voidimethod() { return; }
    public void failMethod() {
	throw new NullPointerException();
    }

    // Simple Tcl command implementation.

    public void cmdProc(Interp interp, TclObject argv[])
	    throws TclException
    {
	String s = argv[0].toString();
	for (int i = 1; i < argv.length; i++) {
	    s = s + ", " + argv[i].toString();
	}
	
	if (iboolean) {
	    interp.setResult(s + ": success");
	} else {
	    throw new TclException(interp, s + ": failure",
		    TCL.ERROR);
	}
    }
    
    public void disposeCmd() {
	istr = "disposed";
    }
}

