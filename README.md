AmberTools sqm
==
[![Build Status](https://travis-ci.org/mordred-descriptor/sqm.svg?branch=master)](https://travis-ci.org/mordred-descriptor/sqm)
[![Anaconda-Server Badge](https://anaconda.org/mordred-descriptor/sqm/badges/version.svg)](https://anaconda.org/mordred-descriptor/sqm)

modified version of AmberTools sqm.

modifications
--
* add option to dump msgpack

installation
--

* conda

    ```.bash
    conda install sqm -c mordred-descriptor
    ```

* [download from github release](https://github.com/mordred-descriptor/sqm/releases/latest)

* from source

    ```.bash
    # apt install cmake gfortran gcc  # ubuntu
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
```.bash
git clone https://github.com/mordred-descriptor/sqm.git
export AMBERHOME=$PWD/sqm
```

or download parameters from http://www.dftb.org/
