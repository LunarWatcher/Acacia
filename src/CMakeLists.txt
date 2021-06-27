cmake_minimum_required(VERSION 3.10)
project(Treesitter)

set (CMAKE_CXX_STANDARD 17)

if (NOT CMAKE_BUILD_TYPE)
    # Prevent explicit flags when it's not necessary
    set(CMAKE_BUILD_TYPE Release)
endif()

add_executable(treesitter Runner.cpp)

target_include_directories(treesitter PUBLIC ./)
