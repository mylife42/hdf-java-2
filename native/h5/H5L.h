/* DO NOT EDIT THIS FILE - it is machine generated */
#include <jni.h>
/* Header for class hdf_h5_H5L */

#ifndef _Included_hdf_h5_H5L
#define _Included_hdf_h5_H5L
#ifdef __cplusplus
extern "C" {
#endif
/*
 * Class:     hdf_h5_H5L
 * Method:    H5Lmove
 * Signature: (ILjava/lang/String;ILjava/lang/String;II)V
 */
JNIEXPORT void JNICALL Java_hdf_h5_H5L_H5Lmove
  (JNIEnv *, jclass, jint, jstring, jint, jstring, jint, jint);

/*
 * Class:     hdf_h5_H5L
 * Method:    H5Lcopy
 * Signature: (ILjava/lang/String;ILjava/lang/String;II)V
 */
JNIEXPORT void JNICALL Java_hdf_h5_H5L_H5Lcopy
  (JNIEnv *, jclass, jint, jstring, jint, jstring, jint, jint);

/*
 * Class:     hdf_h5_H5L
 * Method:    H5Lcreate_hard
 * Signature: (ILjava/lang/String;ILjava/lang/String;II)V
 */
JNIEXPORT void JNICALL Java_hdf_h5_H5L_H5Lcreate_1hard
  (JNIEnv *, jclass, jint, jstring, jint, jstring, jint, jint);

/*
 * Class:     hdf_h5_H5L
 * Method:    H5Lcreate_soft
 * Signature: (Ljava/lang/String;ILjava/lang/String;II)V
 */
JNIEXPORT void JNICALL Java_hdf_h5_H5L_H5Lcreate_1soft
  (JNIEnv *, jclass, jstring, jint, jstring, jint, jint);

/*
 * Class:     hdf_h5_H5L
 * Method:    H5Ldelete
 * Signature: (ILjava/lang/String;I)V
 */
JNIEXPORT void JNICALL Java_hdf_h5_H5L_H5Ldelete
  (JNIEnv *, jclass, jint, jstring, jint);

/*
 * Class:     hdf_h5_H5L
 * Method:    H5Ldelete_by_idx
 * Signature: (ILjava/lang/String;Lhdf/h5/enums/H5_INDEX;Lhdf/h5/enums/H5_ITER;JI)V
 */
JNIEXPORT void JNICALL Java_hdf_h5_H5L_H5Ldelete_1by_1idx
  (JNIEnv *, jclass, jint, jstring, jobject, jobject, jlong, jint);

/*
 * Class:     hdf_h5_H5L
 * Method:    H5Lget_val
 * Signature: (ILjava/lang/String;JI)[B
 */
JNIEXPORT jbyteArray JNICALL Java_hdf_h5_H5L_H5Lget_1val
  (JNIEnv *, jclass, jint, jstring, jlong, jint);

/*
 * Class:     hdf_h5_H5L
 * Method:    H5Lget_val_by_idx
 * Signature: (ILjava/lang/String;Lhdf/h5/enums/H5_INDEX;Lhdf/h5/enums/H5_ITER;JJI)[B
 */
JNIEXPORT jbyteArray JNICALL Java_hdf_h5_H5L_H5Lget_1val_1by_1idx
  (JNIEnv *, jclass, jint, jstring, jobject, jobject, jlong, jlong, jint);

/*
 * Class:     hdf_h5_H5L
 * Method:    H5Lexists
 * Signature: (ILjava/lang/String;I)Z
 */
JNIEXPORT jboolean JNICALL Java_hdf_h5_H5L_H5Lexists
  (JNIEnv *, jclass, jint, jstring, jint);

/*
 * Class:     hdf_h5_H5L
 * Method:    H5Lget_info
 * Signature: (ILjava/lang/String;I)[B
 */
JNIEXPORT jbyteArray JNICALL Java_hdf_h5_H5L_H5Lget_1info
  (JNIEnv *, jclass, jint, jstring, jint);

/*
 * Class:     hdf_h5_H5L
 * Method:    H5Lget_info_by_idx
 * Signature: (ILjava/lang/String;Lhdf/h5/enums/H5_INDEX;Lhdf/h5/enums/H5_ITER;JI)[B
 */
JNIEXPORT jbyteArray JNICALL Java_hdf_h5_H5L_H5Lget_1info_1by_1idx
  (JNIEnv *, jclass, jint, jstring, jobject, jobject, jlong, jint);

/*
 * Class:     hdf_h5_H5L
 * Method:    H5Lget_name_by_idx
 * Signature: (ILjava/lang/String;Lhdf/h5/enums/H5_INDEX;Lhdf/h5/enums/H5_ITER;JI)Ljava/lang/String;
 */
JNIEXPORT jstring JNICALL Java_hdf_h5_H5L_H5Lget_1name_1by_1idx
  (JNIEnv *, jclass, jint, jstring, jobject, jobject, jlong, jint);

/*
 * Class:     hdf_h5_H5L
 * Method:    H5Lcreate_ud
 * Signature: (ILjava/lang/String;Lhdf/h5/enums/H5L_TYPE;[BJII)V
 */
JNIEXPORT void JNICALL Java_hdf_h5_H5L_H5Lcreate_1ud
  (JNIEnv *, jclass, jint, jstring, jobject, jbyteArray, jlong, jint, jint);

/*
 * Class:     hdf_h5_H5L
 * Method:    H5Lunregister
 * Signature: (Lhdf/h5/enums/H5L_TYPE;)V
 */
JNIEXPORT void JNICALL Java_hdf_h5_H5L_H5Lunregister
  (JNIEnv *, jclass, jobject);

/*
 * Class:     hdf_h5_H5L
 * Method:    H5Lis_registered
 * Signature: (Lhdf/h5/enums/H5L_TYPE;)Z
 */
JNIEXPORT jboolean JNICALL Java_hdf_h5_H5L_H5Lis_1registered
  (JNIEnv *, jclass, jobject);

/*
 * Class:     hdf_h5_H5L
 * Method:    H5Lunpack_elink_val
 * Signature: ([BJ[Ljava/lang/String;)I
 */
JNIEXPORT jint JNICALL Java_hdf_h5_H5L_H5Lunpack_1elink_1val
  (JNIEnv *, jclass, jbyteArray, jlong, jobjectArray);

/*
 * Class:     hdf_h5_H5L
 * Method:    H5Lcreate_external
 * Signature: (Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;II)I
 */
JNIEXPORT jint JNICALL Java_hdf_h5_H5L_H5Lcreate_1external
  (JNIEnv *, jclass, jstring, jstring, jint, jstring, jint, jint);

#ifdef __cplusplus
}
#endif
#endif
