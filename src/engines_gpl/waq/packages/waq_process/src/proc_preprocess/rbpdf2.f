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

      SUBROUTINE RBPDF2 ( LUPDEF, LUREP , NBPR  , NBPRM , BPRNAM,
     +                    BPRTXT, MODNAM, NSVAI , VAINAM, VAITXT,
     +                    VAIDEF, NSVAO , VAONAM, VAOTXT, NBFL  ,
     +                    BFLNAM, BFLTXT, NBST  , GENBST, FLXBST,
     +                    STOBST, VERSIO, SERIAL, IPVAI , IPVAO ,
     +                    IPBFL , IPBST , MAXVAI, MAXVAO, MAXBFL,
     +                    MAXBST, MAXVXI, NSVXI , IPVXI , VXINAM,
     +                    VXITXT, VXIDEF, MAXVXO, NSVXO , IPVXO ,
     +                    VXONAM, VXOTXT, MAXDST, NDST  , IPDST ,
     +                    GENDST, OUTDST, STODST, MAXVST, NVST  ,
     +                    IPVST , GENVST, OUTVST, STOVST, ISWITR,
     +                    NSVICH, NSVOCH, NFLCH , NSTCH )
!
!     Deltares     SECTOR WATERRESOURCES AND ENVIRONMENT
!
!     CREATED: nov -1992 by Jan van Beek
!
!     FUNCTION            : Reads the binary proces definition file
!
!     LOGICAL UNITNUMBERS : LUPDEF  - proces definition file
!                         : LUREP   - report file
!
!     SUBROUTINES CALLED  : SRSTOP, stops execution
!
!     PARAMETERS          :
!
!     NAME    KIND     LENGTH     FUNCT.  DESCRIPTION
!     ----    -----    ------     ------- -----------
!     LUPDEF  INTEGER       1     INPUT   Porces definition file
!     LUREP   INTEGER       1     INPUT   Report file
!     NBPR    INTEGER       1     OUTPUT  Number of processes in def file
!     NBPRM   INTEGER       1     INPUT   Max number of processes
!     BPRNAM  CHARACTER*(*) *     OUTPUT  Name of processes
!     BPRTXT  CHARACTER*(*) *     OUTPUT  Text of processes
!     MODNAM  CHARACTER*(*) *     OUTPUT  Name of module of processes
!     NSVAI   INTEGER       *     OUTPUT  No of input vars per proces
!     VAINAM  CHARACTER*(*) *     OUTPUT  Name of input variable
!     VAITXT  CHARACTER*(*) *     OUTPUT  Text of input variable
!     VAIDEF  REAL          *,*   OUTPUT  Default values input variables
!     NSVAO   INTEGER       *     OUTPUT  No of output vars per proces
!     VAONAM  CHARACTER*(*) *     OUTPUT  Name of input variable
!     VAOTXT  CHARACTER*(*) *     OUTPUT  Text of output variable
!     NBFL    INTEGER       *     OUTPUT  No of basic fluxes per proces
!     BFLNAM  CHARACTER*(*) *     OUTPUT  Name of basix fluxe
!     BFLTXT  CHARACTER*(*) *     OUTPUT  Text of basix fluxe
!     NBST    INTEGER       *     OUTPUT  No of basic stochis per proces
!     GENBST  CHARACTER*(*) *,*   OUTPUT  Name of substance in stochi
!     FLXBST  CHARACTER*(*) *,*   OUTPUT  Name of flux in stochi
!     STOBST  REAL          *,*   OUTPUT  Stochimetric factor
!     IPVAI   INTEGER       *     OUTPUT  Pointers for arrays on VAI
!     IPVAO   INTEGER       *     OUTPUT  Pointers for arrays on VAO
!     IPBFL   INTEGER       *     OUTPUT  Pointers for arrays on BFL
!     IPBST   INTEGER       *     OUTPUT  Pointers for arrays on BST
!     MAXVAI  INTEGER       1     INPUT   Maximum number of input vars
!     MAXVAO  INTEGER       1     INPUT   Maximum number of output vars
!     MAXBFL  INTEGER       1     INPUT   Maximum number of fluxes
!     MAXBST  INTEGER       1     INPUT   Maximum number of stochio's
!     MAXVXI  INTEGER       1     INPUT   Maximum number of input x vars
!     NSVXI   INTEGER       *     OUTPUT  No of input vars X per proces
!     IPVXI   INTEGER       *     OUTPUT  Pointers for arrays on VXI
!     VXINAM  CHARACTER*(*) *     OUTPUT  Name of input variable X
!     VXITXT  CHARACTER*(*) *     OUTPUT  Text of input variable X
!     VXIDEF  REAL          *     OUTPUT  Default values input X variables
!     MAXVXO  INTEGER       1     INPUT   Maximum number of output x vars
!     NSVXO   INTEGER       *     OUTPUT  No of output vars X per proces
!     IPVXO   INTEGER       *     OUTPUT  Pointers for arrays on VXO
!     VXONAM  CHARACTER*(*) *     OUTPUT  Name of output variable X
!     VXOTXT  CHARACTER*(*) *     OUTPUT  Text of output variable X
!     MAXDST  INTEGER       1     INPUT   Max. number of dispersion rules
!     NSDST   INTEGER       *     OUTPUT  No of dispersion rules p.proces
!     IPDST   INTEGER       *     OUTPUT  Pointers for arrays on DST
!     GENDST  CHARACTER*(*) *     OUTPUT  Name of substance in disp rule
!     OUTDST  CHARACTER*(*) *     OUTPUT  Name of output item in disp rule
!     STOVST  REAL          *     OUTPUT  factor in dispersion rule
!     MAXVST  INTEGER       1     INPUT   Max. number of velocity rules
!     NSVST   INTEGER       *     OUTPUT  No of velocity rules p.proces
!     IPVST   INTEGER       *     OUTPUT  Pointers for arrays on VST
!     GENVST  CHARACTER*(*) *     OUTPUT  Name of substance in velo rule
!     OUTVST  CHARACTER*(*) *     OUTPUT  Name of output item in velo rule
!     STOVST  REAL          *     OUTPUT  factor in velocity rule
!     ISWITR  INTEGER       *     OUTPUT  Target dimension indicator
!     NSVICH  INTEGER       1     INPUT   No of extra input variables for charon
!     NSVOCH  INTEGER       1     INPUT   No of extra output variables for charon
!     NFLCH   INTEGER       1     INPUT   No of fluxes for charon
!     NSTCH   INTEGER       1     INPUT   No of stochiometric terms for charon
!
!     Declaration of arguments
!

      use timers       !   performance timers

      INTEGER        LUPDEF          , LUREP           ,
     +               NBPR            , NBPRM           ,
     +               SERIAL          , MAXVAI          ,
     +               MAXVAO          , MAXBFL          ,
     +               MAXBST          , NSVICH          ,
     +               NSVOCH          , NFLCH           ,
     +               NSTCH
      INTEGER        NSVAI(*)        , NSVAO(*)        ,
     +               NBFL(*)         , NBST(*)         ,
     +               IPVAI(*)        , IPVAO(*)        ,
     +               IPBFL(*)        , IPBST(*)        ,
     +               NSVXI(*)        , IPVXI(*)        ,
     +               NSVXO(*)        , IPVXO(*)        ,
     +               NDST(*)         , IPDST(*)        ,
     +               NVST(*)         , IPVST(*)        ,
     +               ISWITR(*)
      REAL           VERSIO
      REAL           VAIDEF(*)       , STOBST(*)       ,
     +               VXIDEF(*)       , STODST(*)       ,
     +               STOVST(*)
      CHARACTER*(*)  BPRNAM(*)       , MODNAM(*)       ,
     +               VAINAM(*)       , VAONAM(*)       ,
     +               BFLNAM(*)       , GENBST(*)       ,
     +               FLXBST(*)       , VXINAM(*)       ,
     +               VXONAM(*)       , GENDST(*)       ,
     +               OUTDST(*)       , GENVST(*)       ,
     +               OUTVST(*)
      CHARACTER*(*)  BPRTXT(*)       , VAITXT(*)       ,
     +               VAOTXT(*)       , BFLTXT(*)       ,
     +               VXITXT(*)       , VXOTXT(*)
