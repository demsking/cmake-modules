#############################################################################
# CMake Install Module - CMake module
# Copyright (C) 2020 Sébastien Demanou <demsking@gmail.com>
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

option(MODULES_DIR "${CMAKE_SOURCE_DIR}/.modules")

function(install_cmake_module MODULE_NAME MODULE_URL)
  set(MODULE_RELATIVE_PATH "${MODULE_NAME}.cmake")
  set(MODULE_ABSOLUTE_PATH "${MODULES_DIR}/${MODULE_RELATIVE_PATH}")

  if(NOT EXISTS ${MODULE_ABSOLUTE_PATH})
    message(STATUS "Downloading ${MODULE_URL}")
    file(DOWNLOAD ${MODULE_URL} ${MODULE_ABSOLUTE_PATH})

    if(NOT EXISTS ${MODULE_ABSOLUTE_PATH})
      message(FATAL_ERROR "Unable to download ${MODULE_URL}")
    endif()
  endif()

  message(STATUS "Including ${MODULE_RELATIVE_PATH}")
  include(${MODULE_ABSOLUTE_PATH})
endfunction()

function(load_cmake_module MODULE_NAME)
  install_cmake_module(${MODULE_NAME} "https://gitlab.com/demsking/cmake-modules/-/raw/master/${MODULE_NAME}.cmake")
endfunction()
