# Measure: ders | Author: Bryan | Lasted Edited: 4/23/2020 By: Bryan

# Import Packages Needed
library(dplyr)
library(tidyverse)
library(eeptools)
library(data.table)

# Import Pedigree and NDA Structure
Pedigree <- read.csv("Reference_Pedigree.csv")
NDA_ders <- read.csv("ders01_template.csv")

# Import ders Files
UO_T1_ders <- read.csv(file = 'UO_T1_Qualtrics.csv', stringsAsFactors = FALSE)
UO_T2_ders <- read.csv(file = 'UO_T2_Qualtrics.csv', stringsAsFactors = FALSE)
UO_T3_ders <- read.csv(file = 'UO_T3_Qualtrics.csv', stringsAsFactors = FALSE)
UO_T4_ders <- read.csv(file = 'UO_T4_Qualtrics.csv', stringsAsFactors = FALSE)
UPMC_T1_ders <- read.csv(file = 'UPMC_T1_ders.csv', stringsAsFactors = FALSE)
UPMC_T2_ders <- read.csv(file = 'UPMC_T2_ders.csv', stringsAsFactors = FALSE)
UPMC_T3_ders <- read.csv(file = 'UPMC_T3_ders.csv', stringsAsFactors = FALSE)
UPMC_T4_ders <- read.csv(file = 'UPMC_T4_ders.csv', stringsAsFactors = FALSE)

# Create list of new variable names 
ders <- "srm_ders"
num_items <- seq(1:36)
new_ders_names <- paste(ders, num_items, sep='_')

# Create list of old variable names so we can replace them with the new ones 
UO_ders_Item <- "Q137"
UPMC_ders_Item <- "Q6.1"
old_UO_ders_names <- paste(UO_ders_Item, num_items, sep = "_")
old_UPMC_ders_names <- paste(UPMC_ders_Item, num_items, sep = "_")

# Replace UO column names 
setnames(UO_T1_ders, old_UO_ders_names, new_ders_names)
setnames(UO_T2_ders, old_UO_ders_names, new_ders_names)
setnames(UO_T3_ders, old_UO_ders_names, new_ders_names)
setnames(UO_T4_ders, old_UO_ders_names, new_ders_names)

# Replace UPMC column names
setnames(UPMC_T1_ders, old_UPMC_ders_names, new_ders_names)
setnames(UPMC_T2_ders, old_UPMC_ders_names, new_ders_names)
setnames(UPMC_T3_ders, old_UPMC_ders_names, new_ders_names)
setnames(UPMC_T4_ders, old_UPMC_ders_names, new_ders_names)

# Edit UO ders Time 1 - 4 to have only ders quesions and the FamID. 
UO_T1_ders <- select(UO_T1_ders, c(FamID = Q221, contains("ders")))
UO_T2_ders <- select(UO_T2_ders, c(FamID = Q116, contains("ders")))
UO_T3_ders <- select(UO_T3_ders, c(FamID = Q174, contains("ders")))
UO_T4_ders <- select(UO_T4_ders, c(FamID = Q203, contains("ders")))

# Edit UPMC ders Time 1 - 4 to have only ders quesions and the FamID.
UPMC_T1_ders <- select(UPMC_T1_ders, c(FamID = Q1.2, contains("ders")))
UPMC_T2_ders <- select(UPMC_T2_ders, c(FamID = Q1.2, contains("ders")))
UPMC_T3_ders <- select(UPMC_T3_ders, c(FamID = Q1.2, contains("ders")))
UPMC_T4_ders <- select(UPMC_T4_ders, c(FamID = Q1.2, contains("ders")))

# Bind UO and UPMC ders Data By Time Point
ders_T1 <- rbind(UO_T1_ders, UPMC_T1_ders)
ders_T2 <- rbind(UO_T2_ders, UPMC_T2_ders)
ders_T3 <- rbind(UO_T3_ders, UPMC_T3_ders)
ders_T4 <- rbind(UO_T4_ders, UPMC_T4_ders)

# Clean Global Enviorment 
rm(UO_T1_ders, UO_T2_ders, UO_T3_ders, UO_T4_ders, UPMC_T1_ders, UPMC_T2_ders, UPMC_T3_ders, UPMC_T4_ders)

# Create the Predigree data for each Time Point
Pedigree_T1 <- select(Pedigree, FamID, FamID_Mother, mom_guid, MomGender, Time1Date, MomAge_T1)
Pedigree_T2 <- select(Pedigree, FamID, FamID_Mother, mom_guid, MomGender, Time2Date, MomAge_T2)
Pedigree_T3 <- select(Pedigree, FamID, FamID_Mother, mom_guid, MomGender, Time3Date, MomAge_T3)
Pedigree_T4 <- select(Pedigree, FamID, FamID_Mother, mom_guid, MomGender, Time4Date, MomAge_T4)

# Merge Pedigree data to ders Time Points
ders_T1 <- merge(Pedigree_T1, ders_T1, by = 'FamID')
ders_T2 <- merge(Pedigree_T2, ders_T2, by = 'FamID')
ders_T3 <- merge(Pedigree_T3, ders_T3, by = 'FamID')
ders_T4 <- merge(Pedigree_T4, ders_T4, by = 'FamID')

# Clean Global Enviorment 
rm(Pedigree, Pedigree_T1, Pedigree_T2, Pedigree_T3, Pedigree_T4)

