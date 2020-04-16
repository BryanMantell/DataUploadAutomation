# Data Request for Grace Binion - Maternal Borderline Personality Discorder and Intergenerational Transmission of Psychosocial Risk
library(dplyr)
library(tidyverse)
library(eeptools)
# Measures Needed: SIDP, PAIBOR, PPVT-IV, Day/Night, Delay of Gratification, Dimensional Card Sort, Theory of Mind, CBCL, TRF, PKBS-2
# ID List Creation and Demographics -------------------------------------------------------
# Import
UO_database_info <- read.csv("UO_database_demo.csv", stringsAsFactors = FALSE) 
UO_Intake_survey <- read.csv("UO_demo.csv", stringsAsFactors = FALSE)
UO_screener <- read.csv("UO_screener.csv", stringsAsFactors = FALSE)
UPMC_demographics <- read.csv("UPMC_demo.csv", stringsAsFactors = FALSE)
UPMC_eduincome <- read.csv("UPMC_eduincome.csv", stringsAsFactors = FALSE)
UO_Time1Dates <- read.csv("UO_Time1Dates.csv", stringsAsFactors = FALSE)

# ID Merges and binds
UO_IDs <- merge(UO_database_info, UO_Intake_survey, by = "FamID")

UO_IDs <- filter(UO_IDs, Group.Assignment == "Assigned Group 1 (DBT)" |
                            Group.Assignment == "Assigned Group 2 (FSU)" |
                            Group.Assignment == "Assigned Group 3 (HC)")

UO_IDs <- select(UO_IDs, FamID)
UPMC_IDs <- select(UPMC_demographics, FamID)
ID_list <- rbind(UO_IDs, UPMC_IDs)

# Clean environment 
rm(UPMC_IDs, UO_IDs)

# Demographics Needed: Maternal Age, Child Age, Maternal Race/Ethnicity, Total Family Income
# Merge UO infomation 
UO_demographics <- merge(UO_database_info, UO_Intake_survey, by = "FamID")
UO_screener <- select(UO_screener, FamID, Reported_Income = Q10)
UO_screener <- merge(ID_list, UO_screener, by = "FamID" )
UO_Time1Dates <- merge(ID_list, UO_Time1Dates, by = "FamID")

# Modfy UO sheet to have only the necessary infomation 
UO_demographics <- filter(UO_demographics, Group.Assignment == "Assigned Group 1 (DBT)" |
                            Group.Assignment == "Assigned Group 2 (FSU)" |
                            Group.Assignment == "Assigned Group 3 (HC)")

UO_demographics <- select(UO_demographics, FamID, Group_Assignment = Group.Assignment, Mom_DOB = Mom.DOB, Child_DOB = TC.DOB, 
                          Mother_Race_Eth = Q2,Mother_Race_Eth_Details = Q2_7_TEXT, Mom_Edu = Q58_1, 
                          Family_Income = Q71, Greater_Family_Income = Q72)

UO_demographics <- merge(UO_screener, UO_demographics,by = "FamID" )
UO_demographics <- merge(UO_Time1Dates, UO_demographics, by = "FamID")

# Modfy UPMC sheet to have only the necessary infomation 
UPMC_demographics <- select(UPMC_demographics, FamID, Group_Assignment = Group.Assignment, Mom_DOB = Mom.DOB, 
                            Child_DOB = Child.DOB, Mother_Race_Eth = Mom.Race, Mother_Race_Eth_Details = Mom.Ethnicity, T1_Date)

UPMC_eduincome <- merge(ID_list,UPMC_eduincome, by = "FamID")
UPMC_demographics <- merge(UPMC_eduincome,UPMC_demographics, by = "FamID")

UPMC_demographics$Greater_Family_Income <- ""
UPMC_demographics$Reported_Income <- ""

# Recoding UPMC income to ranges
UPMC_demographics$Family_Income <- cut(UPMC_demographics$Family_Income, c(0, 22310, 30044, 37777, 45510, 53243, 60976, 68709, 76442, Inf),
                             c("$22,310 or less", "Between $22,311 and $30,044", "Between $30,045 and $37,777", "Between $37,778 and $45,510",
                               "Between $45,511 and $53,243", "Between $53,244 and $60,976", "Between $60,977 and $68,709",
                               "Between $68,710 and $76,442", "More than $76,442"))

# Bind UO and UPMC data
Demographics_final <- rbind(UO_demographics, UPMC_demographics)
Demographics_final <- select(Demographics_final, FamID, Group_Assignment, Mom_DOB, Child_DOB, T1_Date, Mother_Race_Eth,
                             Mother_Race_Eth_Details, Mom_Edu, Family_Income, Greater_Family_Income, Reported_Income)

# Clean environment 
rm(UO_database_info, UPMC_demographics, UO_demographics, UO_Intake_survey, UO_screener, UPMC_eduincome, UO_Time1Dates)

