/* DO NOT EDIT THIS FILE - it is machine generated */
#include <jni.h>
/* Header for class tcl_lang_CObject */

#ifndef _Included_tcl_lang_CObject
#define _Included_tcl_lang_CObject
#ifdef __cplusplus
extern "C" {
#endif
/*
 * Class:     tcl_lang_CObject
 * Method:    decrRefCount
 * Signature: (J)V
 */
JNIEXPORT void JNICALL Java_tcl_lang_CObject_decrRefCount
  (JNIEnv *, jclass, jlong);

/*
 * Class:     tcl_lang_CObject
 * Method:    incrRefCount
 * Signature: (J)V
 */
JNIEXPORT void JNICALL Java_tcl_lang_CObject_incrRefCount
  (JNIEnv *, jclass, jlong);

/*
 * Class:     tcl_lang_CObject
 * Method:    newCObject
 * Signature: (Ljava/lang/String;)J
 */
JNIEXPORT jlong JNICALL Java_tcl_lang_CObject_newCObject
  (JNIEnv *, jclass, jstring);

/*
 * Class:     tcl_lang_CObject
 * Method:    getString
 * Signature: (J)Ljava/lang/String;
 */
JNIEXPORT jstring JNICALL Java_tcl_lang_CObject_getString
  (JNIEnv *, jclass, jlong);

/*
 * Class:     tcl_lang_CObject
 * Method:    makeRef
 * Signature: (JLtcl/lang/TclObject;)V
 */
JNIEXPORT void JNICALL Java_tcl_lang_CObject_makeRef
  (JNIEnv *, jclass, jlong, jobject);

#ifdef __cplusplus
}
#endif
#endif
/* Header for class tcl_lang_IdleHandler */

#ifndef _Included_tcl_lang_IdleHandler
#define _Included_tcl_lang_IdleHandler
#ifdef __cplusplus
extern "C" {
#endif
/*
 * Class:     tcl_lang_IdleHandler
 * Method:    doWhenIdle
 * Signature: ()J
 */
JNIEXPORT jlong JNICALL Java_tcl_lang_IdleHandler_doWhenIdle
  (JNIEnv *, jobject);

/*
 * Class:     tcl_lang_IdleHandler
 * Method:    cancelIdleCall
 * Signature: (J)V
 */
JNIEXPORT void JNICALL Java_tcl_lang_IdleHandler_cancelIdleCall
  (JNIEnv *, jobject, jlong);

#ifdef __cplusplus
}
#endif
#endif
/* Header for class tcl_lang_Interp */

