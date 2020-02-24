#Import everything needed
#Import the Pedigree
Pedigree <- read.csv(file = 'Fake_Pedigree.csv')

#Import time point data from both sites
UO_DERS_T1 <- read.csv(file = 'UO_T1_Qualtrics.csv')
UO_DERS_T2 <- read.csv(file = 'UO_T2_Qualtrics.csv')
UO_DERS_T3 <- read.csv(file = 'UO_T3_Qualtrics.csv')
UO_DERS_T4 <- read.csv(file = 'UO_T4_Qualtrics.csv')
UPMC_DERS_T1 <- read.csv(file = 'UPMC_T1_DERS.csv')
UPMC_DERS_T2 <- read.csv(file = 'UPMC_T2_DERS.csv')
UPMC_DERS_T3 <- read.csv(file = 'UPMC_T3_DERS.csv')
UPMC_DERS_T4 <- read.csv(file = 'UPMC_T4_DERS.csv')

#Import the NDA Structure 
DERS_NDA <- read.csv(file = 'ders01_template.csv')

#Edit and rename Pedigree to have just the required info
DERS_PREP <- select(Pedigree, c(mom_guid, mom_id, intake_date, t1_date, t2_date, t3_date, t4_date, 
                                mom_age_t1, mom_age_t2, mom_age_t3, mom_age_t4))

#Select and rename columns in the DERS and add it to the prep workspace
DERS_PREP <- select(UO_DERS_T1, c( Q221))

DERS_PREP <- select(UO_DERS_T1, c(Q137_1 ["DERS001"],Q137_2 ["DERS002"],Q137_3 ["DERS003"],
                                  Q137_4 ["DERS004"],Q137_5 ["DERS005"],Q137_6 ["DERS006"],
                                  Q137_7 ["DERS007"],Q137_8 ["DERS008"],Q137_9 ["DERS009"],
                                  Q137_10 ["DERS010"],Q137_11 ["DERS011"],Q137_12 ["DERS012"],
                                  Q137_13 ["DERS013"],Q137_14 ["DERS014"],Q137_15 ["DERS015"],
                                  Q137_16 ["DERS016"],Q137_17 ["DERS017"],Q137_18 ["DERS018"],
                                  Q137_19 ["DERS019"],Q137_20 ["DERS020"],Q137_21 ["DERS021"],
                                  Q137_22 ["DERS022"],Q137_23 ["DERS023"],Q137_24 ["DERS024"],
                                  Q137_25 ["DERS025"],Q137_26 ["DERS026"],Q137_27 ["DERS027"],
                                  Q137_28 ["DERS028"],Q137_29 ["DERS029"],Q137_30 ["DERS030"],
                                  Q137_31 ["DERS031"],Q137_32 ["DERS032"],Q137_33 ["DERS033"],
                                  Q137_34 ["DERS034"],Q137_35 ["DERS035"],Q137_36 ["DERS036"],))

#DERS_PREP <- select(UO_DERS_T1, c(DERS001, DERS002, DERS003, DERS004, DERS005, DERS006, DERS007, 
#                                  DERS008, DERS009, DERS010, DERS011, DERS012, DERS013, DERS014, 
#                                  DERS015, DERS016, DERS017, DERS018, DERS019, DERS020, DERS021, 
#                                  DERS022, DERS023, DERS024, DERS025, DERS026, DERS027, DERS028, 
#                                  DERS029, DERS030, DERS031, DERS032, DERS033, DERS034, DERS035, 
#                                  DERS036))
