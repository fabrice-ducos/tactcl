#
#  Copyright (c) 2005 Advanced Micro Devices, Inc.
#
#  See the file "license.amd" for information on usage and
#  redistribution of this file, and for a DISCLAIMER OF ALL
#   WARRANTIES.
#
#  RCS: @(#) $Id: File.tcl,v 1.19 2005/11/23 21:19:14 mdejong Exp $
#
#

# Utility methods used by various TJC modules.

# Save data into a file with LF translation.

proc tjc_util_file_saveas { filename data } {
    set fd [open $filename w]
    fconfigure $fd -translation lf
    puts $fd $data
    close $fd
    return
}

proc tjc_util_file_read { filename } {
    set fd [open $filename r]
    set data [read $fd]
    close $fd
    return $data
}

