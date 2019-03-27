AmberTools sqm
==
[![Build Status](https://travis-ci.org/mordred-descriptor/sqm.svg?branch=master)](https://travis-ci.org/mordred-descriptor/sqm)
[![Anaconda-Server Badge](https://anaconda.org/mordred-descriptor/sqm/badges/version.svg)](https://anaconda.org/mordred-descriptor/sqm)

installation
--

conda

```
conda install sqm -c mordred-descriptor
```

from source

```
apt install cmake gfortran gcc  # ubuntu
git clone https://github.com/mordred-descriptor/sqm.git

mkdir build
cd build

cmake -DCMAKE_BUILD_TYPE=Release ..

cmake --build .
ctest
cmake --build . --target install
```

use dftb
--
```
git clone https://github.com/mordred-descriptor/sqm.git
export AMBERHOME=$PWD/sqm
```

or download parameters from http://www.dftb.org/
