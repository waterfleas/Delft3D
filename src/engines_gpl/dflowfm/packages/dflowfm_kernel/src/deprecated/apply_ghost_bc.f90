!----- AGPL --------------------------------------------------------------------
!                                                                               
!  Copyright (C)  Stichting Deltares, 2017-2021.                                
!                                                                               
!  This file is part of Delft3D (D-Flow Flexible Mesh component).               
!                                                                               
!  Delft3D is free software: you can redistribute it and/or modify              
!  it under the terms of the GNU Affero General Public License as               
!  published by the Free Software Foundation version 3.                         
!                                                                               
!  Delft3D  is distributed in the hope that it will be useful,                  
!  but WITHOUT ANY WARRANTY; without even the implied warranty of               
!  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the                
!  GNU Affero General Public License for more details.                          
!                                                                               
!  You should have received a copy of the GNU Affero General Public License     
!  along with Delft3D.  If not, see <http://www.gnu.org/licenses/>.             
!                                                                               
!  contact: delft3d.support@deltares.nl                                         
!  Stichting Deltares                                                           
!  P.O. Box 177                                                                 
!  2600 MH Delft, The Netherlands                                               
!                                                                               
!  All indications and logos of, and references to, "Delft3D",                  
!  "D-Flow Flexible Mesh" and "Deltares" are registered trademarks of Stichting 
!  Deltares, and remain the property of Stichting Deltares. All rights reserved.
!                                                                               
!-------------------------------------------------------------------------------

! $Id: apply_ghost_bc.f90 68850 2021-04-20 14:00:11Z platzek $
! $HeadURL: https://svn.oss.deltares.nl/repos/delft3d/tags/delft3d4/69179/src/engines_gpl/dflowfm/packages/dflowfm_kernel/src/deprecated/apply_ghost_bc.f90 $

 !> apply Dirichlet conditions to non-overlapping ghost cells (i.e. effectively remove from the system)
 subroutine apply_ghost_bc(ierror)
    use m_flow
    use m_flowgeom
    use m_reduce
    use m_partitioninfo
    use m_alloc
    implicit none

    integer, intent(out) :: ierror  ! error (1) or not (0)

    integer              :: i, k, kother, L, LL

    do i=1,nghostlist_snonoverlap(ndomains-1)
       k = ighostlist_snonoverlap(i)
       do LL=1,nd(k)%lnx
          L = iabs(nd(k)%ln(LL))
          kother = ln(1,L)+ln(2,L)-k
          ddr(kother) = ddr(kother)-ccr(Lv2(L))*s1(k)
          ccr(Lv2(L)) = 0
          ddr(k) = ddr(k)-ccr(Lv2(L))*s1(k)
       end do
    end do

    ierror = 0

    return
 end subroutine apply_ghost_bc
