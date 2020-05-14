#Install Package, this only need to be done once.
install.packages("dplyr","tidyverse","eeptools")

#Load packages, this need to be done every time you run this script. 
library(dplyr)
library(tidyverse)
library(data.table)

#Import Pedigree and NDA Structure
Pedigree <- read.csv("Reference_Pedigree.csv")
NDA_PKBS <- read.csv("pkbs01_template.csv")

#Import PKBS files from both sites and every timepoint
UO_T1_PKBS <- read.csv("UO_T1_Qualtrics.csv", stringsAsFactors = FALSE)
UPMC_T1_PKBS <- read.csv("UPMC_T1_PKBS.csv", stringsAsFactors = FALSE)
UO_T2_PKBS <- read.csv("UO_T2_Qualtrics.csv", stringsAsFactors = FALSE)
UPMC_T2_PKBS <- read.csv("UPMC_T2_PKBS.csv", stringsAsFactors = FALSE)
UO_T3_PKBS <- read.csv("UO_T3_Qualtrics.csv", stringsAsFactors = FALSE)
UPMC_T3_PKBS <- read.csv("UPMC_T3_PKBS.csv", stringsAsFactors = FALSE)
UO_T4_PKBS <- read.csv("UO_T4_Qualtrics.csv", stringsAsFactors = FALSE)
UPMC_T4_PKBS <- read.csv("UPMC_T4_PKBS.csv", stringsAsFactors = FALSE)

#Rename variables that we want to select for PKBS
#Create list of new variable names
pkbs <- "srm_pkbs"
num_items <- seq(1:33)
new_PKBS_names <- paste(pkbs, num_items, sep='_')

#Now make a list of old variables names so that we can replace them with the neww ones
UO_Q407 <- "Q407"
UO_Q359 <- "Q359"
UO_Q524 <- "Q524"
UO_Q817 <- "Q817"
UPMC_Q16 <- "Q16.1"
UPMC_Q13 <- "Q13.1"
old_UO_PKBS_names <- paste(UO_Q407, num_items,sep = "_")
old_UO_PKBS_names2 <- paste(UO_Q359, num_items,sep = "_")
old_UO_PKBS_names3 <- paste(UO_Q524, num_items,sep = "_")
old_UO_PKBS_names4 <- paste(UO_Q817, num_items,sep = "_")
old_UPMC_PKBS_names <- paste(UPMC_Q16, num_items,sep = "_")
old_UPMC_PKBS_names2 <- paste(UPMC_Q13, num_items, sep = "_")

#Change UO column names
setnames(UO_T1_PKBS, old_UO_PKBS_names, new_PKBS_names, skip_absent=FALSE)
setnames(UO_T2_PKBS, old_UO_PKBS_names2, new_PKBS_names, skip_absent=FALSE)
setnames(UO_T3_PKBS, old_UO_PKBS_names3, new_PKBS_names, skip_absent=FALSE)
setnames(UO_T4_PKBS, old_UO_PKBS_names4, new_PKBS_names, skip_absent=FALSE)

#Change UPMC column names
setnames(UPMC_T1_PKBS, old_UPMC_PKBS_names, new_PKBS_names, skip_absent=FALSE)
setnames(UPMC_T2_PKBS, old_UPMC_PKBS_names2, new_PKBS_names, skip_absent=FALSE)
setnames(UPMC_T3_PKBS, old_UPMC_PKBS_names2, new_PKBS_names, skip_absent=FALSE)
setnames(UPMC_T4_PKBS, old_UPMC_PKBS_names, new_PKBS_names, skip_absent=FALSE)

#Edit UO PKBS Times 1-4 to have only PKBS questions and the FamID
UO_T1_PKBS <- select(UO_T1_PKBS, c(FamID = Q221, contains("pkbs")))
UO_T2_PKBS <- select(UO_T2_PKBS, c(FamID = Q116, contains("pkbs")))
UO_T3_PKBS <- select(UO_T3_PKBS, c(FamID = Q174, contains("pkbs")))
UO_T4_PKBS <- select(UO_T4_PKBS, c(FamID = Q203, contains("pkbs")))

