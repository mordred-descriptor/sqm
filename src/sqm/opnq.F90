#include "copyright.h"
#include "../include/dprec.fh"

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 
!  This module contains the implementation of
! charge-dependent NB interactions (OPNQ) see
! T. Giese and D. York, J. Chem. Phys. 2007, v127, p194101
!
! Implemented by Taisung Lee (Rutgers, 2011)
!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 

module opnq

  use qmmm_module, only: qmmm_opnq
  use EVDWMOD
  
  implicit none  
  
! visuability declaration
  public:: Opnq_fock, Opnq_fock_atom_pair, Opnq_LJ_atom_pair
  
  private:: LJ2OPNQ, Initialize 
  private:: initialized, MM_opnq, MM_opnq_list_saved, type_list_saved, &
            MaxAtomicNumber_MM_opnq
  
  integer, parameter::MaxAtomicNumber_MM_opnq=20 

! Data declaration
  logical, save::initialized=.false.
  
  type MM_opnq
    _REAL_:: s, zeta, alpha, neff
  end type MM_opnq
  type(MM_opnq), dimension(:), allocatable, save::MM_opnq_list_saved   

  integer, dimension(:), allocatable, save::type_list_saved
   
  contains
  
subroutine Opnq_fock(fock)
!***********************************************************************        
!                                                                               
!  This subroutine calculates the OPNQ contributions to the Fock matrix
!
!  Taisung Lee, Rutgers, 2011                             
!                                         
!***********************************************************************  
    use constants, only:  A_TO_BOHRS, zero     
    use ElementOrbitalIndex, only:MaxValenceOrbitals 
    use qmmm_module, only : qmmm_struct, qm2_params, qmmm_opnq
    implicit none

    _REAL_, intent(inout) :: fock(:)
    
! local
    integer::i,j,iqm, jmm, norbital
    _REAL_::fock_opnq, eOPNQ, LJ 
    _REAL_::fock_opnq_pair, eOPNQ_pair, LJ_pair

