# docker folder for build and test packaging artifacts
include(GitUtils)

UPDATE_PACKAGE_FROM_GIT(${CMAKE_SOURCE_DIR} docker https://github.com/danse-inelastic/packaging-use-docker docker)
add_subdirectory(docker)