!
!     Local
!
      INTEGER        NSV   , NFL   , NST
      LOGICAL        CHARON
      integer(4) :: ithndl = 0
      if (timon) call timstrt( "rdpdf2", ithndl )
!
!     Read version number and serial number
!
      READ ( LUPDEF ) VERSIO, SERIAL
!
!     Read NBPR  number of proces modules
!
      READ ( LUPDEF ) NBPR
      IF ( NBPR  .LE. 0 .OR. NBPR  .GT. NBPRM  ) THEN
         WRITE ( LUREP,* ) ' ERROR : Reading proces definition file'
         WRITE ( LUREP,* ) '         wrong number of processes',NBPR
         CALL SRSTOP(1)
      ENDIF
!
!     Read name , input vars, output vars and fluxes
!
      IIVAI = 1
      IIVXI = 1
      IIVAO = 1
      IIVXO = 1
      IIBFL = 1
      IIBST = 1
      IIDST = 1
      IIVST = 1
!
      DO 700 IP = 1 , NBPR
!
!        Read proces naam , module name
!
         READ ( LUPDEF ) BPRNAM(IP),BPRTXT(IP)
         READ ( LUPDEF ) MODNAM(IP)
         IF ( MODNAM(IP) .EQ. 'D40CHA' ) THEN
            CHARON = .TRUE.
         ELSE
            CHARON = .FALSE.
         ENDIF