!  Check if initilization is necessary
    if (initialized) then
       if (.not.allocated(type_list_saved)) then
          initialized=.false.
       else 
        if (size(type_list_saved) /= size(qmmm_opnq%MM_atomType)) then
           initialized=.false.
        else 
           do i=1, size(type_list_saved)
              if (type_list_saved(i) /= qmmm_opnq%MM_atomType(i) ) then
                 initialized=.false.
                 exit
              end if ! (type_list_saved /= qmmm_opnq%MM_atomType(i) 
           end do ! i=1, size(type_list_saved)
        end if  ! (size(type_list_saved) /= size(qmmm_opnq%MM_atomType) 
       end if  !   (.not.allocated(type_list_saved))
    end if !  (initialized)   
              

    if (.not. initialized) call Initialize


    eOPNQ=zero
    LJ=zero
     
    do iqm=1, qmmm_struct%nquant
       norbital=qm2_params%natomic_orbs(iqm)
       
       fock_opnq=zero
       do jmm=1,qmmm_struct%qm_mm_pairs
           call Opnq_fock_atom_pair(iqm, jmm, eOPNQ_pair, fock_opnq_pair)
           call Opnq_LJ_atom_pair(iqm, jmm, LJ_pair) 
           eOPNQ=eOPNQ+eOPNQ_pair
           fock_opnq=fock_opnq+fock_opnq_pair
           LJ=LJ+LJ_pair
       end do ! jmm
       
       do i=qm2_params%orb_loc(1,iqm),qm2_params%orb_loc(2,iqm)
         j=qm2_params%pascal_tri2(i)
         fock(j)=fock(j)+fock_opnq
       end do ! i 
       
    end do ! iqm
    
    qmmm_opnq%OPNQCorrection=eOPNQ
    qmmm_opnq%vdWCorrection=-LJ
    
    return

end subroutine Opnq_fock

subroutine Opnq_fock_atom_pair(iqm, jmm, eOPNQ_pair, fock_opnq_pair, dx, dy, dz )
!***********************************************************************        
!                                                                               
!  This subroutine calculates the OPNQ contributions to the Fock matrix
! for a single quantum atom due to an MM atom.
! the output unit is eV.
!
!  Taisung Lee, Rutgers, 2011                             
!                                         
!*********************************************************************** 
    use constants, only:  A_TO_BOHRS, AU_TO_EV, zero     
    use qmmm_module, only : qmmm_struct, qm2_params, qmmm_opnq
    use QM2_parameters, only : core_chg
    use opnq_switching, only : switchoff
    
    implicit none

    integer, intent(in)::iqm, jmm
    _REAL_, intent(out) :: fock_opnq_pair, eOPNQ_pair
    _REAL_, intent(out), optional::dx, dy, dz
    
!local
    integer::jmm_index, qmtype, mmtype, atomic_number
    _REAL_:: qm_charge, r2, rij, rijInAu, core_charge
    _REAL_::  ee, dEdQi, dEdQj, switching, dSwitching, x, y, z, temp
    type(MM_opnq)::myOpnq
    
    fock_opnq_pair=zero
    eOPNQ_pair=zero
    if(present(dx) .and. present(dy) .and. present(dz) ) then
      dx=zero; dy=zero; dz=zero
    end if
    
    qmType=qmmm_struct%qm_atom_type(iqm)
    if (qm2_params%qxd_supported(qmtype)) then 
    
        ! calculate the effective charge for the qmatom 
        call qm2_calc_mulliken(iqm,qm_charge)
        
        jmm_index=qmmm_struct%qm_mm_pair_list(jmm)
        mmtype=qmmm_opnq%MM_atomType(jmm_index)
        if (qmmm_opnq%supported(mmtype)) then
            myOpnq=MM_opnq_list_saved(mmtype)
            atomic_number=qmmm_opnq%atomic_number(mmtype)
            core_charge=core_chg(atomic_number)*1.d0

            r2=sum( (qmmm_struct%qm_xcrd(1:3,jmm)-qmmm_struct%qm_coords(1:3,iqm) ) **2) 
            rij=sqrt(r2)
            rijInAu=rij*A_TO_BOHRS
            
            switching=1.0D0
            dSwitching=0.D0
            if (qmmm_opnq%switching) then
               call switchoff(rij,qmmm_opnq%switch_cutoff1,qmmm_opnq%switch_cutoff2,switching, dSwitching)
               dSwitching=dSwitching/A_TO_BOHRS ! the unit is 1/r
            endif
            
            call vdw_ij(qm_charge, qm2_params%qxd_s(qmtype),         &  ! qm atom
               qm2_params%qxd_z0(qmtype), qm2_params%qxd_zq(qmtype), &
               qm2_params%qxd_d0(qmtype), qm2_params%qxd_dq(qmtype), &
               qm2_params%qxd_q0(qmtype), qm2_params%qxd_qq(qmtype), &
               qm2_params%qxd_neff(qmtype), qm2_params%core_chg(iqm), &             
               qmmm_struct%qm_xcrd(4,jmm),  myopnq%s, myopnq%zeta, zero,  &  ! mm atom
               myopnq%alpha, zero, zero, zero, myopnq%neff, core_charge , &
               rijInAu, ee, dedqi, dedqj)   
     
            eOPNQ_pair=ee*switching*AU_TO_EV
            fock_opnq_pair=-dEdQi*switching*AU_TO_EV          
            
            if(present(dx) .and. present(dy) .and. present(dz) ) then
                 call vdw_ij_dri(qm_charge, qm2_params%qxd_s(qmtype),         &  ! qm atom
                   qm2_params%qxd_z0(qmtype), qm2_params%qxd_zq(qmtype), &
                   qm2_params%qxd_d0(qmtype), qm2_params%qxd_dq(qmtype), &
                   qm2_params%qxd_q0(qmtype), qm2_params%qxd_qq(qmtype), &
                   qm2_params%qxd_neff(qmtype), qm2_params%core_chg(iqm), &             
                   qmmm_struct%qm_xcrd(4,jmm),  myopnq%s, myopnq%zeta, zero,  &  ! mm atom
                   myopnq%alpha, zero, zero, zero, myopnq%neff, core_charge , &
                   qmmm_struct%qm_coords(1,iqm)*A_TO_BOHRS, &
                   qmmm_struct%qm_coords(2,iqm)*A_TO_BOHRS, &
                   qmmm_struct%qm_coords(3,iqm)*A_TO_BOHRS, &
                   qmmm_struct%qm_xcrd(1,jmm)*A_TO_BOHRS, &
                   qmmm_struct%qm_xcrd(2,jmm)*A_TO_BOHRS, &
                   qmmm_struct%qm_xcrd(3,jmm)*A_TO_BOHRS, &
                   dx,dy,dz)  

                 if (qmmm_opnq%switching) then
                     temp= ee * ( -dSwitching/rij )

                     x=qmmm_struct%qm_xcrd(1,jmm)-qmmm_struct%qm_coords(1,iqm)
                     dx=dx*switching + x*temp

                     y=qmmm_struct%qm_xcrd(2,jmm)-qmmm_struct%qm_coords(2,iqm)
                     dy=dy*switching + y*temp

                     z=qmmm_struct%qm_xcrd(3,jmm)-qmmm_struct%qm_coords(3,iqm)
                     dz=dz*switching + z*temp
                 endif

                 dx=dx*AU_TO_EV*A_TO_BOHRS
                 dy=dy*AU_TO_EV*A_TO_BOHRS
                 dz=dz*AU_TO_EV*A_TO_BOHRS

            end if                   

            continue
             
        end if

    endif ! (qm2_params%qxd_supported(qmtype))
    
    return
   
end subroutine Opnq_fock_atom_pair
  
subroutine Opnq_LJ_atom_pair(iqm, jmm, LJ_pair, dx, dy, dz)
!***********************************************************************        
!                                                                               
!  This subroutine calculates the classic LJ interactions on a single 
! QM atom due to an MM atom.
! the output unit is eV.
!
!  Taisung Lee, Rutgers, 2011                             
!                                         
!*********************************************************************** 
    use constants, only:  KCAL_TO_EV, zero     
    use qmmm_module, only : qmmm_struct, qm2_params, qmmm_opnq
    use opnq_switching, only : switchoff
    
    implicit none

    integer, intent(in)::iqm, jmm
    _REAL_, intent(out) :: LJ_pair
    _REAL_, intent(out), optional::dx, dy, dz
    
!local
    integer::jmm_index, qmType, mmtype, mmtype_for_iqm
    _REAL_:: r2, rij
    _REAL_::temp1, temp2, temp3, temp4, x, y, z, switching, dSwitching
   
    LJ_pair=zero
    if(present(dx) .and. present(dy) .and. present(dz) ) then
      dx=zero; dy=zero; dz=zero
    end if    
    
    qmType=qmmm_struct%qm_atom_type(iqm)
    mmtype_for_iqm=qmmm_opnq%MM_atomType( qmmm_struct%iqmatoms(iqm) )
    if (qm2_params%qxd_supported(qmtype)) then 
    
        jmm_index=qmmm_struct%qm_mm_pair_list(jmm)
        mmtype=qmmm_opnq%MM_atomType(jmm_index)
        if (qmmm_opnq%supported(mmtype)) then

            r2=sum( (qmmm_struct%qm_xcrd(1:3,jmm)-qmmm_struct%qm_coords(1:3,iqm) ) **2) 
            rij=sqrt(r2)
            
            ! classic LJ interaction
            temp1=0.5d0*(qmmm_opnq%LJ_r(mmtype_for_iqm)+qmmm_opnq%LJ_r(mmtype) )
            temp2=sqrt(qmmm_opnq%LJ_epsilon(mmtype_for_iqm)*qmmm_opnq%LJ_epsilon(mmtype) )
            
            switching=1.0D0
            dSwitching=0.D0

            if (qmmm_opnq%switching) then
               call switchoff(rij,qmmm_opnq%switch_cutoff1,qmmm_opnq%switch_cutoff2,switching, dSwitching)
            endif
             
            LJ_pair=4096.D0*(temp1**12)*temp2/(rij**12)-128.D0*(temp1**6)*temp2/(rij**6)
            
            if(present(dx) .and. present(dy) .and. present(dz) ) then 
                x=(qmmm_struct%qm_xcrd(1,jmm)-qmmm_struct%qm_coords(1,iqm) )/rij
                y=(qmmm_struct%qm_xcrd(2,jmm)-qmmm_struct%qm_coords(2,iqm) )/rij
                z=(qmmm_struct%qm_xcrd(3,jmm)-qmmm_struct%qm_coords(3,iqm) )/rij

                temp3=-12.D0*4096.D0*(temp1**12)*temp2/(rij**13)+6.D0*128.D0*(temp1**6)*temp2/(rij**7)

                temp4= (temp3*switching + dSwitching*LJ_pair) *KCAL_TO_EV
              
                dx=-temp4*x
                dy=-temp4*y
                dz=-temp4*z

            end if

            LJ_pair=LJ_pair*switching*KCAL_TO_EV
                     
        end if
    
    endif ! (qm2_params%qxd_supported(qmtype))
    
    return
   
end subroutine Opnq_LJ_atom_pair  
  
subroutine LJ2OPNQ(atomic_number, sigma, epsilon, MM_entry)
    
    use constants, only: AU_TO_KCAL, A_TO_BOHRS
    implicit none
       
    integer, intent(in)::atomic_number
    _REAL_,intent(in)::sigma, epsilon
    type(MM_opnq),intent(out)::mm_entry
 
    _REAL_, parameter::A=9.442292940115D0           !##############################
    _REAL_, parameter::B=0.411072836373204D0        !#   These Mapping Coeff might
    _REAL_, parameter::C=2.82083644658535D0         !# change in the future b/c
    _REAL_, parameter::D=3.78925426936423D0         !# initial parameterization  
    _REAL_, parameter::E=-0.0192103969646589D0      !# space could possibly change
    _REAL_, parameter::F=-0.724935124427059D0       !##############################   
  
    _REAL_, parameter, dimension(MaxAtomicNumber_MM_opnq)::G_data=(/  &
       0.00395D0, 0.00000D0, 0.00000D0, 0.00000D0, 0.00000D0, & ! 1-5
       0.20636D0, 0.18738D0, 0.17208D0, 0.00000D0, 0.00000D0, & ! 6-10
       0.00000D0, 0.00000D0, 0.00000D0, 0.00000D0, 0.00000D0, & ! 11-15                
       0.00000D0, 0.18944D0, 0.00000D0, 0.00000D0, 0.00000D0 /) ! 16-20 

    _REAL_, parameter, dimension(MaxAtomicNumber_MM_opnq)::neff_data=(/  &
       0.82400D0, 0.00000D0, 0.00000D0, 0.00000D0, 0.00000D0, & ! 1-5
       2.65700D0, 3.18700D0, 3.66300D0, 0.00000D0, 0.00000D0, & ! 6-10
       0.00000D0, 0.00000D0, 0.00000D0, 0.00000D0, 0.00000D0, & ! 11-15                
       0.00000D0, 5.55100D0, 0.00000D0, 0.00000D0, 0.00000D0 /) ! 16-20 
       
    _REAL_::temp1, temp2, G, neff
       
       neff=neff_data(atomic_number)
       G=G_data(atomic_number)
       
       MM_entry%s=A*(epsilon**B)*(sigma**C)
       MM_entry%zeta=D*(epsilon**E)*(sigma**F)
       temp1=512.d0*(1.d0-G)*(sigma*A_TO_BOHRS)**6.d0
       temp1=temp1*epsilon/AU_TO_KCAL
       temp2=(3.d0*sqrt(neff))
 
       MM_entry%alpha=(temp1/temp2)**(2.d0/3.d0)
       MM_entry%neff=neff_data(atomic_number)
       
    return
   
end subroutine LJ2OPNQ

subroutine Initialize()

  use qmmm_module, only: qmmm_opnq
  implicit none
  
  integer::i, natom, ntype
  type(MM_opnq)::temp
  
  natom=size(qmmm_opnq%MM_atomType)
  ntype=size(qmmm_opnq%LJ_r)
  
  if (allocated(type_list_saved)) deallocate(type_list_saved)
  allocate(type_list_saved(natom) )  
  type_list_saved=qmmm_opnq%MM_atomType
  
  if (allocated(MM_opnq_list_saved)) deallocate(MM_opnq_list_saved)
  allocate(MM_opnq_list_saved(ntype) )
  
  do i=1, ntype
    temp%S=0.d0
    temp%zeta=0.d0
    temp%alpha=0.d0
    temp%neff=0.d0
    if (qmmm_opnq%atomic_number(i)>=1 .and. &
        qmmm_opnq%atomic_number(i)<=MaxAtomicNumber_MM_opnq) then
        call LJ2OPNQ(qmmm_opnq%atomic_number(i),  &
             qmmm_opnq%LJ_r(i), qmmm_opnq%LJ_epsilon(i), temp) 
    end if
    MM_opnq_list_saved(i)=temp    
  end do ! i=1, ntype
 
  initialized=.true.
  
  return
 
end subroutine Initialize

end module 
