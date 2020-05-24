#############################################################################
# Run CPPLINT on c++ source files as a custom target
# Copyright (C) 2020 Sébastien Demanou <demsking@gmail.com>
#
#  include(CPPLINT)
#  add_cpplint(<target-name> [UNUSED_FUNCTIONS] [STYLE] [POSSIBLE_ERROR] [FORCE] [FAIL_ON_WARNINGS]) -
#    Create a target to check a target's sources with cppcheck and the indicated options
#  add_cpplint_sources(<target-name> [UNUSED_FUNCTIONS] [STYLE] [POSSIBLE_ERROR] [FORCE] [FAIL_ON_WARNINGS]) -
#    Create a target to check standalone sources with cppcheck and the indicated options
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

set(CPPLINT_BIN "${CMAKE_BINARY_DIR}/cpplint.py")

if(NOT EXISTS ${CPPLINT_BIN})
  file(DOWNLOAD https://raw.githubusercontent.com/google/styleguide/gh-pages/cpplint/cpplint.py ${CPPLINT_BIN})
endif()

function(add_cpplint_sources _targetname)
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
          "Adding CPPLINT for file target ${_targetname}: "
          "File ${_source} does not exist or needs a corrected path location "
          "since we think its absolute path is ${_cpplint_loc}")
      endif()
    endif()
  endforeach()

  add_custom_target(${_targetname}_cpplint
    COMMAND
      ${CPPLINT_BIN}
      ${_args}
      ${_files}
    WORKING_DIRECTORY
      "${CMAKE_CURRENT_SOURCE_DIR}"
    COMMENT
      "${_targetname}_cpplint: Running cpplint on target ${_targetname}..."
    VERBATIM
  )

  add_dependencies(${_targetname} ${_targetname}_cpplint)
endfunction()

function(add_cpplint _name)
  if(NOT TARGET ${_name})
    message(FATAL_ERROR
      "add_cpplint given a target name that does not exist: '${_name}' !")
  endif()

  list(JOIN ARGN " " _args)

  get_target_property(_cpplint_sources "${_name}" SOURCES)
  set(_files)

  foreach(_source ${_cpplint_sources})
    get_source_file_property(_cpplint_lang "${_source}" LANGUAGE)
    get_source_file_property(_cpplint_loc "${_source}" LOCATION)

    if(("${_cpplint_lang}" STREQUAL "C") OR ("${_cpplint_lang}" STREQUAL "CXX"))
      list(APPEND _files "${_cpplint_loc}")
    endif()
  endforeach()

  add_custom_target(${_name}_cpplint
    COMMAND
      ${CPPLINT_BIN}
      ${_args}
      ${_files}
    WORKING_DIRECTORY
      "${CMAKE_CURRENT_SOURCE_DIR}"
    COMMENT
      "${_name}_cpplint: Running cpplint on target ${_name}..."
    VERBATIM
  )

  add_dependencies(${_name} ${_name}_cpplint)
endfunction()