!
!        Read the xD target dimension indicator
!
         READ ( LUPDEF ) ISWITR(IP)
!
!        Read input variables VAI with defaults
!
         READ ( LUPDEF ) NSV
         IF ( CHARON ) THEN
            NSVAI(IP) = NSV + NSVICH
            IPVAI(IP) = IIVAI
            IIVAI     = IIVAI + NSV + NSVICH
         ELSE
            NSVAI(IP) = NSV
            IPVAI(IP) = IIVAI
            IIVAI     = IIVAI + NSV
         ENDIF
         IF ( IIVAI .GT. MAXVAI ) THEN
            WRITE (LUREP,*) ' ERROR : Reading proces definition file'
            WRITE (LUREP,*) '         total number of input variables'
            WRITE (LUREP,*) '         exceed maximum:,',MAXVAI
            CALL SRSTOP(1)
         ENDIF
         DO 100 IV = 1 , NSV
            IPV = IPVAI(IP) + IV - 1
            READ ( LUPDEF )
     +           VAINAM(IPV), VAIDEF(IPV),VAITXT(IPV)
  100    CONTINUE
!
!        Read input variables VXI with defaults
!
         READ ( LUPDEF ) NSV
         NSVXI(IP) = NSV
         IPVXI(IP) = IIVXI
         IIVXI     = IIVXI + NSV
         IF ( IIVXI .GT. MAXVXI ) THEN
            WRITE (LUREP,*) ' ERROR : Reading proces definition file'
            WRITE (LUREP,*) '         total number of input X variables'
            WRITE (LUREP,*) '         exceed maximum:,',MAXVXI
            CALL SRSTOP(1)
         ENDIF
         DO 150 IV = 1 , NSV
            IPV = IPVXI(IP) + IV - 1
            READ ( LUPDEF )
     +           VXINAM(IPV), VXIDEF(IPV),VXITXT(IPV)
  150    CONTINUE
!
!        Read output variables VAO
!
         READ ( LUPDEF ) NSV
         IF ( CHARON ) THEN
            NSVAO(IP) = NSV + NSVOCH
            IPVAO(IP) = IIVAO
            IIVAO     = IIVAO + NSV + NSVOCH
         ELSE
            NSVAO(IP) = NSV
            IPVAO(IP) = IIVAO
            IIVAO     = IIVAO + NSV
         ENDIF
         IF ( IIVAO .GT. MAXVAO ) THEN
            WRITE (LUREP,*) ' ERROR : Reading proces definition file'
            WRITE (LUREP,*) '         total number of output variables'
            WRITE (LUREP,*) '         exceed maximum:,',MAXVAO
            CALL SRSTOP(1)
         ENDIF
         DO 200 IVAO = 1 , NSV
            IPV = IPVAO(IP) + IVAO - 1
            READ ( LUPDEF )
     +           VAONAM(IPV),VAOTXT(IPV)
  200    CONTINUE
