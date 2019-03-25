project(sff C)

add_library(xminC xminC.c)
set_property(TARGET xminC PROPERTY COMPILE_DEFINITIONS SQM)
