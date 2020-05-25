#############################################################################
# Run CPPLINT on c++ source files as a custom target
# Copyright (C) 2020 Sébastien Demanou <demsking@gmail.com>
#
# Usage:
#   include(CPPLINT)
#
#   - Create a target to check a target's sources with cppcheck and the indicated options
#     add_cpplint(<target-name> [cpplint flags])
#
#   - Create a target to check standalone sources with cppcheck and the indicated options
#     add_cpplint_sources(
#       TARGET <target-name>
#       SOURCES <sources>
#       [OPTIONS <cpplint-options>]
#     )
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

function(add_cpplint_sources)
  set(oneValueArgs TARGET OPTIONS SOURCES)
  cmake_parse_arguments(ARG "" "${oneValueArgs}" "" ${ARGN})

  if(NOT TARGET ${ARG_TARGET})
    message(FATAL_ERROR
      "add_cpplint given a target name that does not exist: '${ARG_TARGET}' !"
    )
  endif()

  add_custom_target(${ARG_TARGET}_cpplint
    COMMAND
      ${CMAKE_BINARY_DIR}/cpplint ${ARG_OPTIONS} ${ARG_SOURCES}
    WORKING_DIRECTORY
      "${CMAKE_CURRENT_SOURCE_DIR}"
    COMMENT
      "Running cpplint on target ${ARG_TARGET}..."
    VERBATIM
  )

  add_dependencies(${ARG_TARGET} ${ARG_TARGET}_cpplint)
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
