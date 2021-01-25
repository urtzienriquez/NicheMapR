      PROGRAM NICHEMAPR

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

C     THIS ACTS AS THE MAIN PROGRAM FOR RUNNING THE ECTOTHERM MODEL OUTSIDE OF
C     R - IT READS IN THE INPUT FILES GENERATED BY RUNNING THE R VERSION WITH
C     THE FLAG 'WRITE_INPUT' SET TO VALUE 1. CAN BE USED FOR PROGRAM DEVELOPMENT
C     AND DEBUGGING

      USE AACOMMONDAT
      IMPLICIT NONE

      DOUBLE PRECISION, DIMENSION(:,:), ALLOCATABLE :: ENVIRON2,ENBAL2
     & ,MASBAL2,DEBOUT2,METOUT2,SHADMET2,SOIL2,SHADSOIL2,SOILMOIST2,
     &SHADMOIST2,SOILPOT2,SHADPOT2,HUMID2,SHADHUMID2,YEARSOUT2,GLMTEMP2,
     &GLMO22,GLMSALT2,GLMPH2,GLMFOOD2,THERMAL_STAGES2,NUTRI_STAGES2,
     &BEHAV_STAGES2,WATER_STAGES2,ARRHENIUS3,ARRHENIUS32
      DOUBLE PRECISION, DIMENSION(:), ALLOCATABLE :: RAINFALL3,RAINHR2,
     & WETLANDDEPTHS2,WETLANDTEMPS2,FOODWATERS2,FOODLEVELS2,MAXSHADES2,
     &S_INSTAR2,MINSHADES2

      DOUBLE PRECISION A1,A2,A3,A4,A4B,A5,A6,AAIR,ABSAN,ABSMAX,ABSMIN
      DOUBLE PRECISION ABSSB,ACTHR,ADIS,AEFF,AEIN,AEVP,AFOD,AHEIT,AHRS
      DOUBLE PRECISION AIRVOL,AL,ALENTH,ALT,AMASS,AMET,ANDENS,ANDENS_DEB
      DOUBLE PRECISION ANNFOOD,ANNUALACT,ANRG,AREA,AREF,ASIL,ASILN,ASILP
      DOUBLE PRECISION ATOT,AWIDTH,AWIN,AWTR,BP,BREEDRAINTHRESH,BREF
      DOUBLE PRECISION CLUTCHA,CLUTCHB,CLUTCHES,CLUTCHSIZE,CO2FLUX
      DOUBLE PRECISION CO2GAS,CO2MOL,CONTDEP,CONTDEPTH,CONTH,CONTHOLE
      DOUBLE PRECISION CONTVOL,CONTW,CONTWET,CONVAR,CREF,CTMAX,CTMIN
      DOUBLE PRECISION CUMBATCH,CUMBATCH_INIT,CUMREPRO,CUMREPRO_INIT
      DOUBLE PRECISION CUSTOMGEOM,CUTFA,D_V,DAIR,DAJABS,DAMT,DAVP,DAWTR
      DOUBLE PRECISION DAYAIR,DAYEIN,DAYEVP,DAYLENGTHFINISH
      DOUBLE PRECISION DAYLENGTHSTART,DAYMET,DAYNRG,DAYWIN,DAYWTR,DCO2
      DOUBLE PRECISION DEBLAST2,DEBMOD2,DEBQMET,DEBQMET_INIT,DEIN
      DOUBLE PRECISION DELTA_DEB,DELTAR,DEP2,DEPSEL,DEPSUB,DEVP,DMET
      DOUBLE PRECISION DNRG,DRYFOOD,DSHD,DTIME,DWIN,DWTR,E_BABY
      DOUBLE PRECISION E_BABY_INIT,E_BABY1,E_EGG,E_G,E_H,E_H_INIT
      DOUBLE PRECISION E_H_START,E_HB,E_HE,E_HJ,E_HP,E_HPUP,E_HPUP_INIT
      DOUBLE PRECISION E_INIT,E_INIT_BABY,ECTOINPUT2,ED
      DOUBLE PRECISION EGGDRYFRAC,EH_BABY
      DOUBLE PRECISION EH_BABY_INIT,EH_BABY1,EMISAN,EMISSB,EMISSK,ENARY1
      DOUBLE PRECISION ENARY10,ENARY11,ENARY12,ENARY13,ENARY14,ENARY15
      DOUBLE PRECISION ENARY16,ENARY17,ENARY18,ENARY19,ENARY2,ENARY20
      DOUBLE PRECISION ENARY21,ENARY22,ENARY23,ENARY24,ENARY25,ENARY26
      DOUBLE PRECISION ENARY27,ENARY28,ENARY29,ENARY3,ENARY30,ENARY31
      DOUBLE PRECISION ENARY32,ENARY33,ENARY34,ENARY35,ENARY36,ENARY37
      DOUBLE PRECISION ENARY38,ENARY39,ENARY4,ENARY40,ENARY41,ENARY42
      DOUBLE PRECISION ENARY43,ENARY44,ENARY45,ENARY46,ENARY47,ENARY48
      DOUBLE PRECISION ENARY5,ENARY6,ENARY7,ENARY8,ENARY9,ENB,ENBERR
      DOUBLE PRECISION EPUP,EPUP_INIT,ES,ES_INIT,ESM,ETAO,EXTREF,F12,F13
      DOUBLE PRECISION F14,F15,F16,F21,F23,F24,F25,F26,F31,F32,F41,F42
      DOUBLE PRECISION F51,F52,F61,FAECES,FATCOND,FATOBJ,FATOSB,FATOSK
      DOUBLE PRECISION FECUNDITY,FLSHCOND,FLTYPE,FLUID,FOOD,FOODLIM
      DOUBLE PRECISION FOODWATERCUR,FUNCT,G,GEVAP,GH2OMET,GH2OMET_INIT
      DOUBLE PRECISION GUTFILL,GUTFREEMASS,GUTFULL,H_AREF
      DOUBLE PRECISION H2O_BALPAST,HALFSAT,HC,HD,HDFORC,HDFREE,HRN,HS
      DOUBLE PRECISION HS_INIT,HSHSOI,HSOIL,JM_JO,K_JREF,KAP_R,KAP_X
      DOUBLE PRECISION KAP_X_P,KAPPA,L_B,L_J,L_W,L_WREPRO,LAMBDA,LAT
      DOUBLE PRECISION LENGTHDAY,LENGTHDAYDIR,LONGEV,MAXMASS,MAXSHD
      DOUBLE PRECISION MINCLUTCH,MINED,MLO2,MLO2_INIT,MONMATURE,MONREPRO
      DOUBLE PRECISION MR_1,MR_2,MR_3,MSHSOI,MSOIL,MU_E,MU_P,MU_V,MU_X
      DOUBLE PRECISION N2GAS,NEWCLUTCH,NEWDEP,NWASTE,O2FLUX,O2GAS
      DOUBLE PRECISION ORIG_CLUTCHSIZE,ORIG_ESM,P_B_PAST,P_MREF
      DOUBLE PRECISION P_XMREF,PAS,PBS,PCS,PDS,PGS,PJS,PMS,PRS,PANT
      DOUBLE PRECISION PANTMAX,PDIF,PEYES,PFEWAT,PHI
      DOUBLE PRECISION PHIMAX,PHIMIN,PMOUTH,POTFREEMASS,PREVDAYLENGTH
      DOUBLE PRECISION PSHSOI,PSOIL,PTCOND,PTCOND_ORIG,Q,Q_INIT,QCOND
      DOUBLE PRECISION QCONV,QIRIN,QIROUT,QMETAB,QRESP,QSEVAP,QSOL
      DOUBLE PRECISION QSOLAR,QSOLR,R,R1,RAINDRINK,RAINFALL,RAINMULT
      DOUBLE PRECISION REFSHD,RELHUM,REPRO,RH,RHO1_3,RHREF,RINSUL,RQ,S_G
      DOUBLE PRECISION S_J,SHADE,SHP,SIDEX,SIG,SKINT,SKINW,SPHEAT,STAGE
      DOUBLE PRECISION SUBTK,SURVIV,SURVIV_INIT,T_A,T_A2,T_AH,T_AH2,T_AL
      DOUBLE PRECISION T_AL2,T_H,T_H2,T_L,T_L2,T_REF,TA,TALOC
      DOUBLE PRECISION TANNUL,TBASK,TC,TCINIT,TCORES
      DOUBLE PRECISION TDIGPR,TEIN,TEMERGE,TEVP,TIME,TLUNG,TMAXPR,TMET
      DOUBLE PRECISION TMINPR,TNRG,TOBJ,TPREF,TPRINT,TQSOL,TR,TRANS1
      DOUBLE PRECISION TRANSAR,TREF,TSHLOW,TSHOIL,TSHSKI,TSHSOI,TSKIN
      DOUBLE PRECISION TSKY,TSKYC,TSOIL,TSOILS,TSUB,TSUBST,TWIN,TWING
      DOUBLE PRECISION TWTR,V,V_BABY,V_BABY_INIT,V_BABY1,V_INIT
      DOUBLE PRECISION V_INIT_BABY,VDOTREF,VEL,VLOC,VOL,VOLD,VOLD_INIT
      DOUBLE PRECISION VPUP,VPUP_INIT,VREF,W_E,W_N,W_P,W_V,W_X,WC,WCUT
      DOUBLE PRECISION WETFOOD,WETGONAD,WETMASS,WETSTORAGE,WEVAP,WEYES
      DOUBLE PRECISION WQSOL,WRESP,X_FOOD,XTRY,Y_EV_L,YEAROUT2,Z,ZEN
      DOUBLE PRECISION ZFACT,ZSOIL

      INTEGER AQUABREED,AQUASTAGE,BATCH,BREEDACT,BREEDACTTHRES,BREEDING
      INTEGER BREEDVECT,CENSUS,COMPLETE,COMPLETION,CONTONLY,CONTYPE
      INTEGER COUNTDAY,CTKILL,CTMINCUM,CTMINTHRESH,DAYCOUNT,DEAD,DEADEAD
      INTEGER DEB1,DOY,GEOMETRY,GOODSOIL,I,IDAY,IHOUR,INTNUM,IT,IYEAR,J
      INTEGER JP,LIVE,METAB_MODE,METAMORPH,MICRO,MINNODE,NM,NN3,NODNUM
      INTEGER NON,NS3,NYEAR,PHOTODIRF,PHOTODIRS,PHOTOFINISH,PHOTOSTART
      INTEGER PREGNANT,RESET,SCENAR,SOILNODE,STAGES,STARTDAY,TRANCT
      INTEGER VIVIPAROUS,WETMOD,WINGCALC,WINGMOD
      INTEGER RAINHOUR,BURROWTMP,BURROWWTR

      CHARACTER*130 LABEL
      CHARACTER*1 BURROW,DAYACT,CLIMB,CKGRSHAD,CREPUS,FOSORIAL,RAINACT
      CHARACTER*1 NOCTURN,TRANST

      DIMENSION BREEDVECT(24),CUMBATCH(24),CUMREPRO(24),CUSTOMGEOM(8)
      DIMENSION DEBLAST2(13),DEBMOD2(94),DEBQMET(24),DEP2(10),DEPSEL(25)
      DIMENSION DRYFOOD(24),E_BABY1(24),E_H(24),E_HPUP(24)
      DIMENSION ECTOINPUT2(133),ED(24),EH_BABY1(24),ENARY1(25)
      DIMENSION ENARY10(25),ENARY11(25),ENARY12(25),ENARY13(25)
      DIMENSION ENARY14(25),ENARY15(25),ENARY16(25),ENARY17(25)
      DIMENSION ENARY18(25),ENARY19(25),ENARY2(25),ENARY20(25)
      DIMENSION ENARY21(25),ENARY22(25),ENARY23(25),ENARY24(25)
      DIMENSION ENARY25(25),ENARY26(25),ENARY27(25),ENARY28(25)
      DIMENSION ENARY29(25),ENARY3(25),ENARY30(25),ENARY31(25)
      DIMENSION ENARY32(25),ENARY33(25),ENARY34(25),ENARY35(25)
      DIMENSION ENARY36(25),ENARY37(25),ENARY38(25),ENARY39(25)
      DIMENSION ENARY4(25),ENARY40(25),ENARY41(25),ENARY42(25)
      DIMENSION ENARY43(25),ENARY44(25),ENARY45(25),ENARY46(25)
      DIMENSION ENARY47(25),ENARY48(25),ENARY5(25),ENARY6(25)
      DIMENSION ENARY7(25),ENARY8(25),ENARY9(25),EPUP(24),ES(24)
      DIMENSION ETAO(4,3),FAECES(24),FOOD(50),GH2OMET(24),HRN(25),HS(24)
      DIMENSION HSHSOI(25),HSOIL(25),JM_JO(4,4),L_W(24),MLO2(24)
      DIMENSION MSHSOI(25),MSOIL(25),NWASTE(24),PAS(24),PCS(24)
      DIMENSION PMS(24),PGS(24),PDS(24),PJS(24),PRS(24),PBS(24)
      DIMENSION PSHSOI(25),PSOIL(25),Q(24),QSOL(25),REPRO(24),RH(25)
      DIMENSION RHREF(25),SHP(3),SURVIV(24),TALOC(25),TCORES(25)
      DIMENSION TIME(25),TRANSAR(5,25),TREF(25),TSHLOW(25),TSHOIL(25)
      DIMENSION TSHSKI(25),TSHSOI(25),TSKYC(25),TSOIL(25),TSOILS(25)
      DIMENSION TSUB(25),V(24),V_BABY1(24),VLOC(25),VOLD(24),VPUP(24)
      DIMENSION VREF(25),WETFOOD(24),WETGONAD(24),WETMASS(24)
      DIMENSION WETSTORAGE(24),YEAROUT2(20),Z(25),ZSOIL(10)

      COMMON/AIRGAS/O2GAS,CO2GAS,N2GAS
      COMMON/ANNUALACT/ANNUALACT
      COMMON/ANPARMS/RINSUL,R1,AREA,VOL,FATCOND
      COMMON/ARRHEN/T_A,T_AL,T_AH,T_L,T_H,T_REF
      COMMON/ARRHEN2/T_A2,T_AL2,T_AH2,T_L2,T_H2
      COMMON/BEHAV1/DAYACT,BURROW,CLIMB,CKGRSHAD,CREPUS,NOCTURN
      COMMON/BEHAV2/GEOMETRY,NODNUM,CUSTOMGEOM,SHP
      COMMON/BEHAV3/ACTHR
      COMMON/BEHAV4/FOSORIAL
      COMMON/BREEDER/BREEDING,BREEDVECT
      COMMON/BUR/NON,MINNODE,BURROWTMP
      COMMON/CONT/CONTH,CONTW,CONTVOL,CONTDEP,CONTHOLE,CONTWET,RAINMULT,
     & WETMOD,CONTONLY,CONTYPE,RAINHOUR
      COMMON/CONTDEPTH/CONTDEPTH
      COMMON/COUNTDAY/COUNTDAY,DAYCOUNT
      COMMON/CTMAXMIN/CTMAX,CTMIN,CTMINCUM,CTMINTHRESH,CTKILL
      COMMON/DAYINT/DAYMET,DAYEVP,DAYEIN,DAYWIN,DAYNRG,DAYWTR,DAYAIR
      COMMON/DAYITR/IDAY
      COMMON/DEBBABY/V_BABY,E_BABY,EH_BABY
      COMMON/DEBINIT1/V_INIT,E_INIT,CUMREPRO_INIT,CUMBATCH_INIT,
     & VOLD_INIT,VPUP_INIT,EPUP_INIT
      COMMON/DEBINIT2/ES_INIT,Q_INIT,HS_INIT,P_MREF,VDOTREF,H_AREF,
     &  E_BABY_INIT,V_BABY_INIT,EH_BABY_INIT,K_JREF,S_G,SURVIV_INIT,
     & HALFSAT,X_FOOD,E_HPUP_INIT,P_XMREF
      COMMON/DEBMASS/ETAO,JM_JO
      COMMON/DEBMOD/V,ED,WETMASS,WETSTORAGE,WETGONAD,WETFOOD,O2FLUX,
     & CO2FLUX,CUMREPRO,HS,ES,L_W,P_B_PAST,CUMBATCH,Q,V_BABY1,E_BABY1,
     & E_H,STAGE,EH_BABY1,GUTFREEMASS,SURVIV,VOLD,VPUP,EPUP,E_HPUP,
     & RAINDRINK,POTFREEMASS,PAS,PBS,PCS,PDS,PGS,PJS,PMS,PRS,CENSUS,
     & RESET,DEADEAD,STARTDAY,DEAD
      COMMON/DEBMOD2/REPRO,ORIG_CLUTCHSIZE,NEWCLUTCH,ORIG_ESM,MINCLUTCH
      COMMON/DEBOUTT/FECUNDITY,CLUTCHES,MONREPRO,L_WREPRO,MONMATURE,
     & MINED,ANNFOOD,FOOD,LONGEV,COMPLETION,COMPLETE
      COMMON/DEBPAR1/CLUTCHSIZE,ANDENS_DEB,D_V,EGGDRYFRAC,W_E,MU_E,MU_V,
     & W_V,E_EGG,KAP_X,KAP_X_P,MU_X,MU_P,W_N,W_P,W_X,FUNCT
      COMMON/DEBPAR2/ZFACT,KAPPA,E_G,KAP_R,DELTA_DEB,E_H_START,MAXMASS,
     & E_INIT_BABY,V_INIT_BABY,E_H_INIT,E_HB,E_HP,E_HJ,ESM,LAMBDA,
     & BREEDRAINTHRESH,DAYLENGTHSTART,DAYLENGTHFINISH,LENGTHDAY,
     & LENGTHDAYDIR,PREVDAYLENGTH,LAT,CLUTCHA,CLUTCHB,E_HE,
     & AQUABREED,AQUASTAGE,PHOTODIRS,PHOTODIRF,
     & BREEDACTTHRES,METAMORPH,PHOTOSTART,PHOTOFINISH,BREEDACT,BATCH
      COMMON/DEBPAR3/METAB_MODE,STAGES,Y_EV_L
      COMMON/DEBPAR4/S_J,L_B,L_J
      COMMON/DEBRESP/MLO2,GH2OMET,DEBQMET,MLO2_INIT,GH2OMET_INIT,
     & DEBQMET_INIT,DRYFOOD,FAECES,NWASTE
      COMMON/DEPTHS/DEPSEL,TCORES
      COMMON/DIMENS/ALENTH,AWIDTH,AHEIT
      COMMON/DOYMON/DOY
      COMMON/DSUB1/ENARY1,ENARY2,ENARY3,ENARY4,ENARY9,ENARY10,ENARY11,
     & ENARY12,ENARY17,ENARY18,ENARY19,ENARY20,ENARY21,ENARY22,ENARY23,
     & ENARY24,ENARY25,ENARY26,ENARY27,ENARY28,ENARY45,ENARY46,ENARY47,
     & ENARY48
      COMMON/DSUB2/ENARY5,ENARY6,ENARY7,ENARY8,ENARY13,ENARY14,ENARY15,
     & ENARY16,ENARY29,ENARY30,ENARY31,ENARY32,ENARY33,ENARY34,ENARY35,
     & ENARY36,ENARY37,ENARY38,ENARY39,ENARY40,ENARY41,ENARY42,ENARY43,
     & ENARY44
      COMMON/EGGDEV/SOILNODE
      COMMON/ENVAR1/QSOL,RH,TSKYC,TIME,TALOC,TREF,RHREF,HRN
      COMMON/ENVAR2/TSUB,VREF,Z,TANNUL,VLOC
      COMMON/ENVIRS/TSOILS,TSHOIL
      COMMON/EVAP1/WEYES,WRESP,WCUT,AEFF,CUTFA,HD,PEYES,SKINW,
     & SKINT,HC,CONVAR,PMOUTH,PANT,PANTMAX
      COMMON/EVAP2/HDFREE,HDFORC
      COMMON/FOOD2/DAMT,DAVP,DAJABS,DAWTR
      COMMON/FUN1/QSOLAR,QIRIN,QMETAB,QRESP,QSEVAP,QIROUT,QCONV,QCOND
      COMMON/FUN2/AMASS,RELHUM,ATOT,FATOSK,FATOSB,EMISAN,SIG,FLSHCOND
      COMMON/FUN3/AL,TA,VEL,PTCOND,SUBTK,DEPSUB,TSUBST,PTCOND_ORIG
      COMMON/FUN4/TSKIN,R,WEVAP,TR,ALT,BP,H2O_BALPAST
      COMMON/FUN5/WC,ZEN,PDIF,ABSSB,ABSAN,ASILN,FATOBJ,NM
      COMMON/FUN6/SPHEAT,ABSMAX,ABSMIN,LIVE
      COMMON/GITRAC/PFEWAT,FOODWATERCUR
      COMMON/GOODSOIL/GOODSOIL
      COMMON/GUESS/XTRY
      COMMON/GUT/GUTFULL,GUTFILL,FOODLIM
      COMMON/INTNUM/INTNUM
      COMMON/OUTSUB/IT
      COMMON/RAINACT/RAINACT
      COMMON/RAINFALL/RAINFALL
      COMMON/REFSHADE/REFSHD
      COMMON/REPYEAR/IYEAR,NYEAR
      COMMON/REVAP1/TLUNG,DELTAR,EXTREF,RQ,MR_1,MR_2,MR_3,DEB1
      COMMON/REVAP2/GEVAP,AIRVOL,CO2MOL
      COMMON/SCENARIO/SCENAR
      COMMON/SHADE/MAXSHD,DSHD
      COMMON/SHENV1/TSHSKI,TSHLOW
      COMMON/SOIL/TSOIL,TSHSOI,ZSOIL,MSOIL,MSHSOI,PSOIL,PSHSOI,HSOIL
     & ,HSHSOI
      COMMON/SOLN/ENB
      COMMON/SUM1/DMET,DEVP,DEIN,DWIN,DNRG,DWTR,DAIR,DCO2
      COMMON/SUM2/TMET,TEVP,TEIN,TWIN,TNRG,TWTR
      COMMON/TPREFR/TMAXPR,TMINPR,TDIGPR,TPREF,TBASK,TEMERGE
      COMMON/TRANS/JP
      COMMON/TRANS/TRANCT
      COMMON/TRANSIENT1/TCINIT,TRANSAR
      COMMON/TREG/TC
      COMMON/USROP2/ENBERR,TPRINT
      COMMON/USROPT/TRANST
      COMMON/VIVIP/VIVIPAROUS,PREGNANT
      COMMON/WCONV/FLTYPE
      COMMON/WDSUB1/ANDENS,ASILP,EMISSB,EMISSK,FLUID,G,IHOUR
      COMMON/WDSUB2/QSOLR,TOBJ,TSKY,MICRO
      COMMON/WINGFUN/RHO1_3,TRANS1,AREF,BREF,CREF,PHI,F21,F31,F41,F51,
     & SIDEX,WQSOL,PHIMIN,PHIMAX,TWING,F12,F32,F42,F52,F61,TQSOL,A1,A2,
     & A3,A4,A4B,A5,A6,F13,F14,F15,F16,F23,F24,F25,F26,WINGCALC,WINGMOD
      COMMON/WSOLAR/ASIL,SHADE
      COMMON/WTRAPEZ/DTIME
      COMMON/WUNDRG/NEWDEP
      COMMON/YEAR2/AMET,AEVP,AEIN,AWIN,ANRG,AWTR,AFOD,AHRS,AAIR,ADIS

      OPEN(1,FILE='ECTOINPUT.CSV')
      READ(1,*)LABEL
      DO 11 I=1,133
      READ(1,*)LABEL,ECTOINPUT2(I)
