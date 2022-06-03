/*
 * Copyright (c) 2005 Advanced Micro Devices, Inc.
 *
 * See the file "license.amd" for information on usage and
 * redistribution of this file, and for a DISCLAIMER OF ALL
 * WARRANTIES.
 * 
 * RCS: @(#) $Id: TJCCommandCmd.java,v 1.4 2006/04/13 07:36:51 mdejong Exp $
 *
 */

package tcl.lang;

public class TJCCommandCmd implements Command {

// Implementation of TJC::command used to create
// compiled command instances at runtime.

public void 
    cmdProc(
        Interp interp,
        TclObject[] objv)
            throws TclException
    {
        if (objv.length != 3) {
            throw new TclNumArgsException(interp, 1, objv,
                "cmdname classname");
        }
        String cmdname   = objv[1].toString();
        String classname = objv[2].toString();

        // Create instance of named command
        Class c = JavaInvoke.getClassByName(interp, classname);

        Object o = null;
        try {
            o = c.newInstance();
        } catch  (InstantiationException ie) {
            throw new TclException(interp,
                "instance of class " + classname + " could not be created");
        } catch  (IllegalAccessException iae) {
            throw new TclException(interp,
                "instance of class " + classname + " could not be created");
        }
        if (!(o instanceof TJC.CompiledCommand)) {
            throw new TclException(interp,
                "class " + classname + " must extend TJC.CompiledCommand");
        }
        TJC.CompiledCommand cmd = (TJC.CompiledCommand) o;
        TJC.createCommand(interp, cmdname, cmd);
        interp.resetResult();
        return;
    }
}