# Recoding Race and Ethnicity
Demographics_final <- Demographics_final %>%
  mutate(Mother_Race_Eth = ifelse(Mother_Race_Eth == "European American or White", "White",  
                           ifelse(Mother_Race_Eth == "White", "White",
                           ifelse(Mother_Race_Eth == "Latino(a) or Hispanic", "LatHisp",
                           ifelse(Mother_Race_Eth == "African-American or Black", "AfAm",
                           ifelse(Mother_Race_Eth == "Black or African American", "AfAm",
                           ifelse(Mother_Race_Eth == "Other", "Multiracial",
                           ifelse(Mother_Race_Eth == "NA", "NA","Multiracial"))))))))

# Recoding Maternal Education
Demographics_final[Demographics_final == 1] <- "Less than 8th grade"; 
Demographics_final[Demographics_final == 2] <- "8th grade";
Demographics_final[Demographics_final == 3] <- "Some high school";
Demographics_final[Demographics_final == 4] <- "GED";
Demographics_final[Demographics_final == 5] <- "H.S. graduate";
Demographics_final[Demographics_final == 6] <- "Associate's Degree or diploma";
Demographics_final[Demographics_final == 7] <- "Tech./Prof. School";
Demographics_final[Demographics_final == 8] <- "Some college";
Demographics_final[Demographics_final == 9] <- "College/Univ. graduate";
Demographics_final[Demographics_final == 10] <- "Some graduate school";
Demographics_final[Demographics_final == 11] <- "Masters Degree";
Demographics_final[Demographics_final == 12] <- "Doctorate"

# Recoding Group Assignment Strings
Demographics_final[Demographics_final == "DBT"] <- "Assigned Group 1 (DBT)"; 
Demographics_final[Demographics_final == "NO DBT"] <- "Assigned Group 2 (FSU)"; 
Demographics_final[Demographics_final == "Healthy"] <- "Assigned Group 3 (HC)"

# Calulate Ages for Mom and Child
Demographics_final$T1_Date <- as.Date(Demographics_final$T1_Date)
Demographics_final$Mom_DOB <- as.Date(Demographics_final$Mom_DOB)
Demographics_final$Child_DOB <- as.Date(Demographics_final$Child_DOB)

Demographics_final$Mom_age_yrs <- age_calc(Demographics_final$Mom_DOB, Demographics_final$T1_Date, units = "years", precise = TRUE)
Demographics_final$Mom_age_mos <- age_calc(Demographics_final$Mom_DOB, Demographics_final$T1_Date, units = "months", precise = TRUE)
Demographics_final$Child_age_yrs <- age_calc(Demographics_final$Child_DOB, Demographics_final$T1_Date, units = "years", precise = TRUE)
Demographics_final$Child_age_mos <- age_calc(Demographics_final$Child_DOB, Demographics_final$T1_Date, units = "months", precise = TRUE)

# Sort for final output
Demographics_final <- select(Demographics_final, FamID, Group_Assignment, Mom_age_yrs, Mom_age_mos, Child_age_yrs, Child_age_mos, Mother_Race_Eth,
                             Mother_Race_Eth_Details, Mom_Edu, Family_Income, Greater_Family_Income, Reported_Income)

# Calulate Percentages 

Race_Eth_Table <- Demographics_final %>%
  group_by(Mother_Race_Eth) %>%
  summarize(n = n()) %>%
  mutate(RF = n/sum(n)) 

barplot(Race_Eth_Table$n, names.arg = Race_Eth_Table$Mother_Race_Eth, main = "Race & Ethnicity",
        col = c("Red", "Yellow", "Green", "Blue"))


Demographics_final %>% count(Mom_Edu)
Demographics_final %>% count(Group_Assignment)
Demographics_final %>% count(Family_Income)

# Export Demographics
write.csv(Demographics_final, file = "Grace_Dissertation_Data/Grace_Dissertation_Demographics.csv", na = "MISSING")

# Day/Night ---------------------------------------------------------------
# Import
DayNight <- read.csv("Measures/DayNight_T1.csv", stringsAsFactors = FALSE)

# Pool double scored data
DayNight_DS <- filter(DayNight, grepl("_DS", FamID))

# Merge Data with ID list
DayNight <- merge(ID_list, DayNight,by = "FamID", all.x=TRUE)

# Filter and clean
DayNight <- select(DayNight, FamID, dn_notes = oc_dn_notes, exp_error_oth_dn, 
                        total_correct_dn, oc_dn_admin)

DayNight[12,2]<-"No Video"; DayNight[17,2]<-"Not Entered";
DayNight[20,2]<-"Video Won't Play"; DayNight[21,2]<-"Video Won't Play";
DayNight[22,2]<-"No Video"; DayNight[29,2]<-"Not Entered"; 
DayNight[32,2]<-"No Video"; DayNight[33,2]<-"No Video"; 
DayNight[37,2]<-"No Video"; DayNight[43,2]<-"No Video"; 
DayNight[45,2]<-"No Video"; DayNight[47,2]<-"No Video"; 
DayNight[54,2]<-"No Video"; DayNight[61,2]<-"No Video";
DayNight[62,2]<-"No Video"; DayNight[64,2]<-"No Video"; 
DayNight[73,2]<-"Not Entered"; DayNight[77,2]<-"Child Refused"; 
DayNight[79,2]<-"Child Refused"; DayNight[83,2]<-"Child Refused"; 
DayNight[91,2]<-"Not Entered"; DayNight[93,2]<-"Child Refused"; 
DayNight[100,2]<-"Child Refused"; DayNight[115,2]<-"Not Entered"; 
DayNight[123,2]<-"Child Refused"; DayNight[131,2]<-"Child Refused";
DayNight[132,2]<-"Child Refused"

