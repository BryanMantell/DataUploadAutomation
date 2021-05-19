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
# scientific notation, round up to 3 digits
options(digits = 3)
#setwd("~/GitHub/DataUploadAutomation/Upload and Tables/Data")
#path <- path.expand("~/Documents/Min/DataUploadAutomation/Upload and Tables/Data")
#setwd("D:/Austin/Lab Work (D-Drive)/DataUploadAutomation/Measures/Upload Preparation")
# *************************************************************************
# Import Pedigree Data####
# *************************************************************************

Pedigree <- read.csv("Reference_Pedigree.csv", stringsAsFactors = FALSE)
Pedigree_name <- names(Pedigree)

# *************************************************************************
# Import RedCap Data####
# *************************************************************************
# Download RedCap Data
# reference https://redcap-prod.uoregon.edu/redcap/api/help/?content=exp_reports
# result <- postForm(
#    uri = 'https://redcap.uoregon.edu/api/',
#    token = '',
#    content = 'report',
#    format = 'csv',
#    report_id = '637',
#    rawOrLabel = 'raw',
#    rawOrLabelHeaders = 'raw',
#    exportCheckboxLabel = 'false',
#    returnFormat = 'csv'
#  )
# print(result)
# 
# # Convert Download Data into data frame
# Result_con <- textConnection(result)
# Redcap_Data <- read.csv(Result_con)


# TODO: will be removed
Redcap_Data <- read.csv("Redcap_Data.csv")


# *************************************************************************
# Import Qualtrics Data####
# *************************************************************************

# *************************************************************************
# Pedigree Preparation ####
# *************************************************************************
# Select relevant pedigree information, rename as needed. (Include GroupAssignment for treatment progress calculation.)
# TODO: Double check this include all the column everyone need 
Pedigree_T1 <- data.frame(select(Pedigree, Fam_ID = FamID, 
               interview_date = Time1Date, child_guid, child_famID = FamID_Child, 
               interview_age_child = ChildAge_T1, child_sex = ChildGender,
               subjectkey = mom_guid, src_subject_id = FamID_Mother, 
               interview_age_Mom = MomAge_T1, sex_mother = MomGender,
               GroupAssignment),Timepoint = 1 )
Pedigree_T2 <- data.frame(select(Pedigree, Fam_ID = FamID, 
               interview_date = Time1Date,  child_guid, child_famID = FamID_Child, 
               interview_age_child = ChildAge_T2, child_sex = ChildGender,
               subjectkey = mom_guid, src_subject_id = FamID_Mother, 
               interview_age_Mom = MomAge_T2, sex_mother = MomGender,
               GroupAssignment), Timepoint = 2 )
Pedigree_T3 <- data.frame(select(Pedigree, Fam_ID = FamID, 
               interview_date = Time1Date, child_guid, child_famID = FamID_Child, 
               interview_age_child = ChildAge_T3, child_sex = ChildGender,
               subjectkey = mom_guid, src_subject_id = FamID_Mother, 
               interview_age_Mom = MomAge_T3, sex_mother = MomGender,
               GroupAssignment), Timepoint = 3 )
Pedigree_T4 <- data.frame(select(Pedigree, Fam_ID = FamID, 
               interview_date = Time1Date, child_guid, child_famID = FamID_Child, 
               interview_age_child = ChildAge_T4, child_sex = ChildGender,
               subjectkey = mom_guid, src_subject_id = FamID_Mother, 
               interview_age_Mom = MomAge_T4, sex_mother = MomGender,
               GroupAssignment), Timepoint = 4 )

# Merge 4 pedigree
Pedigree <- rbind(Pedigree_T1, Pedigree_T2, Pedigree_T3, Pedigree_T4)

#Clean Environment
rm(Pedigree_T1, Pedigree_T2, Pedigree_T3, Pedigree_T4)

# *************************************************************************
# RedCap Preparation ####
# *************************************************************************
# Assign Timepoint base on redcap_event_name
Redcap_Data$Timepoint = sapply(strsplit(as.character(Redcap_Data$redcap_event_name), split = '_', fixed = T), function(x) (x[2])) 

