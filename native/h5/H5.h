/* DO NOT EDIT THIS FILE - it is machine generated */
#include <jni.h>
/* Header for class hdf_h5_H5 */

#ifndef _Included_hdf_h5_H5
#define _Included_hdf_h5_H5
#ifdef __cplusplus
extern "C" {
#endif
/*
 * Class:     hdf_h5_H5
 * Method:    J2C
 * Signature: (I)I
 */
JNIEXPORT jint JNICALL Java_hdf_h5_H5_J2C
  (JNIEnv *, jclass, jint);

/*
 * Class:     hdf_h5_H5
 * Method:    H5error_off
 * Signature: ()I
 */
JNIEXPORT jint JNICALL Java_hdf_h5_H5_H5error_1off
  (JNIEnv *, jclass);

/*
 * Class:     hdf_h5_H5
 * Method:    H5open
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_hdf_h5_H5_H5open
  (JNIEnv *, jclass);

/*
 * Class:     hdf_h5_H5
 * Method:    H5close
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_hdf_h5_H5_H5close
  (JNIEnv *, jclass);

/*
 * Class:     hdf_h5_H5
 * Method:    H5dont_atexit
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_hdf_h5_H5_H5dont_1atexit
  (JNIEnv *, jclass);

/*
 * Class:     hdf_h5_H5
 * Method:    H5garbage_collect
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_hdf_h5_H5_H5garbage_1collect
  (JNIEnv *, jclass);

/*
 * Class:     hdf_h5_H5
 * Method:    H5set_free_list_limits
 * Signature: (IIIIII)V
 */
JNIEXPORT void JNICALL Java_hdf_h5_H5_H5set_1free_1list_1limits
  (JNIEnv *, jclass, jint, jint, jint, jint, jint, jint);

/*
 * Class:     hdf_h5_H5
 * Method:    H5get_libversion
 * Signature: ([I)V
 */
JNIEXPORT void JNICALL Java_hdf_h5_H5_H5get_1libversion
  (JNIEnv *, jclass, jintArray);

/*
 * Class:     hdf_h5_H5
 * Method:    H5check_version
 * Signature: (III)V
 */
JNIEXPORT void JNICALL Java_hdf_h5_H5_H5check_1version
  (JNIEnv *, jclass, jint, jint, jint);

/*
 * Class:     hdf_h5_H5
 * Method:    H5Eclear
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_hdf_h5_H5_H5Eclear
  (JNIEnv *, jclass);

#ifdef __cplusplus
}
#endif
#endif