DayNight_DS <- select(DayNight_DS, FamID, dn_notes = oc_dn_notes, exp_error_oth_dn, 
                      total_correct_dn, oc_dn_admin)

# Export and Clean
#write.csv(DayNight, file = "Grace_Dissertation_Data/Grace_Dissertation_DayNight.csv")
#write.csv(DayNight_DS, file = "Grace_Dissertation_Data/Reliabilities/Grace_Dissertation_DayNight_DS.csv")

rm(DayNight, DayNight_DS)

# Bear Dragon -------------------------------------------------------------
# Import 
BearDragon <- read.csv("Measures/BearDragon_T1.csv", stringsAsFactors = FALSE)

# Pool double scored data
BearDragon_DS <- filter(BearDragon, grepl("_DS", FamID))

# Merge Data with ID list
BearDragon <- merge(ID_list, BearDragon,by = "FamID", all.x=TRUE)

# Filter and clean
BearDragon <- select(BearDragon, FamID, bd_notes = oc_bd_notes, auto_total_points_bd)

BearDragon_DS <- select(BearDragon_DS, FamID, bd_notes = oc_bd_notes, auto_total_points_bd)

BearDragon[17,2]<-"Not Entered"; BearDragon[20,2]<-"Video Won't Play"; 
BearDragon[21,2]<-"Video Won't Play"; BearDragon[33,2]<-"No Video";
BearDragon[47,2]<-"No Video"; BearDragon[54,2]<-"No Video";
BearDragon[61,2]<-"No Video"; BearDragon[64,2]<-"No Video";
BearDragon[73,2]<-"Not Entered"; BearDragon[81,2]<-"Child Refused"
BearDragon[88,2]<-"Child Refused"; BearDragon[100,2]<-"Child Refused";
BearDragon[101,2]<-"Child Refused"; BearDragon[110,2]<-"Child Refused";
BearDragon[115,2]<-"Not Entered"; BearDragon[123,2]<-"Child Refused";
BearDragon[132,2]<-"Child Refused"; BearDragon[141,2]<-"Child Refused"

# Export and Clean
write.csv(BearDragon, file = "Grace_Dissertation_Data/Grace_Dissertation_BearDragon.csv")
write.csv(BearDragon_DS, file = "Grace_Dissertation_Data/Reliabilities/Grace_Dissertation_BearDragon_DS.csv")

# Dimensional Card Sort ---------------------------------------------------
# Import 
DCCS <- read.csv("Measures/DCCS_T1.csv", stringsAsFactors = FALSE)

# Pool double scored data
DCCS_DS <- filter(DCCS, grepl("_DS", FamID))

# Merge
DCCS <- merge(ID_list, DCCS, by = "FamID", all.x=TRUE)

# Filter and Clean
DCCS <- select(DCCS, FamID, REDcap = redcap_event_name, dccs_notes = exp_error_oth_dcs, total_correct_dcs, total_administered_dcs)
DCCS[12,3]<-"No Video"; DCCS[17,3]<-"Not Entered"; DCCS[20,3]<-"Video Won't Play"; DCCS[21,3]<-"Video Won't Play";
DCCS[22,3]<-"No Video"; DCCS[26,3]<-"Not Entered"; DCCS[29,3]<-"Not Entered"; DCCS[32,3]<-"No Video";
DCCS[33,3]<-"No Video"; DCCS[37,3]<-"No Video"; DCCS[43,3]<-"No Video"; DCCS[45,3]<-"No Video";
DCCS[47,3]<-"No Video"; DCCS[54,3]<-"No Video"; DCCS[61,3]<-"No Video";DCCS[62,3]<-"No Video";
DCCS[64,3]<-"No Video"; DCCS[77,3]<-"Child Refused"; DCCS[79,3]<-"Child Refused"; DCCS[83,3]<-"Child Refused"
DCCS[85,3]<-"Child Refused"; DCCS[91,3]<-"Not Entered"; DCCS[97,3]<-"Not Entered"; DCCS[100,3]<-"Child Refused"
DCCS[115,3]<-"Not Entered"; DCCS[123,3]<-"Child Refused"; DCCS[130,3]<-"Child Refused"; DCCS[137,3]<-"Child Refused"
DCCS_final <-select (DCCS, FamID, dccs_notes, total_correct_dcs, total_administered_dcs)

DCCS_DS <- select(DCCS_DS,FamID, REDcap = redcap_event_name, dccs_notes = exp_error_oth_dcs, total_correct_dcs, total_administered_dcs)

# Export
#write.csv(DCCS_final, file = "Grace_Dissertation_Data/Grace_Dissertation_DCCS.csv")
#write.csv(DCCS_DS, file = "Grace_Dissertation_Data/Reliabilities/Grace_Dissertation_DCCS_DS.csv")

