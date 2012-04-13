#-------------------------------------------------------------------------------
MACRO (HDFJAVA_SET_LIB_OPTIONS libtarget libname libtype)
  HDF_SET_LIB_OPTIONS (${libtarget} ${libname} ${libtype})
  #message (STATUS "Target: ${libtarget} is ${libname} libtype: ${libtype}")
  IF (${libtype} MATCHES "SHARED")
    IF (WIN32)
      SET (LIBHDF_VERSION ${HDFJAVA_PACKAGE_VERSION_MAJOR})
    ELSE (WIN32)
      SET (LIBHDF_VERSION ${HDFJAVA_PACKAGE_VERSION})
    ENDIF (WIN32)
    #message (STATUS "Version: ${LIBHDF_VERSION}")
    SET_TARGET_PROPERTIES (${libtarget} PROPERTIES VERSION ${LIBHDF_VERSION})
    SET_TARGET_PROPERTIES (${libtarget} PROPERTIES SOVERSION ${LIBHDF_VERSION})
  ENDIF (${libtype} MATCHES "SHARED")

  #-- Apple Specific install_name for libraries
  IF (APPLE)
    OPTION (HDF_BUILD_WITH_INSTALL_NAME "Build with library install_name set to the installation path" OFF)
    IF (HDF_BUILD_WITH_INSTALL_NAME)
      SET_TARGET_PROPERTIES (${libtarget} PROPERTIES
          LINK_FLAGS "-current_version ${HDFJAVA_PACKAGE_VERSION} -compatibility_version ${HDFJAVA_PACKAGE_VERSION}"
          INSTALL_NAME_DIR "${CMAKE_INSTALL_PREFIX}/lib"
          BUILD_WITH_INSTALL_RPATH ${HDF_BUILD_WITH_INSTALL_NAME}
      )
    ENDIF (HDF_BUILD_WITH_INSTALL_NAME)
  ENDIF (APPLE)

ENDMACRO (HDFJAVA_SET_LIB_OPTIONS)

#-------------------------------------------------------------------------------
MACRO (PACKAGE_JPEG_LIBRARY libtype)
  IF (WIN32 AND NOT CYGWIN)
    IF (${libtype} MATCHES "SHARED")
      IF (BUILD_TESTING)
        GET_PROPERTY (JPEG_DLL TARGET ${JPEG_LIBRARY} PROPERTY LOCATION_${BLDTYPE})
        GET_FILENAME_COMPONENT(JPEG_DLL_NAME ${JPEG_DLL} NAME)
        ADD_CUSTOM_TARGET (JPEG_DLL_NAME-Test-Copy ALL
            COMMAND ${CMAKE_COMMAND} -E copy_if_different ${JPEG_DLL} ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${JPEG_DLL_NAME}
            COMMENT "Copying ${JPEG_DLL} to ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/"
        )
        ADD_DEPENDENCIES (JPEG_DLL_NAME-Test-Copy HDF4)
      ENDIF (BUILD_TESTING)
    ENDIF (${libtype} MATCHES "SHARED")
  ENDIF (WIN32 AND NOT CYGWIN)
ENDMACRO (PACKAGE_JPEG_LIBRARY)

#-------------------------------------------------------------------------------
MACRO (PACKAGE_SZIP_LIBRARY libtype)
  IF (WIN32 AND NOT CYGWIN)
    IF (${libtype} MATCHES "SHARED")
      IF (BUILD_TESTING)
        GET_PROPERTY (SZIP_DLL TARGET ${SZIP_LIBRARY} PROPERTY LOCATION_${BLDTYPE})
        GET_FILENAME_COMPONENT(SZIP_DLL_NAME ${SZIP_DLL} NAME)
        ADD_CUSTOM_TARGET (SZIP_DLL_NAME-Test-Copy ALL
            COMMAND ${CMAKE_COMMAND} -E copy_if_different ${SZIP_DLL} ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${SZIP_DLL_NAME}
            COMMENT "Copying ${SZIP_DLL} to ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/"
        )
        ADD_DEPENDENCIES (SZIP_DLL_NAME-Test-Copy HDF5)
      ENDIF (BUILD_TESTING)
    ENDIF (${libtype} MATCHES "SHARED")
  ENDIF (WIN32 AND NOT CYGWIN)
ENDMACRO (PACKAGE_SZIP_LIBRARY)

#-------------------------------------------------------------------------------
MACRO (PACKAGE_ZLIB_LIBRARY libtype)
  IF (WIN32 AND NOT CYGWIN)
    IF (${libtype} MATCHES "SHARED")
      IF (BUILD_TESTING)
        GET_PROPERTY (ZLIB_DLL TARGET ${ZLIB_LIBRARY} PROPERTY LOCATION_${BLDTYPE})
        GET_FILENAME_COMPONENT(ZLIB_DLL_NAME ${ZLIB_DLL} NAME)
        ADD_CUSTOM_TARGET (ZLIB_DLL_NAME-Test-Copy ALL
            COMMAND ${CMAKE_COMMAND} -E copy_if_different ${ZLIB_DLL} ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${ZLIB_DLL_NAME}
            COMMENT "Copying ${ZLIB_DLL} to ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/"
        )
        ADD_DEPENDENCIES (ZLIB_DLL_NAME-Test-Copy HDF5)
      ENDIF (BUILD_TESTING)
    ENDIF (${libtype} MATCHES "SHARED")
  ENDIF (WIN32 AND NOT CYGWIN)
ENDMACRO (PACKAGE_ZLIB_LIBRARY)
