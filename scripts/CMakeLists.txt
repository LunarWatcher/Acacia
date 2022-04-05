# Consistency with acacia
cmake_minimum_required(VERSION 3.10)
# Bogus name
project(parser)

# Not sure if these need to be configured, but can add variables for that
# if necessary
set (CMAKE_C_STANDARD 99)
set (CMAKE_CXX_STANDARD 14)

file(GLOB SRC_FILES src/*.cc *.c)
add_library(parser SHARED ${SRC_FILES})

target_include_directories(parser PUBLIC ./src)