rm(DCCS, DCCS_DS, DCCS_final)

# Theory of Mind ----------------------------------------------------------
# Import 
ToM <- read.csv("Measures/ToM_T1.csv", stringsAsFactors = FALSE)

# Pool double scored data
ToM_DS <- filter(ToM, grepl("_DS", FamID))

# Merge
ToM <- merge(ID_list, ToM, by = "FamID", all.x=TRUE)

# Filter and Clean
ToM <- select(ToM, FamID, REDcap = redcap_event_name, oc_tom_notes, auto_score_tom)
ToM[12,3]<-"No Video"; ToM[17,3]<-"Not Entered"; ToM[20,3]<-"Video Won't Play"; ToM[21,3]<-"Video Won't Play";
ToM[22,3]<-"No Video"; ToM[23,3]<-"No Video"; ToM[29,3]<-"Not Entered"; ToM[32,3]<-"No Video"; ToM[33,3]<-"No Video"; 
ToM[37,3]<-"No Video"; ToM[43,3]<-"No Video"; ToM[45,3]<-"No Video"; ToM[47,3]<-"No Video"; ToM[54,3]<-"No Video"; 
ToM[61,3]<-"No Video";ToM[62,3]<-"No Video"; ToM[64,3]<-"No Video"; ToM[115,3]<-"Not Entered";ToM[123,3]<-"Child Refused"
ToM <- select(ToM, FamID, ToM_notes = oc_tom_notes, auto_score_tom)

ToM_DS <- select(ToM_DS, FamID, FamID, oc_tom_notes, auto_score_tom)

# Export
#write.csv(ToM, file = "Grace_Dissertation_Data/Grace_Dissertation_ToM.csv")
#write.csv(ToM_DS, file = "Grace_Dissertation_Data/Reliabilities/Grace_Dissertation_ToM_DS.csv")

rm(ToM, ToM_DS, ToM_final)

# Delay of Gratification --------------------------------------------------
# Import 
DoG <- read.csv("Measures/DoG_T1.csv", stringsAsFactors = FALSE)

# Merge
DoG  <- merge(ID_list, DoG, by = "FamID", all.x=TRUE)

# Filter and Clean
DoG <- select(DoG, FamID, REDcap = redcap_event_name, oc_dog_anynotes, zero_distraction = oc_dog_numdistractions___0,
              one_distraction = oc_dog_numdistractions___1, two_distraction = oc_dog_numdistractions___2, 
              three_distraction = oc_dog_numdistractions___3, four_distraction = oc_dog_numdistractions___4,
              five_distraction = oc_dog_numdistractions___5, six_distraction = oc_dog_numdistractions___6, 
              first_shoulderpeek = oc_dog_shoulder, first_turnaround = oc_dog_turn, Totalpeeks = oc_dog_numpeeks, 
              Difficultyrating = oc_dog_rating)

DoG[12,3]<-"No Video"; DoG[17,3]<-"Not Entered"; DoG[20,3]<-"Video Won't Play"; DoG[21,3]<-"Video Won't Play";
DoG[22,3]<-"No Video"; DoG[23,3]<-"No Video"; DoG[29,3]<-"Not Entered"; DoG[32,3]<-"No Video"; DoG[33,3]<-"No Video"; 
DoG[37,3]<-"No Video"; DoG[43,3]<-"No Video"; DoG[45,3]<-"No Video"; DoG[47,3]<-"No Video"; DoG[54,3]<-"No Video"; 
DoG[61,3]<-"No Video";DoG[62,3]<-"No Video"; DoG[64,3]<-"No Video";

DoG_final <- select(DoG, FamID, oc_dog_anynotes, zero_distraction, one_distraction, two_distraction, three_distraction,
                    four_distraction, five_distraction, six_distraction, first_shoulderpeek,
                    first_turnaround, Totalpeeks, Difficultyrating)

# Export
write.csv(DoG_final, file = "Grace_Dissertation_Data/Grace_Dissertation_DoG.csv")

rm(DoG_final, DoG)

# PPVT --------------------------------------------------------------------
# Import 
PPVT <- read.csv("Measures/PPVT_T1.csv", stringsAsFactors = FALSE)

# Merge
PPVT <- merge(ID_list, PPVT,by = "FamID", all.x=TRUE)

# Filter and Clean
PPVT_final <- select(PPVT, FamID, Relationship, rawscore, standardscore)
rm(PPVT)

# Export
write.csv(PPVT_final, file = "Grace_Dissertation_Data/Grace_Dissertation_PPVT.csv")

rm(PPVT_final)

# CBCL --------------------------------------------------------------------
# Import
UO_CBCL <- read.csv("Measures/UO_MS_T1.csv", stringsAsFactors = FALSE)
UPMC_CBCL <- read.csv("Measures/UPMC_CBCL_T1.csv", stringsAsFactors = FALSE)

