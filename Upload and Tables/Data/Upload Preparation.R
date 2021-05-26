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
library(lmSupport)
#library(redcapAPI)

# Empty Global Environment
rm(list = ls())
# scientific notation, round up to 3 digits
options(digits = 3)
setwd("~/Documents/GitHub/DataUploadAutomation/Upload and Tables/Data")
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
# TODO: Will be changed to import using API
UO_Qualtrics_T1 <- read.csv("UO_T1_Qualtrics.csv", stringsAsFactors = FALSE) %>% 
  rename(Fam_ID = Q221, Timepoint = Q146)
UO_Qualtrics_T2 <- read.csv("UO_T2_Qualtrics.csv", stringsAsFactors = FALSE) %>% 
  rename(Fam_ID = Q116, Timepoint = Q117)
UO_Qualtrics_T3 <- read.csv("UO_T3_Qualtrics.csv", stringsAsFactors = FALSE) %>% 
  rename(Fam_ID = Q174, Timepoint = Q176)
UO_Qualtrics_T4 <- read.csv("UO_T4_Qualtrics.csv", stringsAsFactors = FALSE) %>% 
  rename(Fam_ID = Q203, Timepoint = Q206)

# TODO: Read in actual UPMC Qualtrics Data
UPMC_Qualtrics_T1 <- read.csv("UPMC_T1_Qualtrics.csv", fileEncoding="UTF-8-BOM", stringsAsFactors = FALSE)%>% 
  rename(Fam_ID = FQ4id) %>% mutate(Timepoint = "1")
UPMC_Qualtrics_T2 <- read.csv("UPMC_T2_Qualtrics.csv", fileEncoding="UTF-8-BOM", stringsAsFactors = FALSE) %>% 
  rename(Fam_ID = FQ4id) %>% mutate(Timepoint = "2")
UPMC_Qualtrics_T3 <- read.csv("UPMC_T3_Qualtrics.csv", fileEncoding="UTF-8-BOM", stringsAsFactors = FALSE) %>% 
  rename(Fam_ID = FQ4id) %>% mutate(Timepoint = "3")
UPMC_Qualtrics_T4 <- read.csv("UPMC_T4_Qualtrics.csv", fileEncoding="UTF-8-BOM", stringsAsFactors = FALSE) %>% 
  rename(Fam_ID = FQ4id) %>% mutate(Timepoint = "4")

UO_Qualtrics_list <- list(UO_Qualtrics_T1, UO_Qualtrics_T2, UO_Qualtrics_T3, UO_Qualtrics_T4)
UPMC_Qualtrics_list <- list(UPMC_Qualtrics_T1, UPMC_Qualtrics_T2, UPMC_Qualtrics_T3, UPMC_Qualtrics_T4)

# *************************************************************************
# Pedigree Preparation ####
# *************************************************************************
# Select relevant pedigree information, rename as needed. (Include GroupAssignment for treatment progress calculation.)
# TODO: Double check this include all the column everyone need 
Pedigree_T1 <- data.frame(select(Pedigree, Fam_ID = FamID, 
               interview_date = Time1Date, child_guid, child_famID = FamID_Child, 
               interview_age_child = ChildAge_T1, child_sex = ChildGender,
               mom_guid, FamID_Mother, 
               interview_age_Mom = MomAge_T1, sex_mother = MomGender,
               GroupAssignment),Timepoint = 1 )
Pedigree_T2 <- data.frame(select(Pedigree, Fam_ID = FamID, 
               interview_date = Time1Date,  child_guid, child_famID = FamID_Child, 
               interview_age_child = ChildAge_T2, child_sex = ChildGender,
               mom_guid, FamID_Mother, 
               interview_age_Mom = MomAge_T2, sex_mother = MomGender,
               GroupAssignment), Timepoint = 2 )
Pedigree_T3 <- data.frame(select(Pedigree, Fam_ID = FamID, 
               interview_date = Time1Date, child_guid, child_famID = FamID_Child, 
               interview_age_child = ChildAge_T3, child_sex = ChildGender,
               mom_guid, FamID_Mother, 
               interview_age_Mom = MomAge_T3, sex_mother = MomGender,
               GroupAssignment), Timepoint = 3 )
