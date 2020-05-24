# CMake Modules

This is a collection of CMake modules that I've produces for differents
projects over years.

## Install

```sh
whet -o cmake/InstallModule.cmake https://gitlab.com/demsking/cmake-modules/-/raw/master/InstallModule.cmake
```

## Usage

```cmake
include("InstallModule")

load_cmake_module(<module-name>)
```

## License

Copyright (C) 2020 Sébastien Demanou.

Under the GNU General Public License.

Everyone is permitted to copy, modify and distribute Fluent TTS. See
[LICENSE](LICENSE) file for more details.