11    CONTINUE
      CLOSE(1)

      OPEN(1,FILE='DEBMOD.CSV')
      READ(1,*)LABEL
      DO 20 I=1,94
      READ(1,*)LABEL,DEBMOD2(I)
20    CONTINUE
      CLOSE(1)

      NS3=INT(DEBMOD2(81))

C    FOR MATT MALISHEV NETLOGO SIMS
C    OPEN(1,FILE='SHADE.CSV')
C    READ(1,*)ECTOINPUT2(47)
C    ECTOINPUT2(48)=ECTOINPUT2(47)

      NN3=INT(ECTOINPUT2(104))
C      NN3=1
      ALLOCATE ( ENVIRON2(24*NN3,28) )
      ALLOCATE ( ENBAL2(24*NN3,13) )
      ALLOCATE ( MASBAL2(24*NN3,19) )
      ALLOCATE ( DEBOUT2(24*NN3,29) )
      ALLOCATE ( RAINFALL3(NN3) )
      ALLOCATE ( RAINHR2(24*NN3) )
      ALLOCATE ( MINSHADES2(NN3) )
      ALLOCATE ( MAXSHADES2(NN3) )
      ALLOCATE ( METOUT2(24*NN3,18) )
      ALLOCATE ( SHADMET2(24*NN3,18) )
      ALLOCATE ( SOIL2(24*NN3,12) )
      ALLOCATE ( SHADSOIL2(24*NN3,12) )
      ALLOCATE ( SOILMOIST2(24*NN3,12) )
      ALLOCATE ( SHADMOIST2(24*NN3,12) )
      ALLOCATE ( SOILPOT2(24*NN3,12) )
      ALLOCATE ( SHADPOT2(24*NN3,12) )
      ALLOCATE ( HUMID2(24*NN3,12) )
      ALLOCATE ( SHADHUMID2(24*NN3,12) )
