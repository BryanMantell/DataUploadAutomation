# Title: WCCL Upload Script

# Setup("~/GitHub/DataUploadAutomation/Upload and Tables/Data")


# import data frame

#setwd
source("~/GitHub/DataUploadAutomation/Upload and Tables/Data/Upload Preparation.R")

WCCL_NDA <- read.csv("dbt_wccl01_template.csv", skip = 1)
options(digits = 3)

library(lmSupport) 
library(plyr)


# Prep Sheet
#Create prep sheet to begin transferring data into NDA format. Rename relevant GUID information to match NDA specifications. Finally, bind all timepoints into single WCCL Prep Sheet.


WCCL_Prep <- select(Qualtrics, c(Timepoint, mom_guid, FamID_Mother, mother_sex, interview_date, interview_age_Mom, contains("srm_wccl")))

#r Recode
#Change Numbers to Numeric values
WCCL_Prep[WCCL_Prep == "0 Never Used"] <- 0
WCCL_Prep[WCCL_Prep == "1 Rarely Used"] <- 1
WCCL_Prep[WCCL_Prep == "2 Sometimes Used"] <- 2
WCCL_Prep[WCCL_Prep == "3 Regularly Used"] <- 3


WCCL_Prep[,6:65] <- sapply(WCCL_Prep[,6:65],as.numeric)

#mutate_at(new_WCCL_names,funs(recode(., '0 Never Used' = 0, '1 Rarely Used' = 1, '2 Sometimes Used' = 2, '3 Regularly Used' = 3,.default = NaN)))




#r Calculated Columns

#VarScore columns 
WCCL_Prep <- add_column(WCCL_Prep, WCCL_SU_imputation = varScore(WCCL_Prep, Forward = c("srm_wccl_1", "srm_wccl_2", "srm_wccl_4", "srm_wccl_6", "srm_wccl_9", "srm_wccl_10", "srm_wccl_11", "srm_wccl_13", "srm_wccl_16", "srm_wccl_18", "srm_wccl_19", "srm_wccl_21", "srm_wccl_22", "srm_wccl_23", "srm_wccl_26", "srm_wccl_27", "srm_wccl_29", "srm_wccl_31", "srm_wccl_33", "srm_wccl_34", "srm_wccl_35", "srm_wccl_36", "srm_wccl_38", "srm_wccl_39", "srm_wccl_40", "srm_wccl_42", "srm_wccl_43", "srm_wccl_44", "srm_wccl_47", "srm_wccl_49", "srm_wccl_50", "srm_wccl_51", "srm_wccl_53", "srm_wccl_54", "srm_wccl_56", "srm_wccl_57", "srm_wccl_58", "srm_wccl_59"), MaxMiss = .20),.after = "srm_wccl_59")

WCCL_Prep <- add_column(WCCL_Prep, WCCL_GSC_imputation = varScore(WCCL_Prep, Forward = c("srm_wccl_3", "srm_wccl_5", "srm_wccl_8", "srm_wccl_12", "srm_wccl_14", "srm_wccl_17", "srm_wccl_20", "srm_wccl_25", "srm_wccl_32", "srm_wccl_37", "srm_wccl_41", "srm_wccl_45", "srm_wccl_46", "srm_wccl_52", "srm_wccl_55"), MaxMiss = .20),.after = "srm_wccl_59")

WCCL_Prep <- add_column(WCCL_Prep, WCCL_BO_imputation = varScore(WCCL_Prep, Forward = c("srm_wccl_7", "srm_wccl_15", "srm_wccl_24", "srm_wccl_28", "srm_wccl_30", "srm_wccl_48"), MaxMiss = .20),.after = "srm_wccl_59")

#r NDA Sheet 
# Create NDA structure column names
dbt_wccl <- paste("dbt_wccl", 1:59, sep = "")
NDA_Names <- c(dbt_wccl)

# NDA Sheet ####
# Create NDA Prep sheet, select all the needed columns from Prep sheet
WCCL_NDA_Prep <- select(WCCL_Prep, c(Timepoint, subjectkey = mom_guid, src_subject_id = FamID_Mother, sex = mother_sex, interview_date, interview_age_Mom, dbt_wccl_su = WCCL_SU_imputation, dbt_wccl_gdc = WCCL_GSC_imputation, dbt_wccl_bo = WCCL_BO_imputation, contains("srm_wccl")))

# Combine NDA and Prep sheet
# Make sure put original NDA structure at first, because the order of the new sheet will be the order of the first item in bind_rows function
setnames(WCCL_NDA_Prep, new_WCCL_names, NDA_Names)


# Recreate first line in original NDA file
# Make a empty row, with same number of column in WCCL_NDA, as first line of NDA sheet
# WCCL_NDA[1,] <- NA

# ncol(WCCL_NDA)  is number of columns in WCCL_NDA
#WCCL_NDA <- bind_rows(WCCL_NDA,WCCL_NDA_Prep)
#WCCL_NDA <- rbind.fill(WCCL_NDA, WCCL_NDA_Prep)
WCCL_NDA <- bind_rows(mutate_all(WCCL_NDA, as.character), mutate_all(WCCL_NDA_Prep, as.character))

# Recreate first line in original NDA file
# Make a empty row, with same number of column in WCCL_NDA, as first line of NDA sheet
# ncol(WCCL_NDA)  is number of columns in WCCL_NDA
first_line <- matrix("", nrow = 1, ncol = ncol(WCCL_NDA))

# assign the first cell in first_line as dbt_wccl which is the first cell in original NDA structure
first_line[,1] <- "dbt_wccl"

# assign the second cell in first_line as 1
first_line[,2] <- "1"

# NDA output ####
# Create a new file in folder called dbt_wccl.csv, and put first line into this file
# dbt_wccl.csv file will be saved into same folder as current r script
write.table(first_line, file = "dbt_wccl.csv", sep = ",", append = FALSE, quote = FALSE, na = "", col.names = FALSE, row.names = FALSE)

# Append data in WCCL_NDA into dbt_wccl.cav file 
write.table(WCCL_NDA, file = 'dbt_wccl.csv', sep = ",", append = TRUE, na = "", quote = FALSE, row.names = FALSE)

# Clean Global Environment 
rm(first_line)
rm(WCCL_NDA_Prep, Redcap_Data, Qualtrics, Pedigree)
