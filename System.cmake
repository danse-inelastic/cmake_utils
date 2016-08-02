# lib64
get_property(LIB64 GLOBAL PROPERTY FIND_LIBRARY_USE_LIB64_PATHS)
if ("${LIB64}" STREQUAL "TRUE")
    set(LIBSUFFIX 64)
else()
    set(LIBSUFFIX "")
endif()
# under conda build, always use "lib".
if ("${CONDA_BUILD}" STREQUAL "TRUE")
    set(LIBSUFFIX "")
endif()
set(INSTALL_LIB_DIR
  lib${LIBSUFFIX} CACHE PATH "Installation directory for libraries")
# message( STATUS "Install lib dir: ${INSTALL_LIB_DIR}")
mark_as_advanced(INSTALL_LIB_DIR)