C     ALLOCATE (XP(NN3*25),YP(NN3*25),TRANSIENT(NN3*25))
C     ALLOCATE (ZP1(NN3*25),ZP2(NN3*25),ZP3(NN3*25),ZP4(NN3*25))
C     ALLOCATE (ZP5(NN3*25),ZP6(NN3*25),ZP7(NN3*25))
C     ALLOCATE (ZD1(NN3*25),ZD2(NN3*25),ZD3(NN3*25),ZD4(NN3*25))
C     ALLOCATE (ZD5(NN3*25),ZD6(NN3*25),ZD7(NN3*25),DAY(NN3))
      ALLOCATE (WETLANDDEPTHS2(NN3*24),FOODLEVELS2(NN3))
      ALLOCATE (WETLANDTEMPS2(NN3*24),FOODWATERS2(NN3))
      ALLOCATE (GLMTEMP2(24*NN3,20) )
      ALLOCATE (GLMO22(24*NN3,20) )
      ALLOCATE (GLMSALT2(24*NN3,20) )
      ALLOCATE (GLMPH2(24*NN3,20) )
      ALLOCATE (GLMFOOD2(24*NN3,20) )
      ALLOCATE (YEARSOUT2(INT(CEILING(REAL(NN3)/365.)),45))

      ALLOCATE ( THERMAL_STAGES2(NS3,6) )
      ALLOCATE ( BEHAV_STAGES2(NS3,15) )
      ALLOCATE ( WATER_STAGES2(NS3,8) )
      ALLOCATE ( NUTRI_STAGES2(NS3,1) )
      ALLOCATE ( ARRHENIUS3(NS3,5) )
      ALLOCATE ( ARRHENIUS32(NS3,5) )
      ALLOCATE ( S_INSTAR2(NS3) )

      OPEN(1,FILE='METOUT.CSV')
      READ(1,*)LABEL
      DO 13 I=1,NN3*24
      READ(1,*) (METOUT2(I,J),J=1,18)
