cmake_minimum_required(VERSION 2.8)

project(lib C Fortran)

add_library(sys sys.F veclib.F90 wallclock.c)
add_library(constants constants.F90)