# Create Time Point coloumn in each ders Sheet and populate the cell with time point
ders_T1$timepoint <- "Time 1"
ders_T2$timepoint <- "Time 2"
ders_T3$timepoint <- "Time 3"
ders_T4$timepoint <- "Time 4"

# Rename each of the ders Date and Age coloumns so they match
ders_T1 <- ders_T1 %>% rename( interview_date = Time1Date, interview_age = MomAge_T1)
ders_T2 <- ders_T2 %>% rename( interview_date = Time2Date, interview_age = MomAge_T2)
ders_T3 <- ders_T3 %>% rename( interview_date = Time3Date, interview_age = MomAge_T3)
ders_T4 <- ders_T4 %>% rename( interview_date = Time4Date, interview_age = MomAge_T4)

# Bind all ders Time Points togeather creating the DERS_Prep sheet
DERS_Prep <- rbind(ders_T1, ders_T2, ders_T3, ders_T4)

# Clean Global Enviorment 
rm(ders_T1, ders_T2, ders_T3, ders_T4)

#TODO: Prefer not to answer now as NA?
DERS_Prep <- DERS_Prep %>% 
  mutate_at(new_ders_names,
            funs(recode(., "Almost Never (0-10%)" = 1, 
                        "Sometimes (11%-35%)" = 2,
                        "About half the time (36%-65%)" = 3,
                        "Most of the time (66-90%)" = 4,
                        "Almost Always (91-100%)" = 5,.default = NaN)))

# Rename the reverse scored columns 
DERS_Prep <- rename(DERS_Prep, srm_ders_1r = srm_ders_1, srm_ders_2r = srm_ders_2, srm_ders_6r = srm_ders_6, 
                    srm_ders_7r = srm_ders_7, srm_ders_8r = srm_ders_8, srm_ders_10r = srm_ders_10, srm_ders_17r = srm_ders_17,
                    srm_ders_20r = srm_ders_20, srm_ders_22r = srm_ders_22, srm_ders_24r = srm_ders_24, srm_ders_34r = srm_ders_34)

# Reverse score certain items
DERS_Prep <- DERS_Prep %>% 
  mutate_at(c("srm_ders_1r", "srm_ders_2r", "srm_ders_6r", "srm_ders_7r", "srm_ders_8r", "srm_ders_10r", "srm_ders_17r", "srm_ders_20r", 
              "srm_ders_22r", "srm_ders_24r", "srm_ders_34r"),
            funs(recode(., "1" = 5, 
                        '2' = 4,
                        '3' = 3,
                        '4' = 2,
                        '5' = 1,.default = NaN)))

# Craeted calcualted columns
DERS_Prep <- add_column(DERS_Prep, ders_awareness = rowSums(DERS_Prep[, c("srm_ders_2r", "srm_ders_6r", "srm_ders_8r", "srm_ders_10r", 
                                                                          "srm_ders_17r", "srm_ders_34r")]),.after = "srm_ders_36")

DERS_Prep <- add_column(DERS_Prep, ders_clarity = rowSums(DERS_Prep[, c("srm_ders_1r", "srm_ders_4", "srm_ders_5", "srm_ders_7r",
                                                                        "srm_ders_9")]),.after = "ders_awareness")

DERS_Prep <- add_column(DERS_Prep, ders_goals = rowSums(DERS_Prep[, c("srm_ders_13", "srm_ders_18", "srm_ders_20r", "srm_ders_26",
                                                                      "srm_ders_33")]),.after = "ders_clarity")

DERS_Prep <- add_column(DERS_Prep, ders_impulse = rowSums(DERS_Prep[, c("srm_ders_3", "srm_ders_14", "srm_ders_19", "srm_ders_24r", 
                                                                        "srm_ders_27", "srm_ders_32")]),.after = "ders_goals")

DERS_Prep <- add_column(DERS_Prep, ders_nonacceptance = rowSums(DERS_Prep[, c("srm_ders_11", "srm_ders_12", "srm_ders_21", "srm_ders_23",
                                                                              "srm_ders_25", "srm_ders_29")]),.after = "ders_impulse")

DERS_Prep <- add_column(DERS_Prep, ders_strategies = rowSums(DERS_Prep[, c("srm_ders_15", "srm_ders_16", "srm_ders_22r", "srm_ders_28",
                                                                           "srm_ders_30", "srm_ders_31", "srm_ders_35", "srm_ders_36")]),
                                                                          .after = "ders_nonacceptance")

DERS_Prep <- add_column(DERS_Prep, ders_total = rowSums(DERS_Prep[, c("srm_ders_1r", "srm_ders_2r", "srm_ders_3", "srm_ders_4", "srm_ders_5", 
                                                                      "srm_ders_6r", "srm_ders_7r", "srm_ders_8r", "srm_ders_9", "srm_ders_10r",
                                                                      "srm_ders_11", "srm_ders_12", "srm_ders_13", "srm_ders_14", "srm_ders_15",
                                                                      "srm_ders_16", "srm_ders_17r", "srm_ders_18", "srm_ders_19", "srm_ders_20r", 
                                                                      "srm_ders_21", "srm_ders_22r", "srm_ders_23", "srm_ders_24r", "srm_ders_25", 
                                                                      "srm_ders_26", "srm_ders_27", "srm_ders_28", "srm_ders_29", "srm_ders_30", 
                                                                      "srm_ders_31", "srm_ders_32", "srm_ders_33", "srm_ders_34r", "srm_ders_35", 
                                                                      "srm_ders_36")]),.after = "ders_strategies")

# Reorder the DERS_Prep sheet 






