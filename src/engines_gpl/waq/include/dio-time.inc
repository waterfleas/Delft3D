!!  Copyright (C)  Stichting Deltares, 2012-2021.
!!
!!  This program is free software: you can redistribute it and/or modify
!!  it under the terms of the GNU General Public License version 3,
!!  as published by the Free Software Foundation.
!!
!!  This program is distributed in the hope that it will be useful,
!!  but WITHOUT ANY WARRANTY; without even the implied warranty of
!!  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
!!  GNU General Public License for more details.
!!
!!  You should have received a copy of the GNU General Public License
!!  along with this program. If not, see <http://www.gnu.org/licenses/>.
!!
!!  contact: delft3d.support@deltares.nl
!!  Stichting Deltares
!!  P.O. Box 177
!!  2600 MH Delft, The Netherlands
!!
!!  All indications and logos of, and references to registered trademarks
!!  of Stichting Deltares remain the property of Stichting Deltares. All
!!  rights reserved.

!
!     dio-time.inc
!
!     F77 Interface to
!     DelftIO Time Functions
!
!     Stef.Hummel@deltares.nl
!
!     (c) Deltares, Oct 02
!---------------------------------------------
!
!     Function declarations
!
      integer     DioMaxTimLen
      parameter ( DioMaxTimLen    = 25  )

      double precision  DiofTimeString2Julian
      external          DiofTimeString2Julian

      character*(DioMaxTimLen) DiofJulian2DioTime
      external                 DiofJulian2DioTime