13    CONTINUE
      CLOSE(1)

      OPEN(1,FILE='SHADMET.CSV')
      READ(1,*)LABEL
      DO 14 I=1,NN3*24
      READ(1,*) (SHADMET2(I,J),J=1,18)
14    CONTINUE
      CLOSE(1)

      OPEN(1,FILE='SOIL.CSV')
      READ(1,*)LABEL
      DO 15 I=1,NN3*24
      READ(1,*) (SOIL2(I,J),J=1,12)
15    CONTINUE
      CLOSE(1)

      OPEN(1,FILE='SHADSOIL.CSV')
      READ(1,*)LABEL
      DO 16 I=1,NN3*24
      READ(1,*) (SHADSOIL2(I,J),J=1,12)
16    CONTINUE
      CLOSE(1)

      OPEN(1,FILE='DEP.CSV')
      READ(1,*)LABEL
      DO 17 I=1,10
      READ(1,*)LABEL,DEP2(I)
17    CONTINUE
      CLOSE(1)

      OPEN(1,FILE='DEBLAST.CSV')
      READ(1,*)LABEL
      DO 21 I=1,13
      READ(1,*)LABEL,DEBLAST2(I)
21    CONTINUE
      CLOSE(1)

      OPEN(1,FILE='S_INSTAR.CSV')
      READ(1,*)LABEL
      DO 38 I=1,NS3
      READ(1,*)LABEL,S_INSTAR2(I)
