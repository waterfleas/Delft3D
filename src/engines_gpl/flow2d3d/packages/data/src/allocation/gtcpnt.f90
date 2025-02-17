function gtcpnt(pntnam    ,gdp       )
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
!  $Id: gtcpnt.f90 68181 2021-01-20 13:41:21Z leander $
!  $HeadURL: https://svn.oss.deltares.nl/repos/delft3d/tags/delft3d4/69179/src/engines_gpl/flow2d3d/packages/data/src/allocation/gtcpnt.f90 $
!!--description-----------------------------------------------------------------
!
!   Look up a character pointer name using FSM
!   and return an index into the appropriate array.
!
!!--pseudo code and references--------------------------------------------------
!
!   - Determine the length of the pointer name.
!   - Call the FSM GETPTR routine.
!   - If this returns zero, an error occured: an error message will be printed 
!     (by ERRPNT) and the program terminates (in ERRPNT)
!
!!--declarations----------------------------------------------------------------
    use precision
    use globaldata
    !
    implicit none
    !
    type(globdat),target :: gdp
    !
    ! The following list of pointer parameters is used to point inside the gdp structure
    !
    include 'fsm.i'
!
! Global variables
!
    integer(pntrsize) :: gtcpnt
    character(*)    :: pntnam
                                   !!  Character string containing array
                                   !!  name (hence max 6 characters).
!
! Local variables
!
    integer                        :: ind   ! Actual length of character string
!
!! executable statements -------------------------------------------------------
!
    ! Define length of pointer name (array name)
    ind = index(pntnam, ' ')
    if (ind==0) ind = len(pntnam) + 1
    !
    ! Call dynamic array declaration function GETPTR to get requested
    ! array pointer
    !
    gtcpnt = getptr(pntnam(:ind - 1))
    if (gtcpnt==0) then
       call errpnt(pntnam, 'character', 'lookup', gdp)
       ! program is terminated in errpnt
    endif
end function gtcpnt
