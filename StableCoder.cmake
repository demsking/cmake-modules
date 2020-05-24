#############################################################################
# StableCoder Installer - CMake module
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

option(STABLECODER_SCRIPTS_VERSION 20.04)

macro(install_stablecoder_script SCRIPT)
  set(SCRIPT_DOWNLOAD_LOCATION "${CMAKE_BINARY_DIR}/cmake/${SCRIPT}.cmake")

  if(NOT EXISTS ${SCRIPT_DOWNLOAD_LOCATION})
    message(STATUS "Downloading StableCoder/cmake-scripts/${SCRIPT}.cmake")
    file(DOWNLOAD https://raw.githubusercontent.com/StableCoder/cmake-scripts/${STABLECODER_SCRIPTS_VERSION}/${SCRIPT}.cmake ${SCRIPT_DOWNLOAD_LOCATION})
  endif()

  include(${SCRIPT_DOWNLOAD_LOCATION})
endmacro()