38    CONTINUE
      CLOSE(1)

      OPEN(1,FILE='RAINFALL.CSV')
      READ(1,*)LABEL
      DO 22 I=1,NN3
      READ(1,*)LABEL,RAINFALL3(I)
22    CONTINUE
      CLOSE(1)


      OPEN(1,FILE='FOODWATERS.CSV')
      READ(1,*)LABEL
      DO 23 I=1,NN3
      READ(1,*)LABEL,FOODWATERS2(I)
23    CONTINUE
      CLOSE(1)


      OPEN(1,FILE='FOODLEVELS.CSV')
      READ(1,*)LABEL
      DO 24 I=1,NN3
      READ(1,*)LABEL,FOODLEVELS2(I)
24    CONTINUE
      CLOSE(1)

      OPEN(1,FILE='WETLANDTEMPS.CSV')
      READ(1,*)LABEL
      DO 25 I=1,NN3*24
      READ(1,*)LABEL,WETLANDTEMPS2(I)
25    CONTINUE
      CLOSE(1)

      OPEN(1,FILE='WETLANDDEPTHS.CSV')
      READ(1,*)LABEL
      DO 26 I=1,NN3*24
      READ(1,*)LABEL,WETLANDDEPTHS2(I)
26    CONTINUE
      CLOSE(1)

      OPEN(1,FILE='ARRHENIUS.CSV')
      READ(1,*)LABEL
      DO 31 I=1,NS3
      READ(1,*)LABEL,(ARRHENIUS3(I,J),J=1,5)
