project(sqm C Fortran)

set(COMMON_SOURCES findmask.F90 file_io_dat.F90 qm2_allocate_e_repul.F90 qm2_calc_charges.F90 qm2_calc_dipole.F90
        qm2_calc_rij_and_eqns.F90 qm2_dihed.F90 qm2_fock.F90
        qm2_get_qm_forces.F90 qm2_get_qmmm_forces.F90 qm2_h1elec.F90 qm2_hcore_qmqm.F90
        qm2_hcore_qmmm.F90 qm2_identify_peptide_links.F90
        qm2_load_params_and_allocate.F90 qm2_repp.F90 qm2_rotate_qmqm.F90
        qm2_core_core_repulsion.F90 qm2_core_core_repulsion_dxyz.F90
        qm2_iterator_mod.F90 qm2_diagonalizer_module.F90
        qm2_setup_orb_exp.F90 qm2_smallest_number.F90 qm2_fock_predict.F90
        qm_gb.F90 qm_zero_charges.F90 qm_assign_atom_types.F90
        qm_link_atoms.F90 qm2_print_charges.F90
        qmmm_qmtheorymodule.F90 qm2_print_bondorders.F90
        qm2_pm6_hof_module.F90 qm2_params_module.F90
        qm2_dftb_module.F90 qm2_dftb_broyden.F90
        qm2_dftb_dispersion_egr.F90 qm2_dftb_dispersion_params.F90
        qm2_dftb_dispersionread.F90 qm2_dftb_energy.F90
        qm2_dftb_ewevge.F90 qm2_dftb_externalshift.F90
        qm2_dftb_fermi.F90 qm2_dftb_get_qm_forces.F90 qm2_dftb_gamma.F90
        qm2_dftb_gammamat.F90 qm2_dftb_get_qmmm_forces.F90 qm2_dftb_gettab.F90
        qm2_dftb_load_params.F90
        qm2_dftb_mulliken.F90
        qm2_dftb_repulsiv.F90 qm2_dftb_self.F90 qm2_dftb_shift.F90
        qm2_dftb_skpar.F90 qm2_dftb_slkode.F90
        qm2_dftb_slktrafo.F90 qm2_dftb_read_cm3.F90 qm2_dftb_cm3.F90
        qm2_dftb_gb.F90 qm2_dftb_3rd_order.F90
        qmmm_module.F90 qmmm_nml_module.F90 qmmm_struct_module.F90 qmmm_vsolv_module.F90
        qm2_parameters.F90 dh_correction_module.F90
        utilitiesModule.F90 elementOrbitalIndex.F90 parameterReader.F90
        slater_overlap.F90 qm2_h1elec_d.F90 rotation.F90 qm2_repp_d.F90
        opnq_Edisp.F90  opnq_Erep.F90  opnq_Evdw.F90  opnq.F90  opnq_SwitchMod.F90
        qm2_fock_d.F90 MNDOChargeSeparation.F90 qm2_print_energy.F90
        qm2_dftb_get_dftb3_parameters.F90 qm2_dftb_gamma_dftb3.F90)

set(EXECUTABLE_SOURCES sqm.F90
        xmin.F90
        amopen.F90 mexit.F90 assert.F90
        timer_dummy.F90 nmlsrc.F90
        qm_print_info.F90
        qm2_energy.F90
        qm2_read_nm_and_alloc.F90
        qm2_scf.F90
        qm2_dftb_scf.F90)

include_directories("${CMAKE_BINARY_DIR}/src/lib")
include_directories("${CMAKE_BINARY_DIR}/src/sff")
include_directories("${CMAKE_BINARY_DIR}/src/sqm")
set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -ffree-line-length-0")

add_library(sqm_common ${COMMON_SOURCES})
add_executable(sqm ${EXECUTABLE_SOURCES})

set_property(TARGET sqm PROPERTY COMPILE_DEFINITIONS SQM)
target_compile_definitions(sqm PRIVATE SQM)

if ("${CMAKE_C_COMPILER_ID}" STREQUAL "GNU")
        if (APPLE)
                unset(CMAKE_Fortran_IMPLICIT_LINK_LIBRARIES)
                set_property(TARGET sqm PROPERTY LINKER_LANGUAGE C)

                find_package(PythonInterp)

                execute_process(
                        COMMAND "${PYTHON_EXECUTABLE}" "${CMAKE_CURRENT_SOURCE_DIR}/../../find_gcc_lib.py" ${CMAKE_Fortran_COMPILER} libquadmath.a
                        OUTPUT_VARIABLE LIBQUADMATH OUTPUT_STRIP_TRAILING_WHITESPACE)

                set_property(TARGET sqm PROPERTY LINK_FLAGS "-static-libgcc -lgfortran ${LIBQUADMATH}")
        else()
                set_property(TARGET sqm PROPERTY LINK_FLAGS "-static -static-libgcc")
        endif()
endif()
target_link_libraries(sqm sqm_common sys constants xminC lapack blas)

install(TARGETS sqm DESTINATION "bin")
