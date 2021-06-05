# title: "BearDragon Upload Script
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
setwd("/Users/jmulleavey/Documents/GitHub/DataUploadAutomation/Upload and Tables/Data")
getwd()
#setwd("~/Documents/GitHub/DataUploadAutomation/Upload and Tables/Data")
#source("~/GitHub/DataUploadAutomation/Upload and Tables/Data/Upload Preparation.R")

NDA_BearDragon <- read.csv("beardragon01_template.csv")

# Select the relevant sets of information from RedCap necessary for the BearDragon
BearDragon_Prep <- select(Redcap_Data, c(child_guid, child_famID, interview_date, interview_age_child, child_sex, Timepoint, 
                                         oc_bd_01, oc_bd_02, oc_bd_03, oc_bd_04, oc_bd_05, oc_bd_06, oc_bd_07, oc_bd_08, oc_bd_09, oc_bd_10))    

# Calculated Columns
#----------------------------------------------------------------------------------------------------------------------------------------
# Change number to numeric values and Create Calculated Column 
BearDragon_Prep <- add_column(BearDragon_Prep, oc_beardragon_total = varScore(BearDragon_Prep, 
                                               c("oc_bd_01", "oc_bd_02", "oc_bd_03", "oc_bd_04", "oc_bd_05", 
                                                 "oc_bd_06", "oc_bd_07", "oc_bd_08", "oc_bd_09", "oc_bd_10"), Reverse = NULL, Range = NULL, Prorate = TRUE, MaxMiss = .33))

BearDragon_Prep <- add_column(BearDragon_Prep, oc_bear_total = varScore(BearDragon_Prep, 
                                               c("oc_bd_01", "oc_bd_03", "oc_bd_05", "oc_bd_07", "oc_bd_09"), Reverse = NULL, Range = NULL, Prorate = TRUE, MaxMiss = .33))

BearDragon_Prep <- add_column(BearDragon_Prep, oc_dragon_total = varScore(BearDragon_Prep, 
                                               c("oc_bd_02", "oc_bd_04", "oc_bd_06", "oc_bd_08", "oc_bd_10"), Reverse = NULL, Range = NULL, Prorate = TRUE, MaxMiss = .33))
#----------------------------------------------------------------------------------------------------------------------------------------

# NDA Sheet
#----------------------------------------------------------------------------------------------------------------------------------------
# Create list of column names for BearDragon prep and NDA structure
NDA_BearDragon_Prep <- select(BearDragon_Prep, subjectkey = "child_guid", src_subject_id = "child_famID", interview_date, interview_age = "interview_age_child", sex = "child_sex", visit = "Timepoint", contains("oc_bd"))

#Match Prep Sheet column names to required NDA names
nda_names <- c(paste("beardragon", 1:10, sep = ""))
prep_names <- c(paste("oc_bd_", 01:09, sep = "0"), c("oc_bd_10"))
setnames(NDA_BearDragon_Prep, prep_names, nda_names, skip_absent = TRUE)

# Merge PKBS Prep Sheet into NDA structure
#NDA_BearDragon[1,] <- NA
NDA_BearDragon <- rbind(NDA_BearDragon_Prep, NDA_BearDragon)

# Recreate the first line of the NDA
first_line <- matrix("", nrow = 1, ncol = ncol(NDA_BearDragon))
first_line[,1] <- "beardragon"
first_line[,2] <- "1"

# Create a new file in folder called pabq.csv, and put first line into this file
# pabq.csv file will be saved into same folder as current r script
write.table(first_line, file = "beardragon.csv", sep = ",", append = FALSE, quote = FALSE, na = "", col.names = FALSE, row.names = FALSE)

# Append data in NDA_CCNES into pabq.cav file 
write.table(NDA_BearDragon, file = 'beardragon.csv', sep = ",", append = TRUE, na = "", quote = FALSE, row.names = FALSE)
#----------------------------------------------------------------------------------------------------------------------------------------