!
!        Read output variables VXO
!
         READ ( LUPDEF ) NSV
         NSVXO(IP) = NSV
         IPVXO(IP) = IIVXO
         IIVXO     = IIVXO + NSV
         IF ( IIVXO .GT. MAXVXO ) THEN
            WRITE (LUREP,*) ' ERROR : Reading proces definition file'
            WRITE (LUREP,*) '         total number of outputX variables'
            WRITE (LUREP,*) '         exceed maximum:,',MAXVXO
            CALL SRSTOP(1)
         ENDIF
         DO 250 IVAO = 1 , NSV
            IPV = IPVXO(IP) + IVAO - 1
            READ ( LUPDEF )
     +           VXONAM(IPV),VXOTXT(IPV)
  250    CONTINUE
!
!        Read basis fluxes  BFL
!
         READ ( LUPDEF ) NFL
         IF ( CHARON ) THEN
            NBFL(IP) = NFL + NFLCH
            IPBFL(IP) = IIBFL
            IIBFL     = IIBFL + NFL + NFLCH
         ELSE
            NBFL(IP) = NFL
            IPBFL(IP) = IIBFL
            IIBFL     = IIBFL + NFL
         ENDIF
         IF ( IIBFL .GT. MAXBFL ) THEN
            WRITE (LUREP,*) ' ERROR : Reading proces definition file'
            WRITE (LUREP,*) '         total number of fluxes'
            WRITE (LUREP,*) '         exceed maximum:,',MAXBFL
            CALL SRSTOP(1)
         ENDIF
         DO 300 IFLX = 1 , NFL
            IPV = IPBFL(IP) + IFLX - 1
            READ ( LUPDEF )
     +             BFLNAM(IPV),BFLTXT(IPV)
  300    CONTINUE
!
!        Read basis stochiometry  BST
!
         READ ( LUPDEF ) NST
         IF ( CHARON ) THEN
            NBST(IP) = NST + NSTCH
            IPBST(IP) = IIBST
            IIBST     = IIBST + NST + NSTCH
         ELSE
            NBST(IP) = NST
            IPBST(IP) = IIBST
            IIBST     = IIBST + NST
         ENDIF
         IF ( IIBST .GT. MAXBST ) THEN
            WRITE (LUREP,*) ' ERROR : Reading proces definition file'
            WRITE (LUREP,*) '         total number of stochio terms'
            WRITE (LUREP,*) '         exceed maximum:,',MAXBST
            CALL SRSTOP(1)
         ENDIF
         DO 400 IST = 1 , NST
            IPV = IPBST(IP) + IST - 1
            READ ( LUPDEF ) GENBST(IPV), FLXBST(IPV),
     +                      STOBST(IPV)
  400    CONTINUE
!
!        Read basis dispersion rules
!
         READ ( LUPDEF ) NST
         NDST(IP) = NST
         IPDST(IP) = IIDST
         IIDST     = IIDST + NST
         IF ( IIDST .GT. MAXDST ) THEN
            WRITE (LUREP,*) ' ERROR : Reading proces definition file'
            WRITE (LUREP,*) '         total number of dispersion rules'
            WRITE (LUREP,*) '         exceed maximum:,',MAXDST
            CALL SRSTOP(1)
         ENDIF
         DO 500 IST = 1 , NST
            IPV = IPDST(IP) + IST - 1
            READ ( LUPDEF ) GENDST(IPV), OUTDST(IPV),
     +                      STODST(IPV)
  500    CONTINUE
!
!        Read basis velocity rules
!
         READ ( LUPDEF ) NST
         NVST(IP) = NST
         IPVST(IP) = IIVST
         IIVST     = IIVST + NST
         IF ( IIVST .GT. MAXVST ) THEN
            WRITE (LUREP,*) ' ERROR : Reading proces definition file'
            WRITE (LUREP,*) '         total number of velocity rules'
            WRITE (LUREP,*) '         exceed maximum:,',MAXVST
            CALL SRSTOP(1)
         ENDIF
         DO 600 IST = 1 , NST
            IPV = IPVST(IP) + IST - 1
            READ ( LUPDEF ) GENVST(IPV), OUTVST(IPV),
     +                      STOVST(IPV)
  600    CONTINUE
!
  700 CONTINUE
!
      if (timon) call timstop( ithndl )
      RETURN
      END