Redcap_Data <- Redcap_Data %>%
  rename(Fam_ID = fam_id)

Redcap_Data <- merge(Pedigree, Redcap_Data, by = c("Timepoint","Fam_ID"), all = TRUE)

# *************************************************************************
# Qualtric Preparation ####
# *************************************************************************
# Fix Fam_ID and Timepoint variable name
# Edit UPMC Time 1 - 4: Change FQ4id column to FamID. Add Timepoint column
# TODO: will need this code if we download Qualtrics using API 
# UPMC_Qualtrics_T1 <- UPMC_Qualtrics_T1 %>% rename(Fam_ID = FQ4id) %>% mutate(Timepoint = "1")
# UPMC_Qualtrics_T2 <- UPMC_Qualtrics_T2 %>% rename(Fam_ID = FQ4id) %>% mutate(Timepoint = "2")
# UPMC_Qualtrics_T3 <- UPMC_Qualtrics_T3 %>% rename(Fam_ID = FQ4id) %>% mutate(Timepoint = "3")
# UPMC_Qualtrics_T4 <- UPMC_Qualtrics_T4 %>% rename(Fam_ID = FQ4id) %>% mutate(Timepoint = "4")
# 
# UO_Qualtrics_T1 <- UO_Qualtrics_T1 %>% rename(Fam_ID = Q221, Timepoint = Q146) 
# UO_Qualtrics_T2 <- UO_Qualtrics_T2 %>% rename(Fam_ID = Q116, Timepoint = Q117)
# UO_Qualtrics_T3 <- UO_Qualtrics_T3 %>% rename(Fam_ID = Q174, Timepoint = Q176)
# UO_Qualtrics_T4 <- UO_Qualtrics_T4 %>% rename(Fam_ID = Q203, Timepoint = Q206)

# *************************************************************************
# SCIP Rename ####
# *************************************************************************


# *************************************************************************
# SID-P Rename ####
# *************************************************************************


# *************************************************************************
# PPVT Rename ####
# *************************************************************************
# PPVT changes are unnecessary, only bring preparation script pedigree data to PPVT

# *************************************************************************

# *************************************************************************
# Emotion Strategies Rename ####
# *************************************************************************
# Redcap column names for locating old names to be replaced with Prep names and NDA names
new_ES_names <- c("oc_es_hapstrat", "oc_es_hap_1", "oc_es_hap_2", "oc_es_hap_3", "oc_es_angstrat", "oc_es_ang_1", "oc_es_ang_2", "oc_es_ang_3", "oc_es_sadstrat", "oc_es_sad_1", "oc_es_sad_2", "oc_es_sad_3")
old_ES_names <- c("oc_es_hapstrat", "oc_es_h1", "oc_es_h2", "oc_es_h3", "oc_es_angstrat", "oc_es_a1", "oc_es_a2", "oc_es_a3", "oc_es_sadstrat", "oc_es_s1", "oc_es_s2", "oc_es_s3")

# Replace Column Names
setnames(Redcap_Data, old_ES_names, new_ES_names)

# Clean environment 
rm(old_ES_names)

# TODO: merge session

# Note ####
# *************************************************************************
print("Output list: Pedigree, Qualtrics, Redcap_Data") 
cat("\n Pedigree column name: Pedigree_name")
cat('\n DERS variable names: new_ders_names')
cat('\n CBCL variable names: New_CBCL_Names')
cat('\n CCNES variable names updated: new_CCNES_names')
cat('\n AAQ variable names updated: new_AAQ_names')
cat('\n WCCL variable names updated: new_WCCL_names')
cat('\n PKBS variable names updated: new_PKBS_names')
cat('\n Bear Dragon variable names updated:  ')   # TODO
cat('\n Affect Perspective Taking variable names updated: new_AffectPT_names')
cat('\n Dimensional Card Sort variable names updated: old_DCS_names')
cat('\n Emotion Labeling variable names updated: new_eltpart1_names, new_eltpart2_names')
cat('\n Emotion Strategies variable names updated: new_ES_names')










