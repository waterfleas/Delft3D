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

! $Id: refinecellsonly.f90 68850 2021-04-20 14:00:11Z platzek $
! $HeadURL: https://svn.oss.deltares.nl/repos/delft3d/tags/delft3d4/69179/src/engines_gpl/dflowfm/packages/dflowfm_kernel/src/deprecated/refinecellsonly.f90 $

  SUBROUTINE REFINECELLSONLY()
  use m_netw
  USE M_POLYGON
  use gridoperations
  implicit none

  integer :: ja
  integer :: k
  integer :: k1
  integer :: kp
  integer :: lnu
  integer :: n
  integer :: nn

  DOUBLE PRECISION :: XL, YL, ZL = 0D0

  CALL FINDCELLS(0)

  DO N  = 1,NUMP
     CALL ALLIN(N,JA)
     IF (JA == 0) CYCLE
     CALL GETAVCOR    (N,XL,YL,ZL)
     CALL dSETNEWPOINT(XL,YL,KP)
     NN = netcell(N)%N
     DO K  = 1,NN
        K1 = netcell(N)%NOD(K)
        CALL CONNECTDB(KP,K1,LNU)
     ENDDO
  ENDDO

  CALL SETNODADM(0)

  END SUBROUTINE REFINECELLSONLY
