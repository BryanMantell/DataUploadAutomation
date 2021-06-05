# title: "AffectPT Upload Script
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
setwd("~/Documents/GitHub/DataUploadAutomation/Upload and Tables/Data")
getwd()
#setwd("~/Documents/GitHub/DataUploadAutomation/Upload and Tables/Data")
#source("~/GitHub/DataUploadAutomation/Upload and Tables/Data/Upload Preparation.R")

NDA_AffectPT <- read.csv("apt01_template.csv", skip = 1)

# Select the relevant sets of information from RedCap necessary for the AffectPT
AffectPT_Prep <- select(Redcap_Data, c(child_guid, child_famID, interview_date, interview_age_child, child_sex, Timepoint, contains("oc_apt_")))

# Calculated Columns
#----------------------------------------------------------------------------------------------------------------------------------------
# Add empty scoring column to the existing data frame
AffectPT_Prep[, c("oc_apt_02", "oc_apt_04", "oc_apt_06", "oc_apt_08", "oc_apt_10", "oc_apt_12", 
                  "oc_apt_14", "oc_apt_16")] <- NA

#Remove total column from the prep script because it will be based on recoded columns in coming lines of code
AffectPT_Prep <- select(AffectPT_Prep, -c("oc_apt_total"))

# Reorder scoring columns with existing child response columns
col_order <- c("child_guid", "child_famID", "interview_date", "interview_age_child", "child_sex", "Timepoint", "oc_apt_01", "oc_apt_02", "oc_apt_03", "oc_apt_04", 
               "oc_apt_05", "oc_apt_06", "oc_apt_07", "oc_apt_08", "oc_apt_09", "oc_apt_10", "oc_apt_11", 
               "oc_apt_12", "oc_apt_13", "oc_apt_14", "oc_apt_15", "oc_apt_16")

AffectPT_Prep <- AffectPT_Prep[, col_order]

# Add values dependant on previous child's rating column into each scoring column
AffectPT_Prep$oc_apt_02 <- ifelse(AffectPT_Prep$oc_apt_01 == 1, 2, 0)

AffectPT_Prep$oc_apt_04 <- ifelse(AffectPT_Prep$oc_apt_03 == 2, 2, 
                                  ifelse(AffectPT_Prep$oc_apt_03 == 3, 1,
                                         ifelse(AffectPT_Prep$oc_apt_03 == 4, 1, 0)))

AffectPT_Prep$oc_apt_06 <- ifelse(AffectPT_Prep$oc_apt_05 == 3, 2, 
                                  ifelse(AffectPT_Prep$oc_apt_05 == 2, 1,
                                         ifelse(AffectPT_Prep$oc_apt_05 == 4, 1, 0)))

AffectPT_Prep$oc_apt_08 <- ifelse(AffectPT_Prep$oc_apt_07 == 4, 2, 
                                  ifelse(AffectPT_Prep$oc_apt_07 == 2, 1,
                                         ifelse(AffectPT_Prep$oc_apt_07 == 3, 1, 0)))

AffectPT_Prep$oc_apt_10 <- ifelse(AffectPT_Prep$oc_apt_09 == 1, 2, 0)

AffectPT_Prep$oc_apt_12 <- ifelse(AffectPT_Prep$oc_apt_11 == 2, 2, 
                                  ifelse(AffectPT_Prep$oc_apt_11 == 3, 1,
                                         ifelse(AffectPT_Prep$oc_apt_11 == 4, 1, 0)))

AffectPT_Prep$oc_apt_14 <- ifelse(AffectPT_Prep$oc_apt_13 == 4, 2, 
                                  ifelse(AffectPT_Prep$oc_apt_13 == 2, 1,
                                         ifelse(AffectPT_Prep$oc_apt_13 == 3, 1, 0)))

AffectPT_Prep$oc_apt_16 <- ifelse(AffectPT_Prep$oc_apt_15 == 3, 2, 
                                  ifelse(AffectPT_Prep$oc_apt_15 == 2, 1,
                                         ifelse(AffectPT_Prep$oc_apt_15 == 4, 1, 0)))

# Add aggregate total column for all the scoring columns
AffectPT_Prep <- add_column(AffectPT_Prep, oc_apt_total = rowSums(AffectPT_Prep[, c("oc_apt_02", "oc_apt_04", "oc_apt_06", "oc_apt_08",
                                                                                    "oc_apt_10", "oc_apt_12", "oc_apt_14", "oc_apt_16")]))

# NDA Sheet
#----------------------------------------------------------------------------------------------------------------------------------------
# Create list of column names for AffectPT prep and NDA structure
NDA_AffectPT_Prep <- select(AffectPT_Prep, subjectkey = "child_guid", src_subject_id = "child_famID", interview_date, interview_age = "interview_age_child", gender = "child_sex", visit = "Timepoint", contains("oc_apt"))

#Remove Prep Sheet
rm(AffectPT_Prep)

# Match Prep Sheet column names to required NDA names
nda_names <- c(paste("apt", 1:16, sep = ""))
prep_names <- c("oc_apt_01", "oc_apt_02", "oc_apt_03", "oc_apt_04", 
                "oc_apt_05", "oc_apt_06", "oc_apt_07", "oc_apt_08", "oc_apt_09", "oc_apt_10", "oc_apt_11", 
                "oc_apt_12", "oc_apt_13", "oc_apt_14", "oc_apt_15", "oc_apt_16")
setnames(NDA_AffectPT_Prep, prep_names, nda_names, skip_absent = FALSE)

# Drop total column
NDA_AffectPT_Prep <- NDA_AffectPT_Prep[-c(23)]

# Combine NDA Template with NDA Structure
NDA_AffectPT[1,] <- NA
NDA_AffectPT <- bind_rows(NDA_AffectPT, NDA_AffectPT_Prep)

first_line <- matrix("", nrow = 1, ncol = ncol(NDA_AffectPT))
first_line[,1] <- "apt"
first_line[,2] <- "1"

# Create a new file in folder called pabq.csv, and put first line into this file
# pabq.csv file will be saved into same folder as current r script
write.table(first_line, file = "affectpt.csv", sep = ",", append = FALSE, quote = FALSE, na = "", col.names = FALSE, row.names = FALSE)

# Append data in NDA_CCNES into pabq.cav file 
write.table(NDA_AffectPT, file = 'affectpt.csv', sep = ",", append = TRUE, na = "", quote = FALSE, row.names = FALSE)



