# macro to checkout a package from git
# _dir: directory in which the package will be checked out 
# _pkg: name of package
# _giturl: git url of the package
macro ( UPDATE_PACKAGE_FROM_GIT _dir _pkg _giturl )
  message("-- UPDATE_PACKAGE_FROM_GIT: ${_pkg} at %{_dir} from ${_giturl}")
  IF(EXISTS "${_dir}/${_pkg}")
    execute_process(
      COMMAND git pull
      WORKING_DIRECTORY "${_dir}/${_pkg}"
      )
  ELSE(EXISTS "${_dir}/${_pkg}")
    execute_process(
      COMMAND git clone ${_giturl} ${_pkg}
      WORKING_DIRECTORY ${_dir}
      )
  ENDIF(EXISTS "${_dir}/${_pkg}")
endmacro ( UPDATE_PACKAGE_FROM_GIT )
