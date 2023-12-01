cmake_minimum_required(VERSION 3.0)

project(aoc_23_cpp)

set(CMAKE_CXX_STANDARD 20)

set(SOURCES src/1.cpp src/utils.cpp)

include_directories(include)


add_executable(output ${SOURCES})