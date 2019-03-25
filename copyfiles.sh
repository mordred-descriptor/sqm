#!/bin/bash

SRC=$1
DST=$(cd $(dirname $0); pwd)/src

mkdir -p $DST/{include,lib,blas,lapack,sff,sqm}
mkdir -p $DST/../{test,dat}

for file in $SRC/include/{assert.fh,dprec.fh,md.h,memory.h}; do
    cp $file $DST/include/
done

for file in $SRC/lib/{constants.F90,copyright.h,sys.F,veclib.F90,wallclock.c}; do
    cp $file $DST/lib/
done

for file in $SRC/blas/*.f; do
    cp $file $DST/blas/
done

for file in $SRC/lapack/*.f; do
    cp $file $DST/lapack/
done

for file in $SRC/sqm/makedepend $SRC/sqm/*.{F90,h}; do
    cp $file $DST/sqm/
done

cp $SRC/sff/{sff.h,xminC.c} $DST/sff/

cp $SRC/../LICENSE $DST/..
cp -r $SRC/../test/sqm $DST/../test/sqm
cp $SRC/../test/{dacdif,ndiff.awk,check_slko_files.x} $DST/../test/
cp -r $SRC/../../dat/slko $DST/../dat/
