/* DO NOT EDIT THIS FILE - it is machine generated */
#include <jni.h>
/* Header for class ncsa_hdf_hdf5lib_H5_H5I */

#ifndef _Included_ncsa_hdf_hdf5lib_H5_H5I
#define _Included_ncsa_hdf_hdf5lib_H5_H5I
#ifdef __cplusplus
extern "C" {
#endif

/*
 * Class:     ncsa_hdf_hdf5lib_H5
 * Method:    H5Iget_type
 * Signature: (J)I
 */
JNIEXPORT jint JNICALL Java_ncsa_hdf_hdf5lib_H5_H5Iget_1type
  (JNIEnv*, jclass, jlong);

/*
 * Class:     ncsa_hdf_hdf5lib_H5
 * Method:    H5Iget_name
 * Signature: (JLjava/lang/String;J)J
 */
JNIEXPORT jlong JNICALL Java_ncsa_hdf_hdf5lib_H5_H5Iget_1name
  (JNIEnv*, jclass, jlong, jobjectArray, jlong);

/*
 * Class:     ncsa_hdf_hdf5lib_H5
 * Method:    H5Iget_ref
 * Signature: (J)I
 */
JNIEXPORT jint JNICALL Java_ncsa_hdf_hdf5lib_H5_H5Iget_1ref
  (JNIEnv*, jclass, jlong);

/*
 * Class:     ncsa_hdf_hdf5lib_H5
 * Method:    H5Iinc_ref
 * Signature: (J)I
 */
JNIEXPORT jint JNICALL Java_ncsa_hdf_hdf5lib_H5_H5Iinc_1ref
  (JNIEnv*, jclass, jlong);

/*
 * Class:     ncsa_hdf_hdf5lib_H5
 * Method:    H5Idec_1ref
 * Signature: (J)I
 */
JNIEXPORT jint JNICALL Java_ncsa_hdf_hdf5lib_H5_H5Idec_1ref
  (JNIEnv*, jclass, jlong);

/*
 * Class:     ncsa_hdf_hdf5lib_H5
 * Method:    H5Iget_file_id
 * Signature: (J)J
 */

JNIEXPORT jlong JNICALL Java_ncsa_hdf_hdf5lib_H5_H5Iget_1file_1id
  (JNIEnv*, jclass, jlong);

/*
 * Class:     ncsa_hdf_hdf5lib_H5
 * Method:    H5Iget_type_ref
 * Signature: (I)I
 */
JNIEXPORT jint JNICALL Java_ncsa_hdf_hdf5lib_H5_H5Iget_1type_1ref
  (JNIEnv*, jclass, jint);

/*
 * Class:     ncsa_hdf_hdf5lib_H5
 * Method:    H5Inmembers
 * Signature: (I)I
 */
JNIEXPORT jint JNICALL Java_ncsa_hdf_hdf5lib_H5_H5Inmembers
  (JNIEnv*, jclass, jint);

/*
 * Class:     ncsa_hdf_hdf5lib_H5
 * Method:    H5Iis_valid
 * Signature: (J)Z
 */
JNIEXPORT jboolean JNICALL Java_ncsa_hdf_hdf5lib_H5_H5Iis_1valid
  (JNIEnv*, jclass, jlong);

/*
 * Class:     ncsa_hdf_hdf5lib_H5
 * Method:    H5Itype_exists
 * Signature: (I)Z
 */
JNIEXPORT jboolean JNICALL Java_ncsa_hdf_hdf5lib_H5_H5Itype_1xists
  (JNIEnv*, jclass, jint);

#ifdef __cplusplus
}
#endif
#endif
