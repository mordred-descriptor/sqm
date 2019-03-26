mkdir build
cd build

cmake -G "MSYS Makefiles" -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER=gcc -DCMAKE_Fortran_COMPILER=gfortran -DCMAKE_MAKE_PROGRAM=mingw32-make -DCMAKE_INSTALL_PREFIX=%PREFIX% ..

cmake --build .

ctest --verbose

cmake --build . --target install
