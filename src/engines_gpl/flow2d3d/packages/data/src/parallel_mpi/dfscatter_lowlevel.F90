#ifdef HAVE_CONFIG_H
#include "config.h"
#endif
subroutine dfscatter_lowlevel ( iiptr, iilen, ioptr, iolen, itype, gdp )
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
!  $Id: dfscatter_lowlevel.F90 68181 2021-01-20 13:41:21Z leander $
!  $HeadURL: https://svn.oss.deltares.nl/repos/delft3d/tags/delft3d4/69179/src/engines_gpl/flow2d3d/packages/data/src/parallel_mpi/dfscatter_lowlevel.F90 $
!!--description-----------------------------------------------------------------
!
!   Scatters different amounts of data from the master to each processor
!
!!--pseudo code and references--------------------------------------------------
!
!   gather the array sizes to the master
!   calculate starting address of each local array with respect to the global array
!   scatter different amounts of data from the master to each processor
!
!!--declarations----------------------------------------------------------------
#ifdef HAVE_MPI
    use mpi
#endif
    use dfparall
    use globaldata
    !
    implicit none
    !
    type(globdat), target:: gdp
!
! Global variables
!
    integer, intent(in)  :: iilen ! length of input array
    integer, intent(in)  :: iiptr ! pointer to first element of input array (local)
    integer, intent(in)  :: iolen ! length of output array
    integer, intent(out) :: ioptr ! pointer to first element of output array (global)
    integer, intent(in)  :: itype ! type of data
!
! Local variables
!
    integer, pointer                   :: lundia
    integer                            :: i      ! loop counter
    integer, dimension(:), allocatable :: icount ! array specifying array size of data received from each processor
    integer, dimension(:), allocatable :: idsplc ! array specifying the starting address of the incoming data from
                                                 ! each processor, relative to the global array
    integer                            :: ierr   ! error value of MPI call
    character(80)                      :: msgstr ! string to pass message
!
!! executable statements -------------------------------------------------------
!
    lundia => gdp%gdinout%lundia
    !
    ! if not parallel, return
    !
    if (.not.parll) return

    if (inode == master) then
       allocate(icount(0:nproc-1))
       allocate(idsplc(0:nproc-1))
       icount = 0
    else
       allocate(icount(1))
       allocate(idsplc(1))
    endif
    !
    ! gather the array sizes to the master
    !
#ifdef HAVE_MPI
    call mpi_gather( iolen, 1, dfint, icount, 1, dfint, master-1, engine_comm_world, ierr )
    if ( ierr /= MPI_SUCCESS ) then
       write (msgstr,'(a,i5)') 'MPI produces some internal error - return code is ',ierr
       call prterr(lundia, 'U021', trim(msgstr))
       call d3stop(1, gdp)
    endif
#endif
    !
    ! calculate starting address of each local array with respect to the global array
    !
    if (inode == master) then
       idsplc(0) = 0
       do i = 1, nproc-1
          idsplc(i) = icount(i-1) + idsplc(i-1)
       enddo
    endif
    !
    ! scatter different amounts of data from the master to each processor
    !
#ifdef HAVE_MPI
    call mpi_scatterv( iiptr, icount, idsplc, itype, ioptr, iolen, itype, master-1, engine_comm_world, ierr )
    if ( ierr /= MPI_SUCCESS ) then
       write (msgstr,'(a,i5)') 'MPI produces some internal error - return code is ',ierr
       call prterr(lundia, 'U021', trim(msgstr))
       call d3stop(1, gdp)
    endif
#endif

    deallocate(icount,idsplc)

end subroutine dfscatter_lowlevel