# Rename Variables and Merge
UO_CBCL <- select(UO_CBCL, FamID, cbcl001 = Q264_1, cbcl002 = Q264_2, cbcl003 = Q264_3, cbcl004 = Q264_4,cbcl005 = Q264_5,
                  cbcl006 = Q264_6, cbcl007 = Q264_7, cbcl008 = Q264_8, cbcl009 = Q264_9, cbcl010 = Q264_10, cbcl011 = Q264_11,
                  cbcl012 = Q264_12, cbcl013 = Q264_13, cbcl014 = Q264_14, cbcl015 = Q264_15, cbcl016 = Q264_16, cbcl017 = Q264_17,
                  cbcl018 = Q264_18, cbcl019 = Q264_19, cbcl020 = Q264_20, cbcl021 = Q264_21, cbcl022 = Q264_22, cbcl023 = Q264_23,
                  cbcl024 = Q264_24, cbcl025 = Q264_25, cbcl026 = Q264_26, cbcl027 = Q264_27, cbcl028 = Q264_28, cbcl029 = Q264_29,
                  cbcl030 = Q264_30, cbcl031 = Q264_31, cbcl032 = Q264_32, cbcl033 = Q264_33, cbcl034 = Q264_34, cbcl035 = Q264_35,
                  cbcl036 = Q264_36, cbcl037 = Q264_37, cbcl038 = Q264_38, cbcl039 = Q264_39, cbcl040 = Q264_40, cbcl041 = Q264_41,
                  cbcl042 = Q264_42, cbcl043 = Q264_43, cbcl044 = Q264_44, cbcl045 = Q264_45, cbcl046 = Q264_46, cbcl047 = Q264_47,
                  cbcl048 = Q264_48, cbcl049 = Q264_49, cbcl050 = Q264_50, cbcl051 = Q264_51, cbcl052 = Q264_52, cbcl053 = Q264_53,
                  cbcl054 = Q264_54, cbcl055 = Q264_55, cbcl056 = Q264_56, cbcl057 = Q264_57, cbcl058 = Q264_58, cbcl059 = Q264_59,
                  cbcl060 = Q264_60, cbcl061 = Q264_61, cbcl062 = Q264_62, cbcl063 = Q264_63, cbcl064 = Q264_64, cbcl065 = Q264_65,
                  cbcl066 = Q264_66, cbcl067 = Q264_67, cbcl068 = Q264_68, cbcl069 = Q264_69, cbcl070 = Q264_70, cbcl071 = Q264_71,
                  cbcl072 = Q264_72, cbcl073 = Q264_73, cbcl074 = Q264_74, cbcl075 = Q264_75, cbcl076 = Q264_76, cbcl077 = Q264_77,
                  cbcl078 = Q264_78, cbcl079 = Q264_79, cbcl080 = Q264_80, cbcl081 = Q264_81, cbcl082 = Q264_82, cbcl083 = Q264_83,
                  cbcl084 = Q264_84, cbcl085 = Q264_85, cbcl086 = Q264_86, cbcl087 = Q264_87, cbcl088 = Q264_88, cbcl089 = Q264_89,
                  cbcl090 = Q264_90, cbcl091 = Q264_91, cbcl092 = Q264_92, cbcl093 = Q264_93, cbcl094 = Q264_94, cbcl095 = Q264_95,
                  cbcl096 = Q264_96, cbcl097 = Q264_97, cbcl098 = Q264_98, cbcl099 = Q264_99, cbcl100 = Q264_100)