31    CONTINUE
      CLOSE(1)

      OPEN(1,FILE='ARRHENIUS2.CSV')
      READ(1,*)LABEL
      DO 48 I=1,NS3
      READ(1,*)LABEL,(ARRHENIUS32(I,J),J=1,5)
48    CONTINUE
      CLOSE(1)

      OPEN(1,FILE='THERMAL_STAGES.CSV')
      READ(1,*)LABEL
      DO 27 I=1,NS3
      READ(1,*)LABEL,(THERMAL_STAGES2(I,J),J=1,6)
27    CONTINUE
      CLOSE(1)

      OPEN(1,FILE='BEHAV_STAGES.CSV')
      READ(1,*)LABEL
      DO 28 I=1,NS3
      READ(1,*)LABEL,(BEHAV_STAGES2(I,J),J=1,15)
28    CONTINUE
      CLOSE(1)

      OPEN(1,FILE='WATER_STAGES.CSV')
      READ(1,*)LABEL
      DO 29 I=1,NS3
      READ(1,*)LABEL,(WATER_STAGES2(I,J),J=1,8)
29    CONTINUE
      CLOSE(1)

      OPEN(1,FILE='MAXSHADES.CSV')
      READ(1,*)LABEL
      DO 30 I=1,NN3
      READ(1,*)LABEL,MAXSHADES2(I)
