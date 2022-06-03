/* 
 * InfoTestClass.java --
 *
 *	Used to test the java::info command
 *
 * Copyright (c) 1997 by Sun Microsystems, Inc.
 *
 * See the file "license.terms" for information on usage and redistribution
 * of this file, and for a DISCLAIMER OF ALL WARRANTIES.
 *
 * RCS: @(#) $Id: InfoTestClass.java,v 1.2.1.1 1999/01/29 20:52:09 mo Exp $
 */

package tests.javainfo;
import java.lang.*;
import java.awt.*;

public class InfoTestClass {
    
    private int x;
    public int y;
    public int a;
    public int b;
    public static int c;
    public static int d;
    int z;
    
    public InfoTestClass() {

        x = 4;
        y = 5;
        z = 6;
    }

    public int sum() {
	return (x + y + z);
    }

    public static String clue() {
	return ("hint: z = x + 1");
    }

    public static String herring(int a) {
	return ("hint: z = x + 1");
    }

    public static String herring(int a, double b) {
	return ("hint: z = x + 1");
    }

    public static String herring(int a, double b, char c) {
	return ("hint: z = x + 1");
    }

    public void add1() {
	++x;
	++y;
	++z;
    }

    public void add(int i, int j, int k) {
	x += i;
	y += j;
	z += k;
    }

    private void guess() {
	y = x + z - y;
    }
}