UPMC_CBCL <- select(UPMC_CBCL, FamID, cbcl001 = Q15.1_1, cbcl002 = Q15.1_2, cbcl003 = Q15.1_3, cbcl004 = Q15.1_4,cbcl005 = Q15.1_5,
                    cbcl006 = Q15.1_6, cbcl007 = Q15.1_7, cbcl008 = Q15.1_8, cbcl009 = Q15.1_9, cbcl010 = Q15.1_10, cbcl011 = Q15.1_11,
                    cbcl012 = Q15.1_12, cbcl013 = Q15.1_13, cbcl014 = Q15.1_14, cbcl015 = Q15.1_15, cbcl016 = Q15.1_16,
                    cbcl017 = Q15.1_17, cbcl018 = Q15.1_18, cbcl019 = Q15.1_19, cbcl020 = Q15.1_20, cbcl021 = Q15.1_21,
                    cbcl022 = Q15.1_22, cbcl023 = Q15.1_23, cbcl024 = Q15.1_24, cbcl025 = Q15.1_25, cbcl026 = Q15.1_26,
                    cbcl027 = Q15.1_27, cbcl028 = Q15.1_28, cbcl029 = Q15.1_29, cbcl030 = Q15.1_30, cbcl031 = Q15.1_31,
                    cbcl032 = Q15.1_32, cbcl033 = Q15.1_33, cbcl034 = Q15.1_34, cbcl035 = Q15.1_35, cbcl036 = Q15.1_36,
                    cbcl037 = Q15.1_37, cbcl038 = Q15.1_38, cbcl039 = Q15.1_39, cbcl040 = Q15.1_40, cbcl041 = Q15.1_41,
                    cbcl042 = Q15.1_42, cbcl043 = Q15.1_43, cbcl044 = Q15.1_44, cbcl045 = Q15.1_45, cbcl046 = Q15.1_46,
                    cbcl047 = Q15.1_47, cbcl048 = Q15.1_48, cbcl049 = Q15.1_49, cbcl050 = Q15.1_50, cbcl051 = Q15.1_51,
                    cbcl052 = Q15.1_52, cbcl053 = Q15.1_53, cbcl054 = Q15.1_54, cbcl055 = Q15.1_55, cbcl056 = Q15.1_56,
                    cbcl057 = Q15.1_57, cbcl058 = Q15.1_58, cbcl059 = Q15.1_59, cbcl060 = Q15.1_60, cbcl061 = Q15.1_61,
                    cbcl062 = Q15.1_62, cbcl063 = Q15.1_63, cbcl064 = Q15.1_64, cbcl065 = Q15.1_65, cbcl066 = Q15.1_66,
                    cbcl067 = Q15.1_67, cbcl068 = Q15.1_68, cbcl069 = Q15.1_69, cbcl070 = Q15.1_70, cbcl071 = Q15.1_71,
                    cbcl072 = Q15.1_72, cbcl073 = Q15.1_73, cbcl074 = Q15.1_74, cbcl075 = Q15.1_75, cbcl076 = Q15.1_76,
                    cbcl077 = Q15.1_77, cbcl078 = Q15.1_78, cbcl079 = Q15.1_79, cbcl080 = Q15.1_80, cbcl081 = Q15.1_81,
                    cbcl082 = Q15.1_82, cbcl083 = Q15.1_83, cbcl084 = Q15.1_84, cbcl085 = Q15.1_85, cbcl086 = Q15.1_86,
                    cbcl087 = Q15.1_87, cbcl088 = Q15.1_88, cbcl089 = Q15.1_89, cbcl090 = Q15.1_90, cbcl091 = Q15.1_91,
                    cbcl092 = Q15.1_92, cbcl093 = Q15.1_93, cbcl094 = Q15.1_94, cbcl095 = Q15.1_95, cbcl096 = Q15.1_96,
                    cbcl097 = Q15.1_97, cbcl098 = Q15.1_98, cbcl099 = Q15.1_99, cbcl100 = Q15.1_100)

CBCL <- rbind(UO_CBCL, UPMC_CBCL)
rm(UPMC_CBCL, UO_CBCL)
CBCL <- merge(ID_list, CBCL, by = "FamID", all.x=TRUE)

# Recode
CBCL[CBCL=="Not True (as far as you know)"] <- 0; 
CBCL[CBCL=="Somewhat or Sometimes True"] <- 1;
CBCL[CBCL=="Very True or Often True"] <- 2

CBCL[,2:101] <- sapply(CBCL[,2:101],as.numeric)

# Imputing
CBCL$OP_AVE <- rowMeans(CBCL[,c("cbcl003", "cbcl009", "cbcl011", "cbcl013", "cbcl014", "cbcl017", "cbcl025", "cbcl026", "cbcl028", 
                                "cbcl030", "cbcl031", "cbcl032", "cbcl034", "cbcl036", "cbcl041", "cbcl049", "cbcl050", "cbcl054", 
                                "cbcl055", "cbcl057", "cbcl060", "cbcl061", "cbcl063", "cbcl065", "cbcl072", "cbcl073", "cbcl075", 
                                "cbcl076", "cbcl077", "cbcl089", "cbcl091", "cbcl094")])
CBCL[130, "cbcl080"] = CBCL[130, "OP_AVE"]

# Score
CBCL$cbcl_ER <- rowSums(CBCL[, c("cbcl021", "cbcl046","cbcl051","cbcl079", "cbcl082", "cbcl083", "cbcl092", "cbcl097", "cbcl099")])
CBCL$cbcl_AD <- rowSums(CBCL[, c("cbcl010","cbcl033","cbcl037","cbcl043","cbcl047","cbcl068","cbcl087","cbcl090")])
CBCL$cbcl_SC <- rowSums(CBCL[, c("cbcl001", "cbcl007", "cbcl012", "cbcl019", "cbcl024", "cbcl039", "cbcl045", "cbcl052", "cbcl078", 
                                 "cbcl086", "cbcl093")])

CBCL$cbcl_W <- rowSums(CBCL[, c("cbcl002", "cbcl004", "cbcl023", "cbcl062", "cbcl067", "cbcl070", "cbcl071", "cbcl098")])
CBCL$cbcl_SP <- rowSums(CBCL[, c("cbcl022", "cbcl038", "cbcl048", "cbcl064", "cbcl074", "cbcl084")])

CBCL$cbcl_AP <- rowSums(CBCL[, c("cbcl005", "cbcl006", "cbcl056", "cbcl059", "cbcl095")])

CBCL$cbcl_AB <- rowSums(CBCL[, c("cbcl008", "cbcl015", "cbcl016", "cbcl018", "cbcl020", "cbcl027", "cbcl029", "cbcl035", "cbcl040", 
                                 "cbcl042", "cbcl044", "cbcl053", "cbcl058", "cbcl066", "cbcl069", "cbcl081", "cbcl085", "cbcl088", 
                                 "cbcl096")])

