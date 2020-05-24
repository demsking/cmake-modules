#############################################################################
# Processor Info - CMake module
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

macro(processor_info)
  if(CMAKE_SIZEOF_VOID_P EQUAL 8)
    message(STATUS "Target is 64 bits")
  else()
    message(STATUS "Target is 32 bits")
  endif()

  message(STATUS "Architecture detected: ${CMAKE_HOST_SYSTEM_PROCESSOR}")
endmacro()
