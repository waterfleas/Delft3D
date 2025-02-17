subroutine shrwav(nmmax     ,kmax      ,icx       ,dfu       ,deltau    , &
                & tp        ,rlabda    ,hu        ,kfu       , &
                & ddk       ,thick     ,gdp       )
!----- GPL ---------------------------------------------------------------------
!                                                                               
!  Copyright (C)  Stichting Deltares, 2011-2021.                                
!                                                                               
!  This program is free software: you can redistribute it and/or modify         
!  it under the terms of the GNU General Public License as published by         
!  the Free Software Foundation version 3.                                      
!                                                                               
!  This program is distributed in the hope that it will be useful,              
!  but WITHOUT ANY WARRANTY; without even the implied warranty of               
!  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the                
!  GNU General Public License for more details.                                 
!                                                                               
!  You should have received a copy of the GNU General Public License            
!  along with this program.  If not, see <http://www.gnu.org/licenses/>.        
!                                                                               
!  contact: delft3d.support@deltares.nl                                         
!  Stichting Deltares                                                           
!  P.O. Box 177                                                                 
!  2600 MH Delft, The Netherlands                                               
!                                                                               
!  All indications and logos of, and references to, "Delft3D" and "Deltares"    
!  are registered trademarks of Stichting Deltares, and remain the property of  
!  Stichting Deltares. All rights reserved.                                     
!                                                                               
!-------------------------------------------------------------------------------
!  $Id: shrwav.f90 68181 2021-01-20 13:41:21Z leander $
!  $HeadURL: https://svn.oss.deltares.nl/repos/delft3d/tags/delft3d4/69179/src/engines_gpl/flow2d3d/packages/kernel/src/compute/shrwav.f90 $
!!--description-----------------------------------------------------------------
!
! NONE
!
!!--pseudo code and references--------------------------------------------------
! NONE
!!--declarations----------------------------------------------------------------
    use precision
    use mathconsts
    use globaldata
    !
    implicit none
    !
    type(globdat),target :: gdp
    !
    ! The following list of pointer parameters is used to point inside the gdp structure
    !
    real(fp)                                          , pointer    :: rhow    !  Density of water
!
! Global variables
!
    integer                                         , intent(in) :: icx     !!  Increment in the X-dir., if ICX= NMAX then computation proceeds in the X-dir.
                                                                            !!  If icx=1 then computation proceeds in the Y-dir.
    integer                                         , intent(in) :: kmax    !  Description and declaration in esm_alloc_int.f90
    integer                                         , intent(in) :: nmmax   !  Description and declaration in dimens.igs
    integer , dimension(gdp%d%nmlb:gdp%d%nmub)      , intent(in) :: kfu     !  Description and declaration in esm_alloc_int.f90
    real(fp), dimension(gdp%d%nmlb:gdp%d%nmub)      , intent(in) :: deltau  !  Description and declaration in esm_alloc_real.f90
    real(fp), dimension(gdp%d%nmlb:gdp%d%nmub)      , intent(in) :: dfu     !  Description and declaration in esm_alloc_real.f90
    real(fp), dimension(gdp%d%nmlb:gdp%d%nmub)      , intent(in) :: hu      !  Description and declaration in esm_alloc_real.f90
    real(fp), dimension(gdp%d%nmlb:gdp%d%nmub)      , intent(in) :: rlabda  !  Description and declaration in esm_alloc_real.f90
    real(fp), dimension(gdp%d%nmlb:gdp%d%nmub)      , intent(in) :: tp      !  Description and declaration in esm_alloc_real.f90
    real(fp), dimension(gdp%d%nmlb:gdp%d%nmub, kmax)             :: ddk     !!  Internal work array, diagonal space at (N,M,K)
    real(fp), dimension(kmax)                       , intent(in) :: thick   !  Description and declaration in esm_alloc_real.f90
!
! Local variables
!
    integer    :: k
    integer    :: nm
    integer    :: nmu
    real(fp)   :: ku
    real(fp)   :: omega
    real(fp)   :: tpu
    real(fp)   :: vdist
    real(fp)   :: zbot
    real(fp)   :: ztop
    real(fp)   :: frac
!
!
!! executable statements -------------------------------------------------------
!
    rhow        => gdp%gdphysco%rhow
    !
    ! Add shear stress in wave boundary layer due to streaming
    !
    nmu = icx
    do nm = 1, nmmax
       ztop = 0.0_fp
       nmu  = nmu + 1
       if (kfu(nm)==1) then
          do k = kmax, 1, -1
             zbot = ztop
             ztop = ztop + thick(k)*hu(nm)
             if (tp(nm)>0.0_fp .and. tp(nmu)>0.0_fp) then
                tpu   = 0.5_fp*(tp(nm) + tp(nmu))
                omega = 2.0_fp*pi/tpu
                !
                ! deltau/dfu are defined at velocity points
                ! dfu is dissipation multiplied with costu (see TAUBOT)
                ! angle between waves and current. (so dissipation can be negative) 
                !
                ku    = 2.0_fp * pi / (max(0.5_fp*(rlabda(nm)+rlabda(nmu)),1.0e-12_fp))
                !
                ! Add term for streaming in momentum equations 
                ! for layers in the wave boundary layer
                ! We have to take into account the fraction of the layer within the wave boundary layer
                !
                if (ztop<=deltau(nm).and. deltau(nm)>1.0e-7_fp) then
                   frac       = (1.0_fp - zbot/deltau(nm)-(ztop-zbot)/(2.0_fp*deltau(nm)))
                   ddk(nm, k) = ddk(nm, k) + frac*(dfu(nm)*ku/omega)/(rhow*deltau(nm))
                elseif (zbot<=deltau(nm) .and. deltau(nm)>1.0e-7_fp) then
                   frac       = (min(ztop, deltau(nm))- zbot)/(2.0_fp*(ztop-zbot))
                   ddk(nm, k) = ddk(nm, k) + frac*(dfu(nm)*ku/omega)/(rhow*deltau(nm))
                else
                   exit
                endif
             endif
          enddo
       endif
    enddo
end subroutine shrwav