#Edit UPMC PKBS Times 1-4 to have only PKBS questions and the FamID
UPMC_T1_PKBS <- select(UPMC_T1_PKBS, c(FamID = Q1.2, contains("pkbs")))
UPMC_T2_PKBS <- select(UPMC_T2_PKBS, c(FamID = Q1.2, contains("pkbs")))
UPMC_T3_PKBS <- select(UPMC_T3_PKBS, c(FamID = Q1.2, contains("pkbs")))
UPMC_T4_PKBS <- select(UPMC_T4_PKBS, c(FamID = Q1.2, contains("pkbs")))

#Merge UO and UPMC data by Timepoint
PKBS_T1 <- rbind(UO_T1_PKBS, UPMC_T1_PKBS)
PKBS_T2 <- rbind(UO_T2_PKBS, UPMC_T2_PKBS)
PKBS_T3 <- rbind(UO_T3_PKBS, UPMC_T3_PKBS)
PKBS_T4 <- rbind(UO_T4_PKBS, UPMC_T4_PKBS)

#Clean up environment
rm(UO_T1_PKBS, UO_T2_PKBS, UO_T3_PKBS, UO_T4_PKBS, UPMC_T1_PKBS, UPMC_T2_PKBS, UPMC_T3_PKBS, UPMC_T4_PKBS)

#Create the Pedigree table for each timepoint
Pedigree_T1 <- select(Pedigree, FamID, FamID_Mother, mom_guid, MomGender, Time1Date, MomAge_T1)
Pedigree_T2 <- select(Pedigree, FamID, FamID_Mother, mom_guid, MomGender, Time1Date, MomAge_T2)
Pedigree_T3 <- select(Pedigree, FamID, FamID_Mother, mom_guid, MomGender, Time1Date, MomAge_T3)
Pedigree_T4 <- select(Pedigree, FamID, FamID_Mother, mom_guid, MomGender, Time1Date, MomAge_T4)

#Merge Pedigree data to PKBS timepoints
PKBS_T1 <- merge(Pedigree_T1, PKBS_T1, by = "FamID")
PKBS_T2 <- merge(Pedigree_T2, PKBS_T2, by = "FamID")
PKBS_T3 <- merge(Pedigree_T3, PKBS_T3, by = "FamID")
PKBS_T4 <- merge(Pedigree_T4, PKBS_T4, by = "FamID")

#Clean up environment
rm(Pedigree, Pedigree_T1, Pedigree_T2, Pedigree_T3, Pedigree_T4)

#Create new column designating time point for each database
PKBS_T1$Timepoint <- "Time 1"
PKBS_T2$Timepoint <- "Time 2"
PKBS_T3$Timepoint <- "Time 3"
PKBS_T4$Timepoint <- "Time 4"

#Rename each of the Date and Age columns so that they match
PKBS_T1 <- PKBS_T1 %>% rename( interview_date = Time1Date, interview_age = MomAge_T1)
PKBS_T2 <- PKBS_T2 %>% rename( interview_date = Time1Date, interview_age = MomAge_T2)
PKBS_T3 <- PKBS_T3 %>% rename( interview_date = Time1Date, interview_age = MomAge_T3)
PKBS_T4 <- PKBS_T4 %>% rename( interview_date = Time1Date, interview_age = MomAge_T4)

#Merge all timepoints together to create the PKBS prep sheet
PKBS_Prep <- rbind(PKBS_T1, PKBS_T2, PKBS_T3, PKBS_T4)

#Clean up environment
rm(PKBS_T1, PKBS_T2, PKBS_T3, PKBS_T4)

#Turn Likert Scale from text string to numeric value
PKBS_Prep[PKBS_Prep == "Never (0)"] <- 0; PKBS_Prep[PKBS_Prep == "Rarely (1)"] <- 1;
PKBS_Prep[PKBS_Prep == "Sometimes (2)"] <- 2; PKBS_Prep[PKBS_Prep == "Often (3)"] <- 3;

# Change number to numeric values and Create Calculated Column 
PKBS_Prep[,7:39] <- sapply(PKBS_Prep[,7:39],as.numeric)