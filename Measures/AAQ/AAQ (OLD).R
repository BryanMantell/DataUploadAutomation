# Measure: AAQ | Author: Bryan | Lasted Edited: 4/22/2020 By: Bryan

# Import Packages Needed
library(dplyr)
library(tidyverse)
library(eeptools)
library(data.table)

# Import Pedigree and NDA Structure
Pedigree <- read.csv("Reference_Pedigree.csv")
NDA_AAQ <- read.csv("acceptance01_template.csv", skip = 1)

write.csv(NDA_AAQ, "acceptance01_template.csv")

# Import AAQ Files 
UO_T1_AAQ <- read.csv("UO_T1_Qualtrics.csv", stringsAsFactors = FALSE)
UPMC_T1_AAQ <- read.csv("UPMC_T1_AAQ.csv", stringsAsFactors = FALSE)
UO_T2_AAQ <- read.csv("UO_T2_Qualtrics.csv", stringsAsFactors = FALSE)
UPMC_T2_AAQ <- read.csv("UPMC_T2_AAQ.csv", stringsAsFactors = FALSE)
UO_T3_AAQ <- read.csv("UO_T3_Qualtrics.csv", stringsAsFactors = FALSE)
UPMC_T3_AAQ <- read.csv("UPMC_T3_AAQ.csv", stringsAsFactors = FALSE)
UO_T4_AAQ <- read.csv("UO_T4_Qualtrics.csv", stringsAsFactors = FALSE)
UPMC_T4_AAQ <- read.csv("UPMC_T4_AAQ.csv", stringsAsFactors = FALSE)

# Create list of new variable names 
aaq <- "srm_aaq"
num_items <- seq(1:10)
new_AAQ_names <- paste(aaq, num_items, sep='_')

# Create list of old variable names so we can replace them with the new ones 
UO_Q154 <- "Q154"
UPMC_Q4 <- "Q4.1"
old_UO_AAQ_names <- paste(UO_Q154, num_items, sep = "_")
old_UPMC_AAQ_names <- paste(UPMC_Q4, num_items, sep = "_")

# Replace UO column names 
setnames(UO_T1_AAQ, old_UO_AAQ_names, new_AAQ_names)
setnames(UO_T2_AAQ, old_UO_AAQ_names, new_AAQ_names)
setnames(UO_T3_AAQ, old_UO_AAQ_names, new_AAQ_names)
setnames(UO_T4_AAQ, old_UO_AAQ_names, new_AAQ_names)

# Replace UPMC column names
setnames(UPMC_T1_AAQ, old_UPMC_AAQ_names, new_AAQ_names)
setnames(UPMC_T2_AAQ, old_UPMC_AAQ_names, new_AAQ_names)
setnames(UPMC_T3_AAQ, old_UPMC_AAQ_names, new_AAQ_names)
setnames(UPMC_T4_AAQ, old_UPMC_AAQ_names, new_AAQ_names)

# Edit UO AAQ Time 1 - 4 to have only AAQ quesions and the FamID. 
UO_T1_AAQ <- select(UO_T1_AAQ, c(FamID = Q221, contains("aaq")))
UO_T2_AAQ <- select(UO_T2_AAQ, c(FamID = Q116, contains("aaq")))
UO_T3_AAQ <- select(UO_T3_AAQ, c(FamID = Q174, contains("aaq")))
UO_T4_AAQ <- select(UO_T4_AAQ, c(FamID = Q203, contains("aaq")))
  
# Edit UPMC AAQ Time 1 - 4 to have only AAQ quesions and the FamID.
UPMC_T1_AAQ <- select(UPMC_T1_AAQ, c(FamID = Q1.2, contains("aaq")))
UPMC_T2_AAQ <- select(UPMC_T2_AAQ, c(FamID = Q1.2, contains("aaq")))
UPMC_T3_AAQ <- select(UPMC_T3_AAQ, c(FamID = Q1.2, contains("aaq")))
UPMC_T4_AAQ <- select(UPMC_T4_AAQ, c(FamID = Q1.2, contains("aaq")))

