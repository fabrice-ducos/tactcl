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

proc reload {} {
    global _tjc

    set debug 0

    if {![info exists _tjc(tjc_load_dir)]} {
        set script [info script]
        set dir [file dirname $script]
        if {$debug} {
            puts "info script reports \"$script\""
            puts "script dir is \"$dir\""
        }
        set _tjc(tjc_load_dir) $dir
    } else {
        set dir $_tjc(tjc_load_dir)
        if {$debug} {
            puts "reloading from $dir"
        }
    }

    foreach file [list \
        compileproc.tcl \
        descend.tcl \
        emitter.tcl \
        jdk.tcl \
        main.tcl \
        module.tcl \
        nameproc.tcl \
        parse.tcl \
        parseproc.tcl \
        util.tcl \
        ] {
        if {$debug} {
            puts "source $dir/$file"
        }
        uplevel #0 [list source $dir/$file]
    }
}

reload

