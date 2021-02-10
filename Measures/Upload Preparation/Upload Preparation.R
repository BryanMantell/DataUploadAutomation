#!/usr/bin/env Rscript 
# NDA UPLOAD PREPARATION
# Download redcap data (copy TOKEN from redcap)
# Min Zhang - Feb 7, 2021
# *************************************************************************


# *************************************************************************
# Load Libraries ####
# *************************************************************************
# Install package if needed
#install.packages("RCurl", "data.table")
library(RCurl) 
library(tidyverse)
library(data.table)
library(knitr)
library(kableExtra)
library(dplyr)
#library(redcapAPI)

# Empty Global Environment
rm(list = ls())
# *************************************************************************
# Import Pedigree Data####
# *************************************************************************
Pedigree <- read.csv("Reference_Pedigree.csv", stringsAsFactors = FALSE)



# *************************************************************************
# Import RedCap Data####
# *************************************************************************
# Download RedCap Data
# reference https://redcap-prod.uoregon.edu/redcap/api/help/?content=exp_reports
# result <- postForm(
#   uri = 'https://redcap.uoregon.edu/api/',
#   token = '',
#   content = 'report',
#   format = 'csv',
#   report_id = '637',
#   rawOrLabel = 'raw',
#   rawOrLabelHeaders = 'raw',
#   exportCheckboxLabel = 'false',
#   returnFormat = 'csv'
# )
# print(result)

# practice
result <- postForm(
  uri = 'https://redcap-prod.uoregon.edu/redcap/api/',
  token = '',
  content = 'report',
  format = 'csv',
  report_id = '71',
  csvDelimiter = '',
  rawOrLabel = 'raw',
  rawOrLabelHeaders = 'raw',
  exportCheckboxLabel = 'false',
  returnFormat = 'csv'
)
print(result)

# Convert Download Data into data frame
Result_con <- textConnection(result) 
Redcap_Data <- read.csv(Result_con)


# *************************************************************************
# Import Qualtrics Data####
# *************************************************************************
UO_Qualtrics_T1 <- read.csv("UO_T1_Qualtrics.csv", stringsAsFactors = FALSE)
UO_Qualtrics_T2 <- read.csv("UO_T2_Qualtrics.csv", stringsAsFactors = FALSE)
UO_Qualtrics_T3 <- read.csv("UO_T3_Qualtrics.csv", stringsAsFactors = FALSE)
UO_Qualtrics_T4 <- read.csv("UO_T4_Qualtrics.csv", stringsAsFactors = FALSE)

# TODO: Read in actual UPMC Qualtrics Data
UPMC_Qualtrics_T1 <- read.csv("UPMC_T1_Qualtrics.csv", stringsAsFactors = FALSE)
UPMC_Qualtrics_T2 <- read.csv("UPMC_T2_Qualtrics.csv", stringsAsFactors = FALSE)
UPMC_Qualtrics_T3 <- read.csv("UPMC_T3_Qualtrics.csv", stringsAsFactors = FALSE)
UPMC_Qualtrics_T4 <- read.csv("UPMC_T4_Qualtrics.csv", stringsAsFactors = FALSE)


# *************************************************************************
# Import NDA template####
# *************************************************************************
# TODO:


# *************************************************************************
# Pedigree Preparation ####
# *************************************************************************
# Select relevant pedigree information, rename as needed. (Include GroupAssignment for treatment progress calculation.)
# TODO: add subjectkey = mom_guid, src_subject_id = mother_FamID, sex = mother_sex ,interview_age, interview_date for NDA 
Pedigree_T1 <- data.frame(select(Pedigree, Fam_ID = FamID, child_guid, child_famID = FamID_Child, interview_date = Time1Date, interview_age = MomAge_T1, child_sex = ChildGender, GroupAssignment), Timepoint = 1 )
Pedigree_T2 <- data.frame(select(Pedigree, Fam_ID = FamID, child_guid, child_famID = FamID_Child, interview_date = Time2Date, interview_age = MomAge_T2, child_sex = ChildGender, GroupAssignment), Timepoint = 2 )
Pedigree_T3 <- data.frame(select(Pedigree, Fam_ID = FamID, child_guid, child_famID = FamID_Child, interview_date = Time3Date, interview_age = MomAge_T3, child_sex = ChildGender, GroupAssignment), Timepoint = 3 )
Pedigree_T4 <- data.frame(select(Pedigree, Fam_ID = FamID, child_guid, child_famID = FamID_Child, interview_date = Time4Date, interview_age = MomAge_T4, child_sex = ChildGender, GroupAssignment), Timepoint = 4 )

