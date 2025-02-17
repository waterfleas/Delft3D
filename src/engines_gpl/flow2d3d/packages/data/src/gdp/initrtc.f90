subroutine initrtc(gdp)
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
!  $Id: initrtc.f90 68181 2021-01-20 13:41:21Z leander $
!  $HeadURL: https://svn.oss.deltares.nl/repos/delft3d/tags/delft3d4/69179/src/engines_gpl/flow2d3d/packages/data/src/gdp/initrtc.f90 $
!!--description-----------------------------------------------------------------
! NONE
!!--pseudo code and references--------------------------------------------------
! NONE
!!--declarations----------------------------------------------------------------
    use precision
    !
    use globaldata
    !
    implicit none
    !
    type(globdat),target :: gdp
    !
    ! The following list of pointer parameters is used to point inside the gdp structure
    !
    integer                       , pointer :: ifirstrtc
    integer                       , pointer :: stacnt
    integer                       , pointer :: rtcmod
    integer                       , pointer :: rtcact
    character(256)                , pointer :: filrtc
!
!! executable statements -------------------------------------------------------
!
    ifirstrtc  => gdp%gdrtc%ifirstrtc
    stacnt     => gdp%gdrtc%stacnt
    rtcmod     => gdp%gdrtc%rtcmod
    rtcact     => gdp%gdrtc%rtcact
    filrtc     => gdp%gdrtc%filrtc
    !
    ifirstrtc = 1
    stacnt = 0
    rtcmod = noRTC
    !
    nullify(gdp%gdrtc%mnrtcsta)
    nullify(gdp%gdrtc%mnrtcsta_gl)
    nullify(gdp%gdrtc%inodertcsta)
    nullify(gdp%gdrtc%namrtcsta)
    nullify(gdp%gdrtc%r0rtcsta)
    nullify(gdp%gdrtc%s1rtcsta)
    nullify(gdp%gdrtc%zrtcsta)
    !
    rtcact = noRTC
    !
    filrtc = ' '
end subroutine initrtc
