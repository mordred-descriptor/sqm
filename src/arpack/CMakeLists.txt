cmake_minimum_required(VERSION 2.8)

project(arpack C Fortran)

set(ARPACK_SOURCES debug.h dgetv0.f dlaqrb.f dmout.f dnaitr.f dnapps.f dnaup2.f
dnaupd.f dnconv.f dneigh.f dneupd.f dngets.f dsaitr.f dsapps.f dsarpack.f
dsaup2.f dsaupd.f dsconv.f dseigt.f dsesrt.f dseupd.f dsgets.f dsortc.f
dsortr.f dstatn.f dstats.f dstqrb.f dvout.f ivout.f LICENSE stat.h version.h
wallclock.c)

add_library(arpack ${ARPACK_SOURCES})