# Merge 4 pedigree
Pedigree <- rbind(Pedigree_T1, Pedigree_T2, Pedigree_T3, Pedigree_T4)

#Clean Environment
rm(Pedigree_T1, Pedigree_T2, Pedigree_T3, Pedigree_T4)


# *************************************************************************
# RedCap Preparation ####
# *************************************************************************
# Assign Timepoint base on redcap_event_name
#Redcap_Data$Timepoint = sapply(strsplit(as.character(Redcap_Data$redcap_event_name), split = '_', fixed = T), function(x) (x[2])) 
#RedCap_Data <- merge(Pedigree_Prep, Redcap_Data_raw, by = c("Timepoint","Fam_ID"), all = TRUE)

# TODO: Rename RedCap Variable name 


# *************************************************************************
# Qualtric Preparation ####
# *************************************************************************
# Fix Fam_ID and Timepoint variable name
# Edit UPMC Time 1 - 4: Change FQ4id column to FamID. Add Timepoint column
UPMC_Qualtrics_T1 <- UPMC_Qualtrics_T1 %>% rename(Fam_ID = FQ4id) %>% mutate(Timepoint = "1")
UPMC_Qualtrics_T2 <- UPMC_Qualtrics_T2 %>% rename(Fam_ID = FQ4id) %>% mutate(Timepoint = "2")
UPMC_Qualtrics_T3 <- UPMC_Qualtrics_T3 %>% rename(Fam_ID = FQ4id) %>% mutate(Timepoint = "3")
UPMC_Qualtrics_T4 <- UPMC_Qualtrics_T4 %>% rename(Fam_ID = FQ4id) %>% mutate(Timepoint = "4")

UO_Qualtrics_T1 <- UO_Qualtrics_T1 %>% rename(Fam_ID = Q221, Timepoint = Q146) 
UO_Qualtrics_T2 <- UO_Qualtrics_T2 %>% rename(Fam_ID = Q116, Timepoint = Q117)
UO_Qualtrics_T3 <- UO_Qualtrics_T3 %>% rename(Fam_ID = Q174, Timepoint = Q176)
UO_Qualtrics_T4 <- UO_Qualtrics_T4 %>% rename(Fam_ID = Q203, Timepoint = Q206)

# Bind 4 time points from two site 
# TODO: Need to find a way to merge UO and UPMC Qualtrics, due to different variable names cross site
# TODO: Bind doesn't work for now because Variabl name different cross sit 
UPMC_Qualtrics <- bind_rows(UPMC_Qualtrics_T1, UPMC_Qualtrics_T2, UPMC_Qualtrics_T3, UPMC_Qualtrics_T4)
UO_Qualtrics <- bind_rows(UO_Qualtrics_T1, UO_Qualtrics_T2, UO_Qualtrics_T3, UO_Qualtrics_T4)

# Merge CCNES data with pedigree
# TODO: Doesn't seem right with fake data each Fam_ID appears 10 times 
UPMC_Qualtrics <- merge(UPMC_Qualtrics, Pedigree, by = "Fam_ID")
UO_Qualtrics <- merge(UO_Qualtrics, Pedigree, by = "Fam_ID")


#TODO: will be removed 
UPMC_Qualtrics <- UPMC_Qualtrics %>%
  mutate_all(as.character)
