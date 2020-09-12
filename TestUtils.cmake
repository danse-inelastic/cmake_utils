# requires: Dirs.cmake
# for 2.8.11- compatibility
macro ( GET_PARENT_DIR _dir _path )
  IF ( ${CMAKE_VERSION} VERSION_LESS "2.8.12" )
    get_filename_component( ${_dir} ${_path} PATH )
  ELSE ()
    get_filename_component( ${_dir} ${_path} DIRECTORY )
  ENDIF ()
endmacro ( GET_PARENT_DIR )
# python unit tests
#  macro to created test rules for all tests given in the argument list 
#  (after the arguments _test_src_dir and _testname_prefix)
#  * _test_src_dir:
#    the prefix directory used to prepend to the given filenames
#  * _testname_prefix:
#    prefix of test name
macro ( PYUNITTEST_ADD_TEST _test_src_dir _testname_prefix )
  # Add all of the individual tests so that they can be run in parallel
  foreach ( part ${ARGN} )
    # message( ${part} )
    get_filename_component( _filename ${part} NAME )
    get_filename_component( _suitename ${part} NAME_WE )
    GET_PARENT_DIR( _directory ${part} )
    string(SUBSTRING ${_directory} 1 -1 _dir) # remove the leading "."
    set ( _pyunit_separate_name "${_testname_prefix}${_dir}/${_suitename}" )
    # message( "name: ${_pyunit_separate_name}, cmd:${PYTHON_EXECUTABLE} -B ${_filename}, workdir:  ${_test_src_dir}/${_directory}" )
    add_test ( NAME ${_pyunit_separate_name}
      COMMAND ${PYTHON_EXECUTABLE} -B ${_filename} )
    # message("${part}: ${_env}")
    set_tests_properties ( ${_pyunit_separate_name} PROPERTIES 
      WORKING_DIRECTORY ${_test_src_dir}/${_directory}
      ENVIRONMENT "${EXPORT_ENVVARS}"
      )
  endforeach ( part ${ARGN} )
endmacro ( PYUNITTEST_ADD_TEST )

#  macro to create test rules for all tests in the given directory
#  * _test_src_dir:
#     the directory where tests live. must be absolute path
#  * _testname_prefix: 
#     prefix of test names generated
macro ( PYUNITTEST_ADD_TESTS_IN_DIR _test_src_dir _testname_prefix)
  message("-- PYUNITTEST_ADD_TESTS_IN_DIR: ${_test_src_dir} ${_testname_prefix}")
  IF (EXISTS ${_test_src_dir})
    execute_process(
      # COMMAND find . -name *TestCase.py
      COMMAND ${CMAKE_BINARY_DIR}/cmake_utils/find_py_tests.py . *TestCase.py
      WORKING_DIRECTORY ${_test_src_dir}
      OUTPUT_VARIABLE _tests
      RESULT_VARIABLE _res
      ERROR_VARIABLE _err
    )
    message(STATUS "RES: ${_res}")
    message(STATUS "ERR: ${_err}")
    message(STATUS "tests: ${_tests}")
    separate_arguments(_testlist UNIX_COMMAND ${_tests})
    # message(STATUS  ${_testlist} )
    PYUNITTEST_ADD_TEST( ${_test_src_dir} ${_testname_prefix} ${_testlist} )
  ELSE (EXISTS ${_test_src_dir})
    message(AUTHOR_WARNING ${_test_src_dir} Does not exist)
  ENDIF (EXISTS ${_test_src_dir})
endmacro ( PYUNITTEST_ADD_TESTS_IN_DIR )

# c tests
# compile executable
function ( CUNITTEST_ADD_TESTS  _test_name_prefix _link_libs _deps)
  set(__link_libs ${${_link_libs}})
  set(__deps ${${_deps}})
  set( SRC_FILES ${ARGN} )
  foreach( _src ${SRC_FILES} )
    get_filename_component( _filename ${_src} NAME )
    get_filename_component( _exe ${_src} NAME_WE )
    GET_PARENT_DIR( _directory ${_src} )
    set(_target_path ${_directory}/${_exe})
    string(REPLACE "/" "_" _target_name ${_target_path})
    # file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${_directory})
    add_executable(${_target_name} ${_src})
    add_dependencies(${_target_name} ${__deps})
    target_link_libraries(${_target_name} ${__link_libs})
    set(_testname ${_src})
    add_test(
      NAME ${_test_name_prefix}/${_testname} 
      COMMAND ${_target_name} 
      WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
      )
  endforeach( _src ${SRC_FILES} )
endfunction ( CUNITTEST_ADD_TESTS )