#ifndef _Included_tcl_lang_Interp
#define _Included_tcl_lang_Interp
#ifdef __cplusplus
extern "C" {
#endif
/*
 * Class:     tcl_lang_Interp
 * Method:    initName
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_tcl_lang_Interp_initName
  (JNIEnv *, jclass);

/*
 * Class:     tcl_lang_Interp
 * Method:    create
 * Signature: ()J
 */
JNIEXPORT jlong JNICALL Java_tcl_lang_Interp_create
  (JNIEnv *, jobject);

/*
 * Class:     tcl_lang_Interp
 * Method:    setVar
 * Signature: (Ljava/lang/String;Ljava/lang/String;Ltcl/lang/TclObject;I)Ltcl/lang/TclObject;
 */
JNIEXPORT jobject JNICALL Java_tcl_lang_Interp_setVar
  (JNIEnv *, jobject, jstring, jstring, jobject, jint);

/*
 * Class:     tcl_lang_Interp
 * Method:    getVar
 * Signature: (Ljava/lang/String;Ljava/lang/String;I)Ltcl/lang/TclObject;
 */
JNIEXPORT jobject JNICALL Java_tcl_lang_Interp_getVar
  (JNIEnv *, jobject, jstring, jstring, jint);

/*
 * Class:     tcl_lang_Interp
 * Method:    unsetVar
 * Signature: (Ljava/lang/String;Ljava/lang/String;I)V
 */
JNIEXPORT void JNICALL Java_tcl_lang_Interp_unsetVar
  (JNIEnv *, jobject, jstring, jstring, jint);

/*
 * Class:     tcl_lang_Interp
 * Method:    traceVar
 * Signature: (Ljava/lang/String;Ljava/lang/String;Ltcl/lang/VarTrace;I)V
 */
JNIEXPORT void JNICALL Java_tcl_lang_Interp_traceVar
  (JNIEnv *, jobject, jstring, jstring, jobject, jint);

/*
 * Class:     tcl_lang_Interp
 * Method:    untraceVar
 * Signature: (Ljava/lang/String;Ljava/lang/String;Ltcl/lang/VarTrace;I)V
 */
JNIEXPORT void JNICALL Java_tcl_lang_Interp_untraceVar
  (JNIEnv *, jobject, jstring, jstring, jobject, jint);

/*
 * Class:     tcl_lang_Interp
 * Method:    createCommand
 * Signature: (Ljava/lang/String;Ltcl/lang/Command;)V
 */
JNIEXPORT void JNICALL Java_tcl_lang_Interp_createCommand
  (JNIEnv *, jobject, jstring, jobject);

/*
 * Class:     tcl_lang_Interp
 * Method:    deleteCommand
 * Signature: (Ljava/lang/String;)I
 */
JNIEXPORT jint JNICALL Java_tcl_lang_Interp_deleteCommand
  (JNIEnv *, jobject, jstring);

/*
 * Class:     tcl_lang_Interp
 * Method:    getCommand
 * Signature: (Ljava/lang/String;)Ltcl/lang/Command;
 */
JNIEXPORT jobject JNICALL Java_tcl_lang_Interp_getCommand
  (JNIEnv *, jobject, jstring);

/*
 * Class:     tcl_lang_Interp
 * Method:    commandComplete
 * Signature: (Ljava/lang/String;)Z
 */
JNIEXPORT jboolean JNICALL Java_tcl_lang_Interp_commandComplete
  (JNIEnv *, jclass, jstring);

/*
 * Class:     tcl_lang_Interp
 * Method:    getResult
 * Signature: ()Ltcl/lang/TclObject;
 */
JNIEXPORT jobject JNICALL Java_tcl_lang_Interp_getResult
  (JNIEnv *, jobject);

/*
 * Class:     tcl_lang_Interp
 * Method:    setResult
 * Signature: (Ltcl/lang/TclObject;)V
 */
JNIEXPORT void JNICALL Java_tcl_lang_Interp_setResult__Ltcl_lang_TclObject_2
  (JNIEnv *, jobject, jobject);

/*
 * Class:     tcl_lang_Interp
 * Method:    setResult
 * Signature: (I)V
 */
JNIEXPORT void JNICALL Java_tcl_lang_Interp_setResult__I
  (JNIEnv *, jobject, jint);

/*
 * Class:     tcl_lang_Interp
 * Method:    setResult
 * Signature: (Z)V
 */
JNIEXPORT void JNICALL Java_tcl_lang_Interp_setResult__Z
  (JNIEnv *, jobject, jboolean);

/*
 * Class:     tcl_lang_Interp
 * Method:    resetResult
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_tcl_lang_Interp_resetResult
  (JNIEnv *, jobject);

/*
 * Class:     tcl_lang_Interp
 * Method:    evalString
 * Signature: (Ljava/lang/String;I)I
 */
JNIEXPORT jint JNICALL Java_tcl_lang_Interp_evalString
  (JNIEnv *, jobject, jstring, jint);

/*
 * Class:     tcl_lang_Interp
 * Method:    evalTclObject
 * Signature: (JLjava/lang/String;I)I
 */
JNIEXPORT jint JNICALL Java_tcl_lang_Interp_evalTclObject
  (JNIEnv *, jobject, jlong, jstring, jint);

/*
 * Class:     tcl_lang_Interp
 * Method:    setErrorCode
 * Signature: (Ltcl/lang/TclObject;)V
 */
JNIEXPORT void JNICALL Java_tcl_lang_Interp_setErrorCode
  (JNIEnv *, jobject, jobject);

/*
 * Class:     tcl_lang_Interp
 * Method:    addErrorInfo
 * Signature: (Ljava/lang/String;)V
 */
JNIEXPORT void JNICALL Java_tcl_lang_Interp_addErrorInfo
  (JNIEnv *, jobject, jstring);

/*
 * Class:     tcl_lang_Interp
 * Method:    backgroundError
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_tcl_lang_Interp_backgroundError
  (JNIEnv *, jobject);

/*
 * Class:     tcl_lang_Interp
 * Method:    init
 * Signature: (J)I
 */
JNIEXPORT jint JNICALL Java_tcl_lang_Interp_init
  (JNIEnv *, jobject, jlong);

/*
 * Class:     tcl_lang_Interp
 * Method:    doDispose
 * Signature: (J)V
 */
JNIEXPORT void JNICALL Java_tcl_lang_Interp_doDispose
  (JNIEnv *, jclass, jlong);

/*
 * Class:     tcl_lang_Interp
 * Method:    pkgProvide
 * Signature: (Ljava/lang/String;Ljava/lang/String;)V
 */
JNIEXPORT void JNICALL Java_tcl_lang_Interp_pkgProvide
  (JNIEnv *, jobject, jstring, jstring);

/*
 * Class:     tcl_lang_Interp
 * Method:    pkgRequire
 * Signature: (Ljava/lang/String;Ljava/lang/String;Z)Ljava/lang/String;
 */
JNIEXPORT jstring JNICALL Java_tcl_lang_Interp_pkgRequire
  (JNIEnv *, jobject, jstring, jstring, jboolean);

/*
 * Class:     tcl_lang_Interp
 * Method:    createBTestCommand
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_tcl_lang_Interp_createBTestCommand
  (JNIEnv *, jobject);

#ifdef __cplusplus
}
#endif
#endif
/* Header for class tcl_lang_Notifier */

#ifndef _Included_tcl_lang_Notifier
#define _Included_tcl_lang_Notifier
#ifdef __cplusplus
extern "C" {
#endif
/*
 * Class:     tcl_lang_Notifier
 * Method:    doOneEvent
 * Signature: (I)I
 */
JNIEXPORT jint JNICALL Java_tcl_lang_Notifier_doOneEvent
  (JNIEnv *, jobject, jint);

/*
 * Class:     tcl_lang_Notifier
 * Method:    alertNotifier
 * Signature: (J)V
 */
JNIEXPORT void JNICALL Java_tcl_lang_Notifier_alertNotifier
  (JNIEnv *, jobject, jlong);

/*
 * Class:     tcl_lang_Notifier
 * Method:    init
 * Signature: ()J
 */
JNIEXPORT jlong JNICALL Java_tcl_lang_Notifier_init
  (JNIEnv *, jobject);

/*
 * Class:     tcl_lang_Notifier
 * Method:    dispose
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_tcl_lang_Notifier_dispose
  (JNIEnv *, jobject);

/*
 * Class:     tcl_lang_Notifier
 * Method:    finalizeThreadCheck
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_tcl_lang_Notifier_finalizeThreadCheck
  (JNIEnv *, jclass);

#ifdef __cplusplus
}
#endif
#endif
/* Header for class tcl_lang_TclList */

#ifndef _Included_tcl_lang_TclList
#define _Included_tcl_lang_TclList
#ifdef __cplusplus
extern "C" {
#endif
/*
 * Class:     tcl_lang_TclList
 * Method:    append
 * Signature: (JLtcl/lang/TclObject;)J
 */
JNIEXPORT jlong JNICALL Java_tcl_lang_TclList_append
  (JNIEnv *, jclass, jlong, jobject);

/*
 * Class:     tcl_lang_TclList
 * Method:    getElements
 * Signature: (J)[Ltcl/lang/TclObject;
 */
JNIEXPORT jobjectArray JNICALL Java_tcl_lang_TclList_getElements
  (JNIEnv *, jclass, jlong);

/*
 * Class:     tcl_lang_TclList
 * Method:    index
 * Signature: (JI)Ltcl/lang/TclObject;
 */
JNIEXPORT jobject JNICALL Java_tcl_lang_TclList_index
  (JNIEnv *, jclass, jlong, jint);

/*
 * Class:     tcl_lang_TclList
 * Method:    listLength
 * Signature: (JJ)I
 */
JNIEXPORT jint JNICALL Java_tcl_lang_TclList_listLength
  (JNIEnv *, jclass, jlong, jlong);

/*
 * Class:     tcl_lang_TclList
 * Method:    replace
 * Signature: (JII[Ltcl/lang/TclObject;II)J
 */
JNIEXPORT jlong JNICALL Java_tcl_lang_TclList_replace
  (JNIEnv *, jclass, jlong, jint, jint, jobjectArray, jint, jint);

/*
 * Class:     tcl_lang_TclList
 * Method:    splitList
 * Signature: (JLjava/lang/String;)J
 */
JNIEXPORT jlong JNICALL Java_tcl_lang_TclList_splitList
  (JNIEnv *, jclass, jlong, jstring);

#ifdef __cplusplus
}
#endif
#endif
/* Header for class tcl_lang_TimerHandler */

#ifndef _Included_tcl_lang_TimerHandler
#define _Included_tcl_lang_TimerHandler
#ifdef __cplusplus
extern "C" {
#endif
/*
 * Class:     tcl_lang_TimerHandler
 * Method:    createTimerHandler
 * Signature: (I)J
 */
JNIEXPORT jlong JNICALL Java_tcl_lang_TimerHandler_createTimerHandler
  (JNIEnv *, jobject, jint);

/*
 * Class:     tcl_lang_TimerHandler
 * Method:    deleteTimerHandler
 * Signature: (J)V
 */
JNIEXPORT void JNICALL Java_tcl_lang_TimerHandler_deleteTimerHandler
  (JNIEnv *, jobject, jlong);

#ifdef __cplusplus
}
#endif
#endif
/* Header for class tcl_lang_Util */

#ifndef _Included_tcl_lang_Util
#define _Included_tcl_lang_Util
#ifdef __cplusplus
extern "C" {
#endif
/*
 * Class:     tcl_lang_Util
 * Method:    getBoolean
 * Signature: (Ltcl/lang/Interp;Ljava/lang/String;)Z
 */
JNIEXPORT jboolean JNICALL Java_tcl_lang_Util_getBoolean
  (JNIEnv *, jclass, jobject, jstring);

/*
 * Class:     tcl_lang_Util
 * Method:    getInt
 * Signature: (Ltcl/lang/Interp;Ljava/lang/String;)I
 */
JNIEXPORT jint JNICALL Java_tcl_lang_Util_getInt
  (JNIEnv *, jclass, jobject, jstring);

/*
 * Class:     tcl_lang_Util
 * Method:    getDoubleNative
 * Signature: (Ltcl/lang/Interp;Ljava/lang/String;)D
 */
JNIEXPORT jdouble JNICALL Java_tcl_lang_Util_getDoubleNative
  (JNIEnv *, jclass, jobject, jstring);

/*
 * Class:     tcl_lang_Util
 * Method:    printDouble
 * Signature: (D)Ljava/lang/String;
 */
JNIEXPORT jstring JNICALL Java_tcl_lang_Util_printDouble
  (JNIEnv *, jclass, jdouble);

/*
 * Class:     tcl_lang_Util
 * Method:    getCwd
 * Signature: ()Ljava/lang/String;
 */
JNIEXPORT jstring JNICALL Java_tcl_lang_Util_getCwd
  (JNIEnv *, jclass);

/*
 * Class:     tcl_lang_Util
 * Method:    stringMatch
 * Signature: (Ljava/lang/String;Ljava/lang/String;)Z
 */
JNIEXPORT jboolean JNICALL Java_tcl_lang_Util_stringMatch
  (JNIEnv *, jclass, jstring, jstring);

#ifdef __cplusplus
}
#endif
#endif
