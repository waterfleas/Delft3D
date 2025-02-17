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

      SUBROUTINE DHC20M ( CARRA1 , CARRA2 , NOTOT )
!
!     Deltares     SECTOR WATERRESOURCES AND ENVIRONMENT
!
!     CREATED             : march 1998 by Jan van Beek
!
!     FUNCTION            : moves NOTOT values from character*20 array
!                           CARRA1 to CARRA2
!
!     PARAMETERS          :
!
!     NAME    KIND     LENGTH     FUNCT.  DESCRIPTION
!     ----    -----    ------     ------- -----------
!     CARRA1  CH*(*)    NOTOT     INPUT   array to be copied
!     CARRA2  CH*(*)    NOTOT     OUTPUT  array to copy to
!     NOTOT   INTEGER     1       INPUT   total number of entries
!
      INTEGER       NOTOT
      CHARACTER*20  CARRA1(*) , CARRA2(*)
!
      DO I = 1,NOTOT
         CARRA2(I) = CARRA1(I)
      ENDDO
!
      RETURN
      END
