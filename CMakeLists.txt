cmake_minimum_required(VERSION 3.5)

project(ambertools C Fortran)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

file(COPY ${CMAKE_CURRENT_SOURCE_DIR}/test DESTINATION ${CMAKE_CURRENT_BINARY_DIR})
file(COPY ${CMAKE_CURRENT_SOURCE_DIR}/dat DESTINATION ${CMAKE_CURRENT_BINARY_DIR})

foreach(name IN ITEMS c2h2 ch3f dftb3 dhplus external_charges fecp2 h2s nma znh+)
        add_test(NAME "test_${name}" COMMAND bash run.sh WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/test/sqm/${name}")
endforeach()

enable_testing()

add_subdirectory(src/lib)
add_subdirectory(src/blas)
add_subdirectory(src/lapack)
add_subdirectory(src/sff)
add_subdirectory(src/sqm)
