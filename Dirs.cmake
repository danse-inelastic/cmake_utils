# export root at build
set(EXPORT_ROOT ${CMAKE_BINARY_DIR}/export)
set(EXPORT_HEADERS ${EXPORT_ROOT}/include)
set(EXPORT_LIB ${EXPORT_ROOT}/lib)
set(EXPORT_PYTHON ${EXPORT_ROOT}/python)
set(EXPORT_BIN ${EXPORT_ROOT}/bin)
set(EXPORT_ETC ${EXPORT_ROOT}/etc)
set(EXPORT_SHARE ${EXPORT_ROOT}/share)
set(TESTS_DIR ${CMAKE_BINARY_DIR}/tests)

set(EXPORT_ENVVARS "PYTHONPATH=${EXPORT_PYTHON}:$ENV{PYTHONPATH};LD_LIBRARY_PATH=${EXPORT_LIB}:$ENV{LD_LIBRARY_PATH};PATH=${EXPORT_BIN}:$ENV{PATH}")
