#############################################################################
# Run CPPLINT on c++ source files as a custom target
# Copyright (C) 2020 Sébastien Demanou <demsking@gmail.com>
#
# Usage:
#   include(CPPLINT)
#   add_cpplint(<target-name> [cpplint flags])
#     Create a target to check a target's sources with cppcheck and the indicated options
#   add_cpplint_sources(<target-name> [cpplint flags])
#     Create a target to check standalone sources with cppcheck and the indicated options
#
# Requires CMake 2.8 or newer (uses VERSION_LESS)
#
# This library is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this library. If not, see <http://www.gnu.org/licenses/>.
#############################################################################

if(__add_cpplint)
  return()
endif()

set(__add_cpplint YES)

set(CPPLINT_FILE "${CMAKE_BINARY_DIR}/tmp/cpplint")

if(NOT EXISTS ${CPPLINT_FILE})
  file(DOWNLOAD https://raw.githubusercontent.com/google/styleguide/gh-pages/cpplint/cpplint.py ${CPPLINT_FILE})
  file(
    INSTALL ${CPPLINT_FILE}
    DESTINATION ${CMAKE_BINARY_DIR}
    PERMISSIONS OWNER_READ OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ
  )
endif()

function(add_cpplint_sources TARGET_NAME)
  list(JOIN ARGN " " _args)
  set(_files)

  foreach(_source ${_input})
    get_source_file_property(_cpplint_loc "${_source}" LOCATION)

    if(_cpplint_loc)
      # This file has a source file property, carry on.
      get_source_file_property(_cpplint_lang "${_source}" LANGUAGE)

      if(("${_cpplint_lang}" STREQUAL "C") OR ("${_cpplint_lang}" STREQUAL "CXX"))
        list(APPEND _files "${_cpplint_loc}")
      endif()
    else()
      # This file doesn't have source file properties - figure it out.
      get_filename_component(_cpplint_loc "${_source}" ABSOLUTE)

      if(EXISTS "${_cpplint_loc}")
        list(APPEND _files "${_cpplint_loc}")
      else()
        message(FATAL_ERROR
          "Adding CPPLINT for file target ${TARGET_NAME}: "
          "File ${_source} does not exist or needs a corrected path location "
          "since we think its absolute path is ${_cpplint_loc}"
        )
      endif()
    endif()
  endforeach()

  add_custom_target(${PROJECT_NAME}_cpplint
    COMMAND
      ${CMAKE_BINARY_DIR}/cpplint ${_args} ${_files}
    WORKING_DIRECTORY
      "${CMAKE_CURRENT_SOURCE_DIR}"
    COMMENT
      "Running cpplint on target ${PROJECT_NAME}..."
    VERBATIM
  )

  add_dependencies(${TARGET_NAME} ${TARGET_NAME}_cpplint)
endfunction()

function(add_cpplint PROJECT_NAME)
  if(NOT TARGET ${PROJECT_NAME})
    message(FATAL_ERROR
      "add_cpplint given a target name that does not exist: '${PROJECT_NAME}' !"
    )
  endif()

  list(JOIN ARGN " " _args)

  get_target_property(_cpplint_sources "${PROJECT_NAME}" SOURCES)
  set(_files)

  foreach(_source ${_cpplint_sources})
    get_source_file_property(_cpplint_lang "${_source}" LANGUAGE)

    if(("${_cpplint_lang}" STREQUAL "C") OR ("${_cpplint_lang}" STREQUAL "CXX"))
      get_source_file_property(_cpplint_loc "${_source}" LOCATION)
      list(APPEND _files "${_cpplint_loc}")
    endif()
  endforeach()

  add_custom_target(${PROJECT_NAME}_cpplint
    COMMAND
      ${CMAKE_BINARY_DIR}/cpplint ${_args} ${_files}
    WORKING_DIRECTORY
      "${CMAKE_CURRENT_SOURCE_DIR}"
    COMMENT
      "Running cpplint on target ${PROJECT_NAME}..."
    VERBATIM
  )

  add_dependencies(${PROJECT_NAME} ${PROJECT_NAME}_cpplint)
endfunction()
