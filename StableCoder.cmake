#############################################################################
# StableCoder Installer - CMake module
# Copyright (C) 2020 Sébastien Demanou <demsking@gmail.com>
#
# Usage:
#   include(StableCoder)
#   install_stablecoder_script(<script-name>)
#   install_stablecoder_script(NAME <script-name>
#     [VERSION <script-version>]
#     [INSTALL_LOCATION <dir>])
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

function(install_stablecoder_script)
  set(oneValueArgs NAME VERSION INSTALL_LOCATION)
  cmake_parse_arguments(SCRIPT "" "${oneValueArgs}" "" ${ARGN})

  if(NOT DEFINED SCRIPT_NAME)
    set(SCRIPT_NAME ${ARGV0})
  endif()

  if(NOT DEFINED SCRIPT_VERSION)
    set(SCRIPT_VERSION "20.04") # default version
  endif()

  if(NOT DEFINED INSTALL_LOCATION)
    set(INSTALL_LOCATION "${CMAKE_BINARY_DIR}/cmake")
  endif()

  set(SCRIPT_DOWNLOAD_LOCATION "${INSTALL_LOCATION}/${SCRIPT_NAME}.cmake")

  if(NOT EXISTS ${SCRIPT_DOWNLOAD_LOCATION})
    set(SCRIPT_URL "https://raw.githubusercontent.com/StableCoder/cmake-scripts/${SCRIPT_VERSION}/${SCRIPT_NAME}.cmake")
    message(STATUS "Downloading StableCoder/cmake-scripts/${SCRIPT_NAME}.cmake")

    file(DOWNLOAD ${SCRIPT_URL} ${SCRIPT_DOWNLOAD_LOCATION})

    if(NOT EXISTS ${SCRIPT_DOWNLOAD_LOCATION})
      message(FATAL_ERROR "Unable to download ${SCRIPT_URL}")
    endif()

    # Make sure the downloaded file is not empty
    file(SIZE ${SCRIPT_DOWNLOAD_LOCATION} SCRIPT_SIZE)

    if(SCRIPT_SIZE EQUAL 0)
      file(REMOVE ${SCRIPT_DOWNLOAD_LOCATION})
      message(FATAL_ERROR "Downloaded an empty CMake script for ${SCRIPT_NAME}")
    endif()
  endif()

  include(${SCRIPT_DOWNLOAD_LOCATION})
endfunction()
