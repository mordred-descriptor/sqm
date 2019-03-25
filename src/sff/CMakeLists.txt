cmake_minimum_required(VERSION 2.8)

project(sff C)

add_library(xminC xminC.c)
set_property(TARGET xminC PROPERTY COMPILE_DEFINITIONS SQM)
