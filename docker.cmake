# docker folder for build and test packaging artifacts
execute_process(
  COMMAND rm -rf docker
  COMMAND git clone https://github.com/danse-inelastic/packaging-use-docker docker
  WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
  )
add_subdirectory(docker)
