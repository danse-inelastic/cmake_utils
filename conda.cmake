# conda folder for build and conda packaging artifacts
include(GitUtils)

UPDATE_PACKAGE_FROM_GIT(${CMAKE_SOURCE_DIR} conda https://github.com/danse-inelastic/conda-packaging conda)
add_subdirectory(conda)
