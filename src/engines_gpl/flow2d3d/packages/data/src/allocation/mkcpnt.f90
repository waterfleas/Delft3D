function mkcpnt(pntnam    ,length    ,gdp       )
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
!  $Id: mkcpnt.f90 68181 2021-01-20 13:41:21Z leander $
!  $HeadURL: https://svn.oss.deltares.nl/repos/delft3d/tags/delft3d4/69179/src/engines_gpl/flow2d3d/packages/data/src/allocation/mkcpnt.f90 $
!!--description-----------------------------------------------------------------
!
! Request memory space with the dynamic array
! declaration routines to create a pointer for the
! character array with pointer name PNTNAM
! The requested memory is initialized
!
!!--pseudo code and references--------------------------------------------------
!
!   - Determine the length of the pointer name.
!   - Call the FSM's GETPTR to check whether or not a pointer with this name
!     already exists. If it does exist, return -1 (value is used by MOR).
!   - Call the FSM's MAKPTR to allocate memory and register
!     the pointer name (for subsequent GETPTR's).  The routines
!     may be called with a length of zero.  Since this is not allowed
!     by FSM, at least one element will always be allocated.
!   - If MAKPTR returns zero an error has occured. A message will
!     be printed (by ERRPNT) and the program terminates.
!   - Otherwise, the newly allocated storage is cleared with zeroes
!     and the value 1 is returned (value is used by MOR).
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
    integer         :: length
                                   !!  Total required array length
    integer(pntrsize) :: mkcpnt
    character(*)    :: pntnam
                                   !!  Character string containing array
                                   !!  name (hence max 6 characters).
!
! Local variables
!
    integer                        :: ind    ! Actual length of character string
!
!! executable statements -------------------------------------------------------
!
    ! Define length of pointer name (array name)
    ind = index(pntnam, ' ')
    if (ind==0) ind = len(pntnam) + 1
    !
    ! First try to get the named pointer. 
    ! If mkcpnt /= 0 then the pointer already exists
    !
    mkcpnt = getptr(pntnam(:ind - 1))
    
    
    
    if (mkcpnt /= 0) then
       call chnull(chbuf(mkcpnt)         ,length    )
       mkcpnt = 1

    else
       !
       ! Call dynamic array declaration function MAKPTR for pointer name
       ! and required array length. Because length 0 is not permitted
       ! a minimum length of 1 is always given
       !
       mkcpnt = makptr(pntnam(:ind - 1), chtyp, max(1, length))
       if (mkcpnt==0) then
          call errpnt(pntnam, 'character', 'allocation', gdp)
          ! program is terminated in errpnt
       endif
       ! Initialize requested memory space
       call chnull(chbuf(mkcpnt)        ,length    )
       ! return the value 1 (used in Mor)
       mkcpnt = 1
    endif
end function mkcpnt
