      SUBROUTINE SELDEP (TSOIL,HSOIL,ZSOIL,RELHUM,PSOIL)

C     NICHEMAPR: SOFTWARE FOR BIOPHYSICAL MECHANISTIC NICHE MODELLING

C     COPYRIGHT (C) 2018 MICHAEL R. KEARNEY AND WARREN P. PORTER

C     THIS PROGRAM IS FREE SOFTWARE: YOU CAN REDISTRIBUTE IT AND/OR MODIFY
C     IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
C     THE FREE SOFTWARE FOUNDATION, EITHER VERSION 3 OF THE LICENSE, OR (AT
C      YOUR OPTION) ANY LATER VERSION.

C     THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
C     WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
C     MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
C     GENERAL PUBLIC LICENSE FOR MORE DETAILS.

C     YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
C     ALONG WITH THIS PROGRAM. IF NOT, SEE HTTP://WWW.GNU.ORG/LICENSES/.

C     IF AN ECTOTHERM HAS TO BE BELOW GROUND,THIS SUBROUTINE FINDS THE
C     DEPTH IN THE SOIL WHERE IT CAN BE WITHIN TOLERABLE TEMPERATURES

      IMPLICIT NONE

      DOUBLE PRECISION AL,ALT,ANDENS,ASILP,BP,CTMAX,CTMIN,DEPSUB,EMISSB
      DOUBLE PRECISION EMISSK,FLUID,G,H2O_BALPAST,HRN,HSOIL,MAXTEMP
      DOUBLE PRECISION MICRO,NEWDEP,POND_DEPTH,PTCOND,PTCOND_ORIG,QSOL
      DOUBLE PRECISION QSOLR,R,RELHUM,RH,RHREF,SUBTK,TA,TALOC,TANNUL
      DOUBLE PRECISION TBASK,TC,TDIGPR,TEMERGE,TIME,TMAXPR,TMINPR,TOBJ
      DOUBLE PRECISION TPREF,TR,TREF,TSKIN,TSKY,TSKYC,TSMAX,TSMIN,TSOIL
      DOUBLE PRECISION TSUB,TSUBST,TWATER,VEL,VLOC,VREF,WEVAP,Z,ZMAX
      DOUBLE PRECISION ZMIN,ZSOIL,PSOIL


      INTEGER AQUATIC,CTKILL,CTMINCUM,CTMINTHRESH,FEEDING,GOODSOIL,I
      INTEGER IDEP,IHOUR,INWATER,IYEAR,MINNODE,NN,NON,NYEAR,BURROWTMP
      INTEGER BURROWWTR,MINWETNODE,MWNODE


      DIMENSION HRN(25),HSOIL(25),QSOL(25),RH(25),RHREF(25),TALOC(25)
      DIMENSION TIME(25),TREF(25),TSKYC(25),TSOIL(10),TSUB(25),VLOC(25)
      DIMENSION VREF(25),Z(25),ZSOIL(10),PSOIL(10)

C     NEED NON, # OF SOIL NODES,
      COMMON/BUR/NON,MINNODE,BURROWTMP
      COMMON/CTMAXMIN/CTMAX,CTMIN,CTMINCUM,CTMINTHRESH,CTKILL
      COMMON/DAYSTORUN/NN
      COMMON/ENVAR1/QSOL,RH,TSKYC,TIME,TALOC,TREF,RHREF,HRN
      COMMON/ENVAR2/TSUB,VREF,Z,TANNUL,VLOC
      COMMON/FUN3/AL,TA,VEL,PTCOND,SUBTK,DEPSUB,TSUBST,PTCOND_ORIG
      COMMON/FUN4/TSKIN,R,WEVAP,TR,ALT,BP,H2O_BALPAST
      COMMON/GOODSOIL/GOODSOIL
      COMMON/PONDDATA/INWATER,AQUATIC,TWATER,POND_DEPTH,FEEDING
      COMMON/REPYEAR/IYEAR,NYEAR
      COMMON/TPREFR/TMAXPR,TMINPR,TDIGPR,TPREF,TBASK,TEMERGE
      COMMON/TREG/TC
      COMMON/WDSUB1/ANDENS,ASILP,EMISSB,EMISSK,FLUID,G,IHOUR
      COMMON/WDSUB2/QSOLR,TOBJ,TSKY,MICRO
      COMMON/WUNDRG/NEWDEP

      IF(GOODSOIL.EQ.1)THEN
       TA=TA-0.5
       GOTO 999
      ENDIF

      GOODSOIL = 0

C     INITIALIZING FOR FINDING SOIL TEMPERATURE MAXIMUM,MINIMUM & CORRESPONDING DEPTHS
      TSMAX=TSOIL(MINNODE)
      ZMAX=ZSOIL(MINNODE)
      TSMIN=TSOIL(MINNODE)
      ZMIN=ZSOIL(MINNODE)
      DO 1 I=MINNODE,NON
       IF(TSOIL(I).GT.TSMAX)THEN
        TSMAX = TSOIL(I)
        ZMAX = ZSOIL(I)
       ELSE
        IF(TSOIL(I).LT.TSMIN)THEN
         TSMIN = TSOIL(I)
         ZMIN = ZSOIL(I)
        ENDIF
       ENDIF
1     CONTINUE

      DO 13 IDEP=MINNODE,NON
C     normal behavior in NicheMapR
       IF((BURROWTMP.EQ.0).AND.(BURROWWTR.EQ.0))THEN
        MAXTEMP=(CTMAX-(CTMAX-TMAXPR)/2.)
        IF((TSOIL(IDEP).GT.CTMIN).AND.(TSOIL(IDEP).LT.MAXTEMP))THEN
          TA = TSOIL(IDEP)
          RELHUM = HSOIL(IDEP)*100.
          NEWDEP = ZSOIL(IDEP)
          GO TO 999
        ENDIF
C     energy conservation: selecting low temperatures (between CTmin and Temerge)
       ELSE IF((BURROWTMP.EQ.1).AND.(BURROWWTR.EQ.0))THEN
        IF((TSOIL(IDEP).GT.CTMIN).AND.(TSOIL(IDEP).LE.TEMERGE))THEN
          TA = TSOIL(IDEP)
          RELHUM = HSOIL(IDEP)*100.
          NEWDEP = ZSOIL(IDEP)
          GO TO 999
        ENDIF
C     optimum performance strategy (between Temerge and Tpref)
       ELSE IF((BURROWTMP.EQ.2).AND.(BURROWWTR.EQ.0))THEN
        IF((TSOIL(IDEP).GT.TEMERGE).AND.(TSOIL(IDEP).LE.TPREF))THEN
          TA = TSOIL(IDEP)
          RELHUM = HSOIL(IDEP)*100.
          NEWDEP = ZSOIL(IDEP)
          GO TO 999
        ENDIF
       ENDIF
13     CONTINUE

      IF(NON.EQ.10)THEN
       TA=TANNUL
       RELHUM=HSOIL(NON)*100.
       NEWDEP=200.
      ELSE
       TA=TSOIL(NON)
       RELHUM=HSOIL(NON)*100.
       NEWDEP=ZSOIL(NON)
      ENDIF
      GOTO 999


999   CONTINUE
C     SET UP UNDERGROUND CLIMATE CONDITIONS
      CALL BELOWGROUND
      CALL RADIN
      IF(TA.GT.99)THEN
       TA=TA
      ENDIF

      RETURN
      END