Pedigree_T4 <- data.frame(select(Pedigree, Fam_ID = FamID, 
               interview_date = Time1Date, child_guid, child_famID = FamID_Child, 
               interview_age_child = ChildAge_T4, child_sex = ChildGender,
               mom_guid, FamID_Mother, 
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
# DERS Rename ####
# *************************************************************************
# Old UO name: Q137_1 ~ Q137_36
old_UO_ders_names <- paste("Q137", seq(1:36), sep = "_")

# Old UPMC name: Q6.1_1 ~ Q5.1_36
old_UPMC_ders_names <- paste("FQ4DERS", seq(1:36), sep = "_")

# New variable name for preparation sheet: srm_ders_1 ~ srm_ders_36
new_ders_names <- paste("srm_ders", seq(1:36), sep = '_')

# NDA ders name
ders <- "ders"
number_of_survey <- seq(1:36)
NDA_DERS_names <- paste(ders,number_of_survey,sep = '')

# rename UO & UPMC Ders Name
lapply(UO_Qualtrics_list, setnames, old_UO_ders_names, new_ders_names)
lapply(UPMC_Qualtrics_list, setnames, old_UPMC_ders_names, new_ders_names)

# Clean global Environment
rm(old_UO_ders_names, old_UPMC_ders_names, number_of_survey)


# *************************************************************************
# CBCL Rename ####
# *************************************************************************

# Create list of new variable names for the Prep Sheet
New_CBCL_Names <- sprintf("srm_CBCL_%03d", seq(1:100))

# Create list of old variable names so we can target them to be replaced with the new ones
# Since the question names change by timepoint we'll have to make unique lists by timepoint, starting with UO Timepoint 1 and UMPC Timepoint 1 and 4
Old_UO_CBCL_Names_T1 <- sprintf("Q264_%01d", seq(1:100))
# Old names for UO Timepoint 2
Old_UO_CBCL_Names_T2 <- sprintf("Q368_%01d", seq(1:100))
# Old names for UO Timepoint 3
Old_UO_CBCL_Names_T3 <- sprintf("Q534_%01d", seq(1:100))
# Old names for UO timepoint 4
Old_UO_CBCL_Names_T4 <- sprintf("Q828_%01d", seq(1:100))

# Old UPMC name 
Old_UPMC_CBCL_Names <- sprintf("FQ4CBCLB_%01d", seq(1:100))

# Replace UO & UMPC column names in list
lapply(UO_Qualtrics_list[1], setnames, Old_UO_CBCL_Names_T1, New_CBCL_Names)
lapply(UO_Qualtrics_list[2], setnames, Old_UO_CBCL_Names_T2, New_CBCL_Names)
lapply(UO_Qualtrics_list[3], setnames, Old_UO_CBCL_Names_T3, New_CBCL_Names)
lapply(UO_Qualtrics_list[4], setnames, Old_UO_CBCL_Names_T4, New_CBCL_Names)

lapply(UPMC_Qualtrics_list, setnames, Old_UPMC_CBCL_Names, New_CBCL_Names)


# Clean environment 
rm(New_CBCL_Names, Old_UO_CBCL_Names_T1, Old_UO_CBCL_Names_T2, Old_UO_CBCL_Names_T3, Old_UO_CBCL_Names_T4,Old_UPMC_CBCL_Names)

# *************************************************************************
# CCNES Rename ####
# *************************************************************************
# Old UO name: Q140_1 ~ Q151_3
# Old UPMC name: FQ4CCNES_1 ~ FQ4CCNES_6, FQ4CCNES2_1 ~ FQ4CCNES12_6
# TODO: Check does UPMC variable names consistent cross timepoint
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

# Replace UO&UPMC column names
lapply(UPMC_Qualtrics_list, setnames, old_UPMC_CCNES_names, new_CCNES_names)
lapply(UO_Qualtrics_list, setnames, old_UO_CCNES_names, new_CCNES_names)

# NDA structure Column Names ####
pabq <- paste("pabq",1:12, sep = "")
CCNES_NDA_Names <- c()
for (i in pabq) {
  Name <- paste(i, letters[seq(1:6)], sep = "")
  CCNES_NDA_Names <- c(CCNES_NDA_Names, Name)
}
# Clean environment 
rm(old_UO_CCNES_names, i, n, old_UPMC_CCNES_names, ccnes_name, ccnes_name_1)



# *************************************************************************
# AAQ Rename ####
# *************************************************************************
# Create list of new variable names 
new_AAQ_names <- paste("srm_aaq", seq(1:10), sep = '_')

# Create list of old variable names so we can replace them with the new ones 
old_UO_AAQ_names <- paste("Q154", seq(1:10), sep = "_")
old_UPMC_AAQ_names <- paste("FQ4AAQ", seq(1:10), sep = "_")

# Replace UO&UPMC column names 
lapply(UO_Qualtrics_list, setnames, old_UO_AAQ_names, new_AAQ_names)
lapply(UPMC_Qualtrics_list, setnames, old_UPMC_AAQ_names, new_AAQ_names)

# Clean environment 
rm(old_UO_AAQ_names,old_UPMC_AAQ_names)
# *************************************************************************
# WCCL Rename ####
# *************************************************************************
# Create new variable names 
new_WCCL_names <- paste("srm_wccl", seq(1:59), sep = "_")

# Old UO variable names
old_UO_WCCL_names <- paste("Q155", seq(1:59), sep = "_")

# Old UPMC variable names
old_UPMC_WCCL_names <- paste("FQ4WCCL", seq(1:59), sep = "_")

lapply(UO_Qualtrics_list, setnames, old_UO_WCCL_names, new_WCCL_names)
lapply(UPMC_Qualtrics_list, setnames, old_UPMC_WCCL_names, new_WCCL_names)

# Clean environment 
rm(old_UO_WCCL_names,old_UPMC_WCCL_names)


# *************************************************************************
# PKBS Rename ####
# *************************************************************************
# Create list of new variable names
new_PKBS_names <- paste("srm_pkbs", seq(1:33), sep = '_')

# Now make a list of old variable names so that we can replace them with the neww ones
old_UO_PKBS_names <- paste("Q407", seq(1:33), sep = "_")
old_UO_PKBS_names2 <- paste("Q359", seq(1:33), sep = "_")
old_UO_PKBS_names3 <- paste("Q524", seq(1:33), sep = "_")
old_UO_PKBS_names4 <- paste("Q817", seq(1:33), sep = "_")
old_UPMC_PKBS_names <- paste("FQ4PKBS", seq(1:33), sep = "_")


# Change UO column names
setnames(UO_Qualtrics_T1, old_UO_PKBS_names, new_PKBS_names, skip_absent = FALSE)
setnames(UO_Qualtrics_T2, old_UO_PKBS_names2, new_PKBS_names, skip_absent = FALSE)
setnames(UO_Qualtrics_T3, old_UO_PKBS_names3, new_PKBS_names, skip_absent = FALSE)
setnames(UO_Qualtrics_T4, old_UO_PKBS_names4, new_PKBS_names, skip_absent = FALSE)

# Change UPMC column names
lapply(UPMC_Qualtrics_list, setnames, old_UPMC_PKBS_names, new_PKBS_names)

# Clean environment 
rm(old_UO_PKBS_names, old_UO_PKBS_names2, old_UO_PKBS_names3, old_UO_PKBS_names4, old_UPMC_PKBS_names)
# *************************************************************************
# Bear Dragon Rename ####
# *************************************************************************
# Do not need to be renamed 

# *************************************************************************
# Affect Perspective Taking Rename ####
# *************************************************************************
old_AffectPT_names <- c("oc_apt_01", "oc_apt_02", "oc_apt_03", "oc_apt_04", "oc_apt_05", "oc_apt_06", 
                        "oc_apt_07", "oc_apt_08")
new_AffectPT_names <- c("oc_apt_01", "oc_apt_03", "oc_apt_05", "oc_apt_07", "oc_apt_09", "oc_apt_11", 
                        "oc_apt_13", "oc_apt_15")
setnames(Redcap_Data, old_AffectPT_names, new_AffectPT_names, skip_absent = FALSE)

# Clean environment 
rm(old_AffectPT_names)
# *************************************************************************
# Dimensional Card Sort Rename ####
# *************************************************************************
# Redcap column name: oc_dcs_1:36
old_DCS_names <- sprintf("oc_dcs_%02d", 1:36)

# *************************************************************************
# Emotion Labeling Rename ####
# *************************************************************************
# rename elt_exp names
new_eltpart1_names <- paste("oc_elt_exp", seq(1:8), sep = "_")

# rename elt_rec names
new_eltpart2_names <- paste("oc_elt_rec", seq(1:4), sep = "_")

# replace old eltpart1 names with new names
old_eltpart1_names <- paste("eltpart1_exp", seq(1:8), sep = "")
setnames(Redcap_Data, old_eltpart1_names, new_eltpart1_names)

# replace old eltpart2 names with new names
old_eltpart2_names <- paste("eltpart2_rec", seq(1:4), sep = "")
setnames(Redcap_Data, old_eltpart2_names, new_eltpart2_names)

# Clean environment 
rm(old_eltpart1_names, old_eltpart2_names)

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



# Bind 4 time points from two site 
# TODO: Need to find a way to merge UO and UPMC Qualtrics, due to different variable names cross site
# TODO: Bind doesn't work for now because Variabl name different cross sit 
UPMC_Qualtrics <- bind_rows(UPMC_Qualtrics_T1, UPMC_Qualtrics_T2, UPMC_Qualtrics_T3, UPMC_Qualtrics_T4)
UO_Qualtrics <- bind_rows(UO_Qualtrics_T1, UO_Qualtrics_T2, UO_Qualtrics_T3, UO_Qualtrics_T4)

#TODO: will be removed 
UPMC_Qualtrics <- UPMC_Qualtrics %>%
  mutate_all(as.character)
UO_Qualtrics <- UO_Qualtrics %>%
  mutate_all(as.character)
# Merge UO and UPMC data 
Qualtrics <- bind_rows(UO_Qualtrics,UPMC_Qualtrics)  

# Merge Qualtrics data with pedigree
Qualtrics <- merge(Qualtrics, Pedigree, by = c("Fam_ID","Timepoint"))

# Change gender to F instead of False
Qualtrics$mother_sex <- "F"


# Clean global Environment
rm(UO_Qualtrics_T1, UO_Qualtrics_T2, UO_Qualtrics_T3, UO_Qualtrics_T4, UO_Qualtrics,
   UPMC_Qualtrics_T1, UPMC_Qualtrics_T2, UPMC_Qualtrics_T3, UPMC_Qualtrics_T4, UPMC_Qualtrics, UPMC_Qualtrics_list, UO_Qualtrics_list)

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