UO_Qualtrics <- UO_Qualtrics %>%
  mutate_all(as.character)

# Change gender to F instead of False
UPMC_Qualtrics$mother_sex <- "F"
UO_Qualtrics$mother_sex <- "F"

# Clean global Environment
rm(UO_Qualtrics_T1, UO_Qualtrics_T2, UO_Qualtrics_T3, UO_Qualtrics_T4, 
   UPMC_Qualtrics_T1, UPMC_Qualtrics_T2, UPMC_Qualtrics_T3, UPMC_Qualtrics_T4)

# *************************************************************************
# CCNES Rename ####
# *************************************************************************
# Old UO name: Q140_1 ~ Q151_3
# Old UPMC name: FQ4CCNES_1 ~ FQ4CCNES_6, FQ4CCNES2_1 ~ FQ4CCNES12_6
# TODO: Check does UPMC variable names consistent cross timepoint
# 
# New CCNES name: srm_CCNES_01 ~ srm_CCNES_72
# NDA name: pabq1a ~ pabq12f

# OLD UO CCNES Column Names 
# for each item in UO paste number 1 to 6, "sprintf" used to format string
old_UO_CCNES_names <- c()
for (i in sprintf("Q%03d",140:151)) {
  ccnes_name <- paste(i, 1:6, sep = "_")
  old_UO_CCNES_names <- c(old_UO_CCNES_names, ccnes_name)
}

# OLD UPMC CCNES Column Names
old_UPMC_CCNES_names <- c()
old_UPMC_CCNES_names <- paste("FQ4CCNES",1:6, sep = "_")

for (i in sprintf("FQ4CCNES",2:12)) {
  ccnes_name <- paste(i,2:12, sep = "")
}
for (n in ccnes_name) {
  ccnes_name_1 <- paste(n,1:6,sep = "_")
  old_UPMC_CCNES_names <- c(old_UPMC_CCNES_names, ccnes_name_1)
}

# CCNES Prep Column Names
new_CCNES_names <- sprintf("srm_CCNES_%02d",1:72)

# NDA structure Column Names #
# pabq <- paste("pabq",1:12, sep = "")
# NDA_Names <- c()
# for (i in pabq) {
#   Name <- paste(i, letters[seq(1:6)], sep = "")
#   NDA_Names <- c(NDA_Names, Name)
# }

# Replace UO&UPMC column names
setnames(UO_Qualtrics, old_UO_CCNES_names, new_CCNES_names)
setnames(UPMC_Qualtrics, old_UPMC_CCNES_names, new_CCNES_names)

# Clean environment 
rm(i, n, ccnes_name, ccnes_name_1, old_UPMC_CCNES_names, old_UO_CCNES_names)



# *************************************************************************
# SCIP Rename ####
# *************************************************************************


# *************************************************************************
# SID-P Rename ####
# *************************************************************************


# *************************************************************************
# PPVT Rename ####
# *************************************************************************


# *************************************************************************
# DERS Rename ####
# *************************************************************************


# *************************************************************************
# CBCL Rename ####
# *************************************************************************


# *************************************************************************
# CCNES Rename ####
# *************************************************************************


# *************************************************************************
# AAQ Rename ####
# *************************************************************************

# *************************************************************************
# WCCL Rename ####
# *************************************************************************


# *************************************************************************
# PKBS Rename ####
# *************************************************************************


# *************************************************************************
# Bear Dragon Rename ####
# *************************************************************************


# *************************************************************************
# Affect Perspective Taking Rename ####
# *************************************************************************


# *************************************************************************
# Dimensional Card Sort Rename ####
# *************************************************************************


# *************************************************************************
# Emotion Labeling Rename ####
# *************************************************************************


# *************************************************************************
# Emotion Strategies Rename ####
# *************************************************************************

# Note ####
# *************************************************************************
print("Output list: Pedigree, UO_Qualtrics, UPMC_Qualtrics")
cat('CCNES variable names updated: contains("CCNES")')