30    CONTINUE
      CLOSE(1)

      OPEN(1,FILE='MINSHADES.CSV')
      READ(1,*)LABEL
      DO 46 I=1,NN3
      READ(1,*)LABEL,MINSHADES2(I)
46    CONTINUE
      CLOSE(1)

      OPEN(1,FILE='SOILMOIST.CSV')
      READ(1,*)LABEL
      DO 32 I=1,NN3*24
      READ(1,*) (SOILMOIST2(I,J),J=1,12)
32    CONTINUE
      CLOSE(1)

      OPEN(1,FILE='SHADMOIST.CSV')
      READ(1,*)LABEL
      DO 33 I=1,NN3*24
      READ(1,*) (SHADMOIST2(I,J),J=1,12)
33    CONTINUE
      CLOSE(1)

      OPEN(1,FILE='SOILPOT.CSV')
      READ(1,*)LABEL
      DO 34 I=1,NN3*24
      READ(1,*) (SOILPOT2(I,J),J=1,12)
34    CONTINUE
      CLOSE(1)

      OPEN(1,FILE='SHADPOT.CSV')
      READ(1,*)LABEL
      DO 35 I=1,NN3*24
      READ(1,*) (SHADPOT2(I,J),J=1,12)
35    CONTINUE
      CLOSE(1)

      OPEN(1,FILE='HUMID.CSV')
      READ(1,*)LABEL
      DO 36 I=1,NN3*24
      READ(1,*) (HUMID2(I,J),J=1,12)
