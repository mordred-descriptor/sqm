cmake_minimum_required(VERSION 2.8)

project(blas Fortran)

set(BLAS_SOURCES dasum.f daxpy.f dcabs1.f dcopy.f ddot.f dgbmv.f dgemm.f dgemv.f
dger.f dnrm2.f drot.f drotg.f dsbmv.f dscal.f dspmv.f dspr.f dspr2.f dswap.f
dsymm.f dsymv.f dsyr.f dsyr2.f dsyr2k.f dsyrk.f dtbmv.f dtbsv.f dtpmv.f dtpsv.f
dtrmm.f dtrmv.f dtrsm.f dtrsv.f dummy.f dzasum.f dznrm2.f icamax.f idamax.f
isamax.f izamax.f lsame.f sasum.f saxpy.f scopy.f sdot.f sgemm.f sgemv.f sger.f
snrm2.f sscal.f sswap.f ssymv.f ssyr2.f ssyr2k.f strmm.f strmv.f xerbla.f
zaxpy.f zcopy.f zdotc.f zdscal.f zgemm.f zgemv.f zgerc.f zhemv.f zher2.f
zher2k.f zscal.f zswap.f ztrmm.f ztrmv.f)

add_library(blas ${BLAS_SOURCES})
