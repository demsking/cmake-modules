# CMake Modules

This is a collection of CMake modules that I've produces for differents
projects over years.

## Install

```sh
mkdir cmake
wget -O cmake/InstallModule.cmake https://gitlab.com/demsking/cmake-modules/-/raw/master/InstallModule.cmake
```

## Usage

```cmake
set(MODULES_DIR "${CMAKE_SOURCE_DIR}/.modules")
set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake;${MODULES_DIR}")

include("InstallModule")

load_cmake_module(<module-name>)
```

## License

Copyright (C) 2020 Sébastien Demanou.

Under the GNU General Public License.

Everyone is permitted to copy, modify and distribute Fluent TTS. See
[LICENSE](LICENSE) file for more details.
