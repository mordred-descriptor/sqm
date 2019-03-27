#!/bin/bash

CMAKE_ARGS="-DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER=gcc -DCMAKE_Fortran_COMPILER=gfortran -DCMAKE_INSTALL_PREFIX=$PREFIX .."

if [[ "$OSTYPE" == "darwin"* ]]; then
    FC=$(basename $(realpath $(which gfortran)))
    CC=gcc${FC#gfortran}
    CMAKE_ARGS="$CMAKE_ARGS -DCMAKE_C_COMPILER=$CC -DCMAKE_Fortran_COMPILER=$FC"
fi

mkdir build
cd build

cmake $CMAKE_ARGS

cmake --build .

ctest --verbose

cmake --build . --target install
