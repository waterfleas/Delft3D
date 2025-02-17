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

C
C     dio-plt.inc
C
C     F77 Interface to
C     DelftIO Parameter-Location-Time Datasets
C
C     Stef.Hummel@deltares.nl
C
C     (c) Deltares, Feb 01
C---------------------------------------------
C
      include 'dio-streams.inc'
C
C     Sizes for character strings
C
      integer DioMaxDsNameLen
      integer DioMaxParLen
      integer DioMaxLocLen

      parameter ( DioMaxDsNameLen = 132 )
      parameter ( DioMaxParLen    = 80  )
      parameter ( DioMaxLocLen    = 132 )

      integer     HisRunIdSize      , HisRunIdDim
      parameter ( HisRunIdSize = 40 , HisRunIdDim = 4)
C
C     Dataset Types
C
      integer Dio_Plt_Unknown
      integer Dio_Plt_Integer
      integer Dio_Plt_Real
      integer Dio_Plt_Double
      integer Dio_Plt_Logical

      parameter ( Dio_Plt_Unknown  = 0 )
      parameter ( Dio_Plt_Integer  = 1 )
      parameter ( Dio_Plt_Real     = 2 )
      parameter ( Dio_Plt_Double   = 3 )
      parameter ( Dio_Plt_Logical  = 4 )
C
C     Function declarations
C
C     ORIGINAL interface (used by SRW)
C
      integer DioDefinePltDataSet
      integer DioGetPltDataSetInfo
      logical DioGetPltDataSetReals

      external DioDefinePltDataSet
      external DioGetPltDataSetInfo, DioGetPltDataSetReals
C
C     ODS Server interface
C
      integer  DiofPltDefine_1 , DiofPltDefine_2, DiofPltDefine_2a,
     +         DiofPltDefine_3 , DiofPltDefine_4, DiofPltDefine_4a,
     +         DiofPltDefine_5 , DiofPltDefine_5a
      external DiofPltDefine_1 , DiofPltDefine_2,
     +         DiofPltDefine_3 , DiofPltDefine_4, DiofPltDefine_4a,
     +         DiofPltDefine_5 , DiofPltDefine_5a

      integer  DiofPltDefine_11, DiofPltDefine_12, DiofPltDefine_12a,
     +         DiofPltDefine_13, DiofPltDefine_14, DiofPltDefine_14a
      external DiofPltDefine_11, DiofPltDefine_12, DiofPltDefine_12a,
     +         DiofPltDefine_13, DiofPltDefine_14, DiofPltDefine_14a

      integer  DiofPltGetDataSet
      external DiofPltGetDataSet

      integer  DiofPltGetNPars, DiofPltGetNLocs, DiofPltGetNTimes
      external DiofPltGetNPars, DiofPltGetNLocs, DiofPltGetNTimes

      logical  DiofPltGetPars, DiofPltGetLocs, DiofPltGetTimes
      external DiofPltGetPars, DiofPltGetLocs, DiofPltGetTimes

      logical  DiofPltGetHeaderLine, DiofPltGetIntIds
      external DiofPltGetHeaderLine, DiofPltGetIntIds

      logical  DiofPltGetNextFloats
      external DiofPltGetNextFloats

      logical  DiofPltGetNextDoubles
      external DiofPltGetNextDoubles

      logical  DiofPltGetSelectionFloats, DiofPltGetSelectionDoubles
      external DiofPltGetSelectionFloats, DiofPltGetSelectionDoubles