36    CONTINUE
      CLOSE(1)

      OPEN(1,FILE='SHADHUMID.CSV')
      READ(1,*)LABEL
      DO 37 I=1,NN3*24
      READ(1,*) (SHADHUMID2(I,J),J=1,12)
37    CONTINUE
      CLOSE(1)

      OPEN(1,FILE='GLMTEMPS.CSV')
      READ(1,*)LABEL
      DO 39 I=1,NN3*24
      READ(1,*) (GLMTEMP2(I,J),J=1,20)
39    CONTINUE
      CLOSE(1)

      OPEN(1,FILE='GLMO2S.CSV')
      READ(1,*)LABEL
      DO 40 I=1,NN3*24
      READ(1,*) (GLMO22(I,J),J=1,20)
40    CONTINUE
      CLOSE(1)

      OPEN(1,FILE='GLMSALTS.CSV')
      READ(1,*)LABEL
      DO 41 I=1,NN3*24
      READ(1,*) (GLMSALT2(I,J),J=1,20)
41    CONTINUE
      CLOSE(1)

      OPEN(1,FILE='GLMPHS.CSV')
      READ(1,*)LABEL
      DO 42 I=1,NN3*24
      READ(1,*) (GLMPH2(I,J),J=1,20)
42    CONTINUE
      CLOSE(1)

      OPEN(1,FILE='GLMFOODS.CSV')
      READ(1,*)LABEL
      DO 43 I=1,NN3*24
      READ(1,*) (GLMFOOD2(I,J),J=1,20)
43    CONTINUE
      CLOSE(1)

      OPEN(1,FILE='NUTRI_STAGES.CSV')
      READ(1,*)LABEL
      DO 44 I=1,NS3
      READ(1,*)LABEL,(NUTRI_STAGES2(I,J),J=1,1)
44    CONTINUE

      OPEN(1,FILE='RAINHR.CSV')
      READ(1,*)LABEL
      DO 45 I=1,NN3*24
      READ(1,*)LABEL,RAINHR2(I)
45    CONTINUE
      CLOSE(1)

      CALL ECTOTHERM(NN3,NS3,ECTOINPUT2,METOUT2,SHADMET2,SOIL2,
     &SHADSOIL2,SOILMOIST2,SHADMOIST2,SOILPOT2,SHADPOT2,HUMID2
     &,SHADHUMID2,DEP2,RAINFALL3,RAINHR2,DEBMOD2,DEBLAST2,FOODWATERS2
     &,FOODLEVELS2,WETLANDTEMPS2,WETLANDDEPTHS2,GLMTEMP2,GLMO22,GLMSALT2
     &,GLMPH2,GLMFOOD2,ARRHENIUS3,ARRHENIUS32,THERMAL_STAGES2
     &,BEHAV_STAGES2,WATER_STAGES2,NUTRI_STAGES2,MINSHADES2,MAXSHADES2
     &,S_INSTAR2,ENVIRON2,ENBAL2,MASBAL2,DEBOUT2,YEAROUT2,YEARSOUT2)
      END
