cmake_minimum_required(VERSION 2.8)

project(lapack Fortran)

set(LAPACK_SOURCES chla_transtype.f dbdsqr.f dgebak.f dgebal.f dgebd2.f dgebrd.f
dgecon.f dgeequ.f dgeequb.f dgeev.f dgehd2.f dgehrd.f dgelq2.f dgelqf.f dgelsd.f
dgelss.f dgelsy.f dgeqp3.f dgeqr2.f dgeqrf.f dgerfs.f dgerfsx.f dgerq2.f dgesv.f
dgesvd.f dgesvx.f dgetf2.f dgetrf.f dgetrs.f dggbak.f dggbal.f dggev.f dgghrd.f
dhgeqz.f dhseqr.f disnan.f dla_geamv.f dla_gercond.f dla_gerfsx_extended.f
dla_lin_berr.f dla_rpvgrw.f dla_wwaddw.f dlabad.f dlabrd.f dlacn2.f dlacpy.f
dladiv.f dlae2.f dlaebz.f dlaed0.f dlaed1.f dlaed2.f dlaed3.f dlaed4.f dlaed5.f
dlaed6.f dlaed7.f dlaed8.f dlaed9.f dlaeda.f dlaev2.f dlaexc.f dlag2.f dlagtf.f
dlagts.f dlahqr.f dlahr2.f dlahrd.f dlaic1.f dlaisnan.f dlaln2.f dlals0.f
dlalsa.f dlalsd.f dlamch.f dlamrg.f dlaneg.f dlange.f dlanhs.f dlansp.f dlanst.f
dlansy.f dlantr.f dlanv2.f dlapy2.f dlapy3.f dlaqge.f dlaqp2.f dlaqps.f dlaqr0.f
dlaqr1.f dlaqr2.f dlaqr3.f dlaqr4.f dlaqr5.f dlar1v.f dlarf.f dlarfb.f dlarfg.f
dlarfp.f dlarft.f dlarfx.f dlarnv.f dlarra.f dlarrb.f dlarrc.f dlarrd.f dlarre.f
dlarrf.f dlarrj.f dlarrk.f dlarrr.f dlarrv.f dlartg.f dlaruv.f dlarz.f dlarzb.f
dlarzt.f dlas2.f dlascl.f dlascl2.f dlasd4.f dlasd5.f dlasd6.f dlasd7.f dlasd8.f
dlasda.f dlasdq.f dlasdt.f dlaset.f dlasq1.f dlasq2.f dlasq3.f dlasq4.f dlasq5.f
dlasq6.f dlasr.f dlasrt.f dlassq.f dlasv2.f dlaswp.f dlasy2.f dlasyf.f dlatrd.f
dlatrs.f dlatrz.f dopgtr.f dopmtr.f dorg2l.f dorg2r.f dorgbr.f dorghr.f dorgl2.f
dorglq.f dorgql.f dorgqr.f dorgtr.f dorm2l.f dorm2r.f dormbr.f dormhr.f dorml2.f
dormlq.f dormql.f dormqr.f dormr3.f dormrz.f dormtr.f dposv.f dpotf2.f dpotrf.f
dpotrs.f dppsv.f dpptrf.f dpptrs.f drscl.f dspev.f dspevd.f dspevx.f dspsv.f
dsptrd.f dsptrf.f dsptrs.f dstebz.f dstedc.f dstegr.f dstein.f dstemr.f dsteqr.f
dsterf.f dsyev.f dsyevd.f dsyevr.f dsyevx.f dsygs2.f dsygst.f dsygv.f dsysv.f
dsytd2.f dsytf2.f dsytrd.f dsytrf.f dsytrs.f dtgevc.f dtrevc.f dtrexc.f dtrsen.f
dtrsyl.f dtzrzf.f dummy.f ieeeck.f iladlc.f iladlr.f ilaenv.f ilaprec.f
ilatrans.f ilazlc.f ilazlr.f iparmq.f lsame.f ssyevx.f zheev.f zhetd2.f zhetrd.f
zlacgv.f zladiv.f zlanhe.f zlarf.f zlarfb.f zlarfg.f zlarft.f zlascl.f zlaset.f
zlasr.f zlassq.f zlatrd.f zsteqr.f zung2l.f zung2r.f zungql.f zungqr.f zungtr.f)

add_library(lapack ${LAPACK_SOURCES})
