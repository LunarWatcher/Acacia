cmake_minimum_required(VERSION 3.10)
project(Treesitter)

set (CMAKE_CXX_STANDARD 17)

if (NOT CMAKE_BUILD_TYPE)
    # Prevent explicit flags when it's not necessary
    set(CMAKE_BUILD_TYPE Release)
endif()


# Conan {{{
if(NOT EXISTS "${CMAKE_BINARY_DIR}/conan.cmake")
  message(STATUS "Downloading conan.cmake from https://github.com/conan-io/cmake-conan")
  file(DOWNLOAD "https://raw.githubusercontent.com/conan-io/cmake-conan/v0.16.1/conan.cmake"
                "${CMAKE_BINARY_DIR}/conan.cmake"
                TLS_VERIFY ON)
endif()

include(${CMAKE_BINARY_DIR}/conan.cmake)

conan_cmake_configure (REQUIRES
    tree-sitter/0.20.0 # Necessary for reasons that should be obvious :p
    spdlog/1.9.2
    nlohmann_json/3.10.5
    GENERATORS cmake
    OPTIONS ixwebsocket:tls=False)
conan_cmake_autodetect (settings)
conan_cmake_install (PATH_OR_REFERENCE . BUILD missing SETTINGS ${settings})

include(${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)
conan_basic_setup()
# }}}

# Might be useful to make everything else header-only. We'll see.
add_executable(treesitter Server.cpp)

target_include_directories(treesitter PUBLIC ./)
target_include_directories(treesitter PUBLIC ${CONAN_INCLUDE_DIRS})

target_link_libraries(treesitter ${CONAN_LIBS})