# Bind UO and UPMC AAQ Data By Time Point
AAQ_T1 <- rbind(UO_T1_AAQ, UPMC_T1_AAQ)
AAQ_T2 <- rbind(UO_T2_AAQ, UPMC_T2_AAQ)
AAQ_T3 <- rbind(UO_T3_AAQ, UPMC_T3_AAQ)
AAQ_T4 <- rbind(UO_T4_AAQ, UPMC_T4_AAQ)

# Clean Global Enviorment 
rm(UO_T1_AAQ, UO_T2_AAQ, UO_T3_AAQ, UO_T4_AAQ, UPMC_T1_AAQ, UPMC_T2_AAQ, UPMC_T3_AAQ, UPMC_T4_AAQ)

# Create the Predigree data for each Time Point
Pedigree_T1 <- select(Pedigree, FamID, FamID_Mother, mom_guid, MomGender, Time1Date, MomAge_T1)
Pedigree_T2 <- select(Pedigree, FamID, FamID_Mother, mom_guid, MomGender, Time2Date, MomAge_T2)
Pedigree_T3 <- select(Pedigree, FamID, FamID_Mother, mom_guid, MomGender, Time3Date, MomAge_T3)
Pedigree_T4 <- select(Pedigree, FamID, FamID_Mother, mom_guid, MomGender, Time4Date, MomAge_T4)

# Merge Pedigree data to AAQ Time Points
AAQ_T1 <- merge(Pedigree_T1, AAQ_T1, by = 'FamID')
AAQ_T2 <- merge(Pedigree_T2, AAQ_T2, by = 'FamID')
AAQ_T3 <- merge(Pedigree_T3, AAQ_T3, by = 'FamID')
AAQ_T4 <- merge(Pedigree_T4, AAQ_T4, by = 'FamID')

# Clean Global Enviorment 
rm(Pedigree, Pedigree_T1, Pedigree_T2, Pedigree_T3, Pedigree_T4)

# Create Time Point coloumn in each AAQ Sheet and populate the cell with time point
AAQ_T1$timepoint <- "Time 1"
AAQ_T2$timepoint <- "Time 2"
AAQ_T3$timepoint <- "Time 3"
AAQ_T4$timepoint <- "Time 4"

# Rename each of the AAQ Date and Age coloumns so they match
AAQ_T1 <- AAQ_T1 %>% rename( interview_date = Time1Date, interview_age = MomAge_T1)
AAQ_T2 <- AAQ_T2 %>% rename( interview_date = Time2Date, interview_age = MomAge_T2)
AAQ_T3 <- AAQ_T3 %>% rename( interview_date = Time3Date, interview_age = MomAge_T3)
AAQ_T4 <- AAQ_T4 %>% rename( interview_date = Time4Date, interview_age = MomAge_T4)

# Bind all AAQ Time Points togeather creating the AAQ_Prep sheet
AAQ_Prep <- rbind(AAQ_T1, AAQ_T2, AAQ_T3, AAQ_T4)

# Clean Global Enviorment 
rm(AAQ_T1, AAQ_T2, AAQ_T3, AAQ_T4)

# Recode the strings of text to numbers
AAQ_Prep[AAQ_Prep == "1 Never True"] <- 1; AAQ_Prep[AAQ_Prep == "2 Very Rarely True"] <- 2;
AAQ_Prep[AAQ_Prep == "3 Seldom True"] <- 3; AAQ_Prep[AAQ_Prep == "4 Sometimes True"] <- 4;
AAQ_Prep[AAQ_Prep == "5 Often True"] <- 5; AAQ_Prep[AAQ_Prep == "6 Almost Always True"] <- 6;
AAQ_Prep[AAQ_Prep == "7 Always True"] <- 7

# Change number to numeric values and Create Calculated Column 
AAQ_Prep[,7:16] <- sapply(AAQ_Prep[,7:16],as.numeric)

AAQ_Prep <- add_column(AAQ_Prep, aaq_total = rowSums(AAQ_Prep[, c("srm_aaq_01", "srm_aaq_02","srm_aaq_03","srm_aaq_04", "srm_aaq_05", "srm_aaq_06", 
                                          "srm_aaq_07", "srm_aaq_08", "srm_aaq_09", "srm_aaq_10")]),.after = "srm_aaq_10")

# Reorder the AAQ_Prep sheet 






