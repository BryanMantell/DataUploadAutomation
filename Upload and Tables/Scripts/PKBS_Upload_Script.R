# title: "PKBS Upload Script
# author:  Jacob Mulleavey

# Scientific Notation
options(digits = 3)

# Install Package, this only need to be done once.
#install.packages("rlang")
#install.packages("dplyr")
#install.packages(c("tidyverse","data.table","contrib.url","knitr"))
#install.packages('plyr', repos = "http://cran.us.r-project.org")
#install.packages("lmSupport")


# Load packages, this need to be done every time you run this script. 
library(dplyr)
library(tidyverse)
library(data.table)
library(knitr)
library(lmSupport)

# Source data, templates and create NDA dataframe
setwd("~/GitHub/DataUploadAutomation/Upload and Tables/Data")
#source("~/GitHub/DataUploadAutomation/Upload and Tables/Data/Upload Preparation.R")

NDA_PKBS <- read.csv("pkbs01_template.csv", skip = 1)

# Select the relevant sets of information from Qualtrics necessary for the PKBS
PKBS_Prep <- select(Qualtrics, c(Fam_ID, child_guid, child_famID, interview_date, interview_age_child, child_sex, GroupAssignment, Timepoint = Timepoint, contains("srm_pkbs")))

# Re-code and 67% Rule
#----------------------------------------------------------------------------------------------------------------------------------------
# Turn Likert Scale from text string to numeric value
PKBS_Prep[PKBS_Prep == "Never (0)"] <- 0; PKBS_Prep[PKBS_Prep == "Rarely (1)"] <- 1;
PKBS_Prep[PKBS_Prep == "Sometimes (2)"] <- 2; PKBS_Prep[PKBS_Prep == "Often (3)"] <- 3;
#----------------------------------------------------------------------------------------------------------------------------------------

# Calculated Columns
#----------------------------------------------------------------------------------------------------------------------------------------
# Change number to numeric values and Create Calculated Column 
PKBS_Prep[,9:41] <- sapply(PKBS_Prep[,9:41],as.numeric)

PKBS_Prep <- add_column(PKBS_Prep, pkbs_total = varScore(PKBS_Prep, c("srm_pkbs_1", "srm_pkbs_2","srm_pkbs_3","srm_pkbs_4", "srm_pkbs_5", "srm_pkbs_6",
                                                                      "srm_pkbs_7", "srm_pkbs_8", "srm_pkbs_9", "srm_pkbs_10", "srm_pkbs_11", "srm_pkbs_12", "srm_pkbs_13",
                                                                      "srm_pkbs_14", "srm_pkbs_15", "srm_pkbs_16", "srm_pkbs_17", "srm_pkbs_18", "srm_pkbs_19", "srm_pkbs_20",
                                                                      "srm_pkbs_21", "srm_pkbs_22", "srm_pkbs_23", "srm_pkbs_24", "srm_pkbs_25", "srm_pkbs_26", "srm_pkbs_27",
                                                                      "srm_pkbs_28", "srm_pkbs_29", "srm_pkbs_30", "srm_pkbs_31", "srm_pkbs_32", "srm_pkbs_33"), 
                                                         Reverse = NULL, Range = NULL, Prorate = TRUE, MaxMiss = .33))
#----------------------------------------------------------------------------------------------------------------------------------------

# NDA Sheet
#----------------------------------------------------------------------------------------------------------------------------------------
# Create list of column names for PKBS prep and NDA structure
NDA_PKBS_Prep <- select(PKBS_Prep, c(visit = "Timepoint", mom_guid = "subjectkey", FamID_Mother = "src_subject_id", sex = "MomGender", interview_age, GroupAssignment, interview_date, starts_with("srm"), pkbs_total))


NDA_names <- c("Social2", "Social7", "Social10", "Social12", "Social16", "Social22", "Social23", "Social25", 
               "Social28", "Social29", "Social30", "Social32", "Social5", "Social14", "Social15", "Social17", 
               "Social19", "Social20", "Social21", "Social24", "Social27", "Social33", "Social34", "Social1", 
               "Social3", "Social6", "Social8", "P_soc_23_ft", "Social11", "Social13", "Social18", "Social26", 
               "Social31")

setnames(NDA_PKBS_Prep, new_PKBS_names, NDA_names, skip_absent = FALSE)
colnames(NDA_PKBS_Prep)[40] <- "basc_social_raw"


# Merge PKBS Prep Sheet into NDA structure
NDA_PKBS[1,] <- NA
NDA_PKBS <- rbind(NDA_PKBS_Prep, NDA_PKBS)

# Recreate the first line of the NDA
first_line <- matrix("", nrow = 1, ncol = ncol(NDA_PKBS))
first_line[,1] <- "pkbs"
first_line[,2] <- "1"

# Create a new file in folder called pabq.csv, and put first line into this file
# pabq.csv file will be saved into same folder as current r script
write.table(first_line, file = "pkbs.csv", sep = ",", append = FALSE, quote = FALSE, na = "", col.names = FALSE, row.names = FALSE)

# Append data in NDA_CCNES into pabq.cav file 
write.table(NDA_PKBS, file = 'pkbs.csv', sep = ",", append = TRUE, na = "", quote = FALSE, row.names = FALSE)
#----------------------------------------------------------------------------------------------------------------------------------------
