cmake_minimum_required(VERSION 2.8)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

file(COPY ${CMAKE_CURRENT_SOURCE_DIR}/test DESTINATION ${CMAKE_CURRENT_BINARY_DIR})
file(COPY ${CMAKE_CURRENT_SOURCE_DIR}/dat DESTINATION ${CMAKE_CURRENT_BINARY_DIR})

execute_process(
        COMMAND "${CMAKE_CURRENT_SOURCE_DIR}/find_libquadmath.py" "${CMAKE_Fortran_COMPILER}"
        OUTPUT_VARIABLE quadmath OUTPUT_STRIP_TRAILING_WHITESPACE)

foreach(name IN ITEMS c2h2 ch3f dftb3 dhplus external_charges fecp2 h2s nma znh+)
        add_test(NAME "test_${name}" COMMAND ./Run WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/test/sqm/${name}")
        set_property(TEST "test_${name}" PROPERTY ENVIRONMENT AMBERHOME=${CMAKE_BINARY_DIR})
endforeach()

enable_testing()

add_subdirectory(src/lib)
add_subdirectory(src/blas)
add_subdirectory(src/lapack)
add_subdirectory(src/sff)
add_subdirectory(src/sqm)

install(DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/dat" DESTINATION "share/amber")