CBCL$cbcl_OP <- rowSums(CBCL[, c("cbcl003", "cbcl009", "cbcl011", "cbcl013", "cbcl014", "cbcl017", "cbcl025", "cbcl026", "cbcl028", 
                                 "cbcl030", "cbcl031", "cbcl032", "cbcl034", "cbcl036", "cbcl041", "cbcl049", "cbcl050", "cbcl054", 
                                 "cbcl055", "cbcl057", "cbcl060", "cbcl061", "cbcl063", "cbcl065", "cbcl072", "cbcl073", "cbcl075", 
                                 "cbcl076", "cbcl077", "cbcl080", "cbcl089", "cbcl091", "cbcl094")])

CBCL$cbcl_INT <- rowSums(CBCL[, c("cbcl021", "cbcl046", "cbcl051", "cbcl079", "cbcl082", "cbcl083", "cbcl092", "cbcl097", "cbcl099", 
                                  "cbcl010", "cbcl033", "cbcl037", "cbcl043", "cbcl047", "cbcl068", "cbcl087", "cbcl090", "cbcl001", 
                                  "cbcl007", "cbcl012", "cbcl019", "cbcl024", "cbcl039", "cbcl045", "cbcl052", "cbcl078", "cbcl086", 
                                  "cbcl093", "cbcl002", "cbcl004", "cbcl023", "cbcl062", "cbcl067", "cbcl070", "cbcl071", "cbcl098")])
CBCL$cbcl_EXT <- rowSums(CBCL[, c("cbcl005", "cbcl006", "cbcl056", "cbcl059", "cbcl095", "cbcl008", "cbcl015", "cbcl016", "cbcl018", 
                                  "cbcl020", "cbcl027", "cbcl029", "cbcl035", "cbcl040", "cbcl042", "cbcl044", "cbcl053", "cbcl058", 
                                  "cbcl066", "cbcl069", "cbcl081", "cbcl085", "cbcl088", "cbcl096")])

CBCL$cbcl_total <- rowSums(CBCL[, c("cbcl001", "cbcl002", "cbcl003", "cbcl004", "cbcl005", "cbcl006", "cbcl007", "cbcl008", "cbcl009",
                                    "cbcl010", "cbcl011", "cbcl012", "cbcl013", "cbcl014", "cbcl015", "cbcl016", "cbcl017", "cbcl018", 
                                    "cbcl019", "cbcl020", "cbcl021", "cbcl022", "cbcl023", "cbcl024", "cbcl025", "cbcl026", "cbcl027", 
                                    "cbcl028", "cbcl029", "cbcl030", "cbcl031", "cbcl032", "cbcl033", "cbcl034", "cbcl035", "cbcl036",
                                    "cbcl037", "cbcl038", "cbcl039", "cbcl040", "cbcl041", "cbcl042", "cbcl043", "cbcl044", "cbcl045",
                                    "cbcl046", "cbcl047", "cbcl048", "cbcl049", "cbcl050", "cbcl051", "cbcl052", "cbcl053", "cbcl054", 
                                    "cbcl055", "cbcl056", "cbcl057", "cbcl058", "cbcl059", "cbcl060", "cbcl061", "cbcl062", "cbcl063",
                                    "cbcl064", "cbcl065", "cbcl066", "cbcl067", "cbcl068", "cbcl069", "cbcl070", "cbcl071", "cbcl072", 
                                    "cbcl073", "cbcl074", "cbcl075", "cbcl076", "cbcl077", "cbcl078", "cbcl079", "cbcl080", "cbcl081",
                                    "cbcl082", "cbcl083", "cbcl084", "cbcl085", "cbcl086", "cbcl087", "cbcl088", "cbcl089", "cbcl090",
                                    "cbcl091", "cbcl092", "cbcl093", "cbcl094", "cbcl095", "cbcl096", "cbcl097", "cbcl098", "cbcl099")])
                                  
# Filter and Clean
CBCL_final <- select(CBCL,FamID,cbcl_ER,cbcl_AD,cbcl_SC,cbcl_W,cbcl_SP,cbcl_AP,cbcl_AB,cbcl_OP,cbcl_INT,cbcl_EXT,cbcl_total)

# Export
write.csv(CBCL_final, file = "Grace_Dissertation_Data/Grace_Dissertation_CBCL.csv")
rm(CBCL_final, CBCL)

# PKBS --------------------------------------------------------------------
# Import
UO_PKBS <- read.csv("Measures/UO_MS_T1.csv", stringsAsFactors = FALSE)
UPMC_PKBS <- read.csv("Measures/UPMC_PKBS_T1.csv", stringsAsFactors = FALSE)

# Merge
UO_PKBS <- select(UO_PKBS, FamID, pkbs01,	pkbs02,	pkbs03,	pkbs04,	pkbs05,	pkbs06,	pkbs07,	pkbs08,	pkbs09,	pkbs10,	pkbs11,	pkbs12,	pkbs13,	
                  pkbs14,	pkbs15,	pkbs16,	pkbs17,	pkbs18,	pkbs19,	pkbs20,	pkbs21,	pkbs22,	pkbs23,	pkbs24,	pkbs25,	pkbs26,	pkbs27,	pkbs28,
                  pkbs29,	pkbs30,	pkbs31,	pkbs32,	pkbs33)
