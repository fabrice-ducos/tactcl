/*
 * PutsCmd.java
 *
 * Copyright (c) 1997 Cornell University.
 * Copyright (c) 1997 Sun Microsystems, Inc.
 *
 * See the file "license.terms" for information on usage and
 * redistribution of this file, and for a DISCLAIMER OF ALL
 * WARRANTIES.
 * 
 * RCS: @(#) $Id: PutsCmd.java,v 1.1.1.1 1998/10/14 21:09:20 cvsadmin Exp $
 *
 */

package tcl.lang;

import java.util.*;
import java.io.*;

/**
 * This class implements the built-in "puts" command in Tcl.
 */

class PutsCmd implements Command {
    /**
     * Prints the given string to a channel. See Tcl user
     * documentation for details.
     *
     * @param interp the current interpreter.
     * @param argv command arguments.
     */

    public void cmdProc(Interp interp, TclObject argv[])
	    throws TclException {

	Channel chan;        /* The channel being operated on this method */
	String  channelId;   /* String containing the key to chanTable */
	String  arg;         /* Argv[i] converted to a string */
	int     i = 1;       /* Index to the next arg in argv */
	boolean newline = true;
                             /* Indicates to print a newline in result */

	if ((argv.length >= 2) && (argv[1].toString().equals("-nonewline"))) {
	    newline = false;
	    i++;
	}
	if ((i < argv.length-3) || (i >= argv.length)) {
	    throw new TclNumArgsException(interp, 1, argv, 
		    "?-nonewline? ?channelId? string");
	}

	/*
	 * The code below provides backwards compatibility with an old
	 * form of the command that is no longer recommended or documented.
	 */

	if (i == (argv.length-3)) {
	    arg = argv[i+2].toString();
	    if (!arg.equals("nonewline")) {
	        throw new TclException(interp, "bad argument \"" + arg +
		        "\": should be \"nonewline\"");
	    }
	    newline = false;
	}

	if (i == (argv.length-1)) {
	    channelId = "stdout";
	} else {
	    channelId = argv[i].toString();
	    i++;
	}

	if (i != (argv.length-1)) {
	    throw new TclNumArgsException(interp, 1, argv, 
		    "?-nonewline? ?channelId? string");
	}

	chan = TclIO.getChannel(interp, channelId);
	if (chan == null) {
	    throw new TclException(interp, "can not find channel named \""
                    + channelId + "\"");
	}

	if ((chan.getMode() & TclIO.RDONLY) != 0) {
	    throw new TclException(interp, "channel \"" + channelId
		    + "\" wasn't opened for writing");
	}

	try { 
	    if (newline) {
	        chan.write(interp, argv[i].toString() + "\n" );
	    } else {
	        chan.write(interp, argv[i].toString());
	    }
	} catch (IOException e) {
	    throw new TclRuntimeError(
		    "PutsCmd.cmdProc() Error: IOException when putting " +
		    chan.getChanName());
	}
    }
}
