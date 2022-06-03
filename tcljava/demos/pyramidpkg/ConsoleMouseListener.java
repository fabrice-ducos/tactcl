/*
 * ConsoleMouseListener.java
 *
 * Copyright (c) 1997 Sun Microsystems, Inc.
 *
 *   This class implements the ConsoleMouseListener class.
 *
 * See the file "license.terms" for information on usage and
 * redistribution of this file, and for a DISCLAIMER OF ALL
 * WARRANTIES.
 *
 * RCS: @(#) $Id$
 */

import java.awt.*;
import java.awt.event.*;

/*
 * This MouseListener widget voids user mouse activity.
 */

public class ConsoleMouseListener implements MouseListener {

    public void mousePressed(MouseEvent evt) {
    }

    public void mouseReleased(MouseEvent evt) {
    }
    /* WARNING:  Not yot working.
     * We want the mouse clicks to always place the cursor at the end of
     * of the text buffer.
     */

    public void mouseClicked(MouseEvent evt) {
    }

    public void mouseEntered(MouseEvent evt) {
    }

    public void mouseExited(MouseEvent evt) {
    }
}