UPMC_PKBS <- select(UPMC_PKBS, FamID, pkbs01,	pkbs02,	pkbs03,	pkbs04,	pkbs05,	pkbs06,	pkbs07,	pkbs08,	pkbs09,	pkbs10,	pkbs11,	pkbs12,	pkbs13,	
                  pkbs14,	pkbs15,	pkbs16,	pkbs17,	pkbs18,	pkbs19,	pkbs20,	pkbs21,	pkbs22,	pkbs23,	pkbs24,	pkbs25,	pkbs26,	pkbs27,	pkbs28,
                  pkbs29,	pkbs30,	pkbs31,	pkbs32,	pkbs33)
PKBS <- rbind(UO_PKBS, UPMC_PKBS)
rm(UPMC_PKBS, UO_PKBS)
PKBS <- merge(ID_list, PKBS, by = "FamID", all.x=TRUE)

# Recode and Score
PKBS[PKBS=="Never (0)"] <- 0
PKBS[PKBS=="Rarely (1)"] <- 1 
PKBS[PKBS=="Sometimes (2)"] <- 2 
PKBS[PKBS=="Often (3)"] <- 3

PKBS[,2:34] <- sapply(PKBS[,2:34],as.numeric)

PKBS$pkbs_total <- rowSums(PKBS[, c("pkbs01",	"pkbs02",	"pkbs03",	"pkbs04",	"pkbs05",	"pkbs06",	"pkbs07",	"pkbs08",	"pkbs09",	"pkbs10",
                                    "pkbs11",	"pkbs12",	"pkbs13",	"pkbs14",	"pkbs15",	"pkbs16",	"pkbs17",	"pkbs18",	"pkbs19",	"pkbs20",	
                                    "pkbs21",	"pkbs22",	"pkbs23",	"pkbs24",	"pkbs25",	"pkbs26",	"pkbs27",	"pkbs28", "pkbs29",	"pkbs30",	
                                    "pkbs31",	"pkbs32",	"pkbs33")])
# Filter and Clean
PKBS_final <- select(PKBS,FamID,pkbs_total)
PKBS_final[87,3]<-"Total cannot be calculated until we account for them answering 'Prefer not to answer'" 
PKBS_final[97,3]<-"Total cannot be calculated until we account for them answering 'Prefer not to answer'"
PKBS_final <- select(PKBS_final,FamID,pkbs_total,pkbs_notes = V3)
rm(PKBS)

# Export
write.csv(PKBS_final, file = "Grace_Dissertation_Data/Grace_Dissertation_PKBS.csv")
rm(PKBS_final)

# PAI-BOR -----------------------------------------------------------------
# Import
UO_PAIBOR <- read.csv("Measures/UO_PAIBOR.csv", stringsAsFactors = FALSE)
# UPMC_PAIBOR <- read.csv("Measures/UPMC_PAIBOR_T1.csv", stringsAsFactors = FALSE)

# Merge
PAIBOR <- select(UO_PAIBOR, FamID, paibor01, paibor02,	paibor03, paibor04, paibor05,	paibor06,	paibor07,	paibor08, paibor09,	paibor10,
                 paibor11, paibor12,	paibor13,	paibor14,	paibor15,	paibor16,	paibor17,	paibor18,	paibor19,	paibor20,	paibor21,	paibor22,
                 paibor23,	paibor24)
PAIBOR <- merge(ID_list, PAIBOR, by = "FamID", all.x=TRUE)

# Score
PAIBOR[,2:25] <- sapply(PAIBOR[,2:25],as.numeric)

PAIBOR$PAIBOR_total <- rowSums(PAIBOR[, c("paibor01", "paibor02",	"paibor03", "paibor04", "paibor05",	"paibor06",	"paibor07",	"paibor08", 
                                        "paibor09",	"paibor10",	"paibor11", "paibor12",	"paibor13",	"paibor14",	"paibor15",	"paibor16",
                                        "paibor17",	"paibor18",	"paibor19",	"paibor20",	"paibor21",	"paibor22", "paibor23",	"paibor24")])
# Filter and Clean

# Export

rm(UO_PAIBOR, PAIBOR)
# TRFs --------------------------------------------------------------------

# Import

# Merge

# Filter and Clean

# Export

# Complete






















# SIDP --------------------------------------------------------------------
# Import
UO_SIDP <- read.csv("Measures/UO_SIDP.csv", stringsAsFactors = FALSE)
UPMC_SIDP <- read.csv("Measures/UPMC_SIDP.csv", stringsAsFactors = FALSE)

# Merge Data with ID list
SIDP <- rbind(UO_SIDP, UPMC_SIDP)
SIDP <- merge(ID_list, SIDP,by = "FamID", all.x=TRUE)
SIDP$Group_Assignment <- Demographics_final$Group_Assignment

# Filter 
SIDP <- select(SIDP, FamID, Group_Assignment,6:86)


# Export 
#(SIDP, file = "Grace_Dissertation_Data/Grace_Dissertation_SIDP.csv")

rm(SIDP, UO_SIDP, UPMC_SIDP)





















