# javaLock.tcl --
#
# Maintain an internal pointer to java objects to control 
# when the object is garbage collected.
#
# When a variable references a Java object, the internal rep
# points to a ReflectObject that contains the object.  If an
# operation is performed on the variable that alters the 
# internal rep (e.g. llength $x), the ReflectObject is 
# destroied and the Java object is garbage collected.  By 
# maintaining an internal pointer to the object, the
# java::lock and java::unlock commands can prevent the unwanted
# garbage collection of the Java object. 
#
# Copyright (c) 1998 by Sun Microsystems, Inc.
#
# RCS: @(#) $Id: javalock.tcl,v 1.3 1999/08/27 23:50:50 mo Exp $
#
# See the file "license.terms" for information on usage and redistribution
# of this file, and for a DISCLAIMER OF ALL WARRANTIES.


# java::lock --
#
# 	Make a copy of the TclObject and store it in 
#	java::objLockedList. This will increment the
#	ref-count of the ReflectObject, preventing 
#	garbage collection.
#
# Arguments:
#	javaObj : The java object to be locked.
#
# Results:
# 	If the javaObj does not reference a valid java object
#	an error is generated by the call to java::isnull.


proc java::lock { javaObj } {
    global java::objLockedList

    # Make a copy of the object.

    set copy [format %s $javaObj]
    llength $copy
    
    # Store the object internally.

    if {! [java::isnull $copy]} {
        lappend java::objLockedList $copy
    }
    return $copy
}

# java::unlock --
#
#  	Remove the reference to the Java object from the
#	java::objLockedList.  This will decrement the 
#	ref-count by one.  It ref-count equals zero the 
#	Java object will be garbage collected.
#
# Arguments:
#	javaObj : The Java object to be unlocked. The object
#		should have been locked by a call to java::lock.
#		The special string "all" is also accepted.
#
# Results:
# 	An error is generated if the java::objLockedList
# 	does not contain a java object or is not "all".

proc java::unlock { javaObj } {
    global java::objLockedList

    # check to see if the special "all" argument was given
    if {$javaObj == "all"} {
	catch {unset java::objLockedList}
        return
    }

    # A null reference would no be in the locked list
    if {[java::isnull $javaObj]} {
        return
    }

    # Remove the copy of the reference.

    set index [lsearch $java::objLockedList $javaObj]
    if {$index < 0} {
	error "unknown java object \"$javaObj\""
    } else {
	set java::objLockedList [lreplace $java::objLockedList $index $index]
    }
    return
}

# java::autolock --
#
#  	The autolock comand is used to activate or deactivate
#	the automatic object locking feature. It can be called
#	with no arguments which will turn on the feature.
#	By default this feature is not activated.
#
# Arguments:
#	activate : a boolean condition to control if automatic
#		locked will be used. Autolocking can be turned
#		of by calling this command with the argument 0.
#
# Results:
# 	If autolocking is turned off all objects that have been
# 	locked will be released and objects will no longer be locked.

proc java::autolock { {activate 1} } {

  if {$activate} {
    if {[::info commands ::java::autolock_new] != ""} {
      error "autolocking has already been activated"
    }

    foreach cmd {new call field getinterp cast defineclass prop} {
      rename ::java::$cmd ::java::autolock_$cmd

      proc ::java::$cmd { args } "
        java::autolock_create_instance \[eval java::autolock_$cmd \$args\]
      "
    }

  } else {
    if {[::info commands ::java::autolock_new] == ""} {
      error "autolocking has not been activated"
    }

    # restore names of the java commands
    foreach cmd {new call field getinterp cast defineclass prop} {
        rename ::java::$cmd {}
        rename ::java::autolock_$cmd ::java::$cmd
    }

    # unlock each instance that we autolocked earlier
    foreach cmd [::info commands ::java::autolock_java*] {
      set javaObj [lindex [split $cmd _] 1]
      #puts "javaObj instance to destroy is \"$javaObj\""
      java::autolock_destroy_instance $javaObj
    }
  }
}


# This is a private helper that is only used by java::autolock

proc java::autolock_create_instance { javaObj } {
  #puts "called java::autolock_create_instance $javaObj"

  # See if this is really a reflected java object

  if {[catch {java::isnull $javaObj} err]} {
    # If it is not a java object just return the value
    #puts "not a java object returning $javaObj"
    return $javaObj
  } else {
    # if isnull returned true then return the null value
    if {$err == 1} {
      #puts "null java oject, returning $javaObj"
      return $javaObj
    }
  }

  # do nothing is object is already autolocked
  set cmd ::java::autolock_$javaObj

  if {[::info commands $cmd] == $cmd} {
    #puts "autolock instance command already exists, returning $javaObj"
    return $javaObj
  }

  # lock the object reference
  java::lock $javaObj

  # rename the java instance command to the locked command
  rename ::$javaObj $cmd

  # create the locked instance command
  proc ::$javaObj { args } "
    java::autolock_create_instance \[eval $cmd \$args\]
  "

  #puts "autolock instance command created, returning $javaObj"
  return $javaObj
}


# This is a private helper that is only used by java::autolock

proc java::autolock_destroy_instance { javaObj } {

  set cmd ::java::autolock_$javaObj

  if {[::info commands $cmd] != $cmd} {
    error "can not find autolock instance command for $javaObj"
  }

  rename ::$javaObj {}
  rename $cmd ::$javaObj

  # unlock the object reference
  java::unlock $javaObj
}