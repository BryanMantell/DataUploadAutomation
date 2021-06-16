# title: "BearDragon Upload Script
# author:  Jacob Mulleavey

# Scientific Notation
options(digits = 3)

# Source data, templates and create NDA dataframe
setwd("~/GitHub/DataUploadAutomation/Upload and Tables/Data")
#getwd()

BearDragon_NDA <- read.csv("beardragon01_template.csv")

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
BearDragon_NDA_Prep <- select(BearDragon_Prep, subjectkey = "child_guid", src_subject_id = "child_famID", interview_date, interview_age = "interview_age_child", sex = "child_sex", visit = "Timepoint", contains("oc_bd"))

#Match Prep Sheet column names to required NDA names
NDA_names <- c(paste("beardragon", 1:10, sep = ""))
prep_names <- c(paste("oc_bd_", 01:09, sep = "0"), c("oc_bd_10"))
setnames(BearDragon_NDA_Prep, prep_names, NDA_names, skip_absent = TRUE)

# Merge BearDragon Prep Sheet into NDA structure
#BearDragon_NDA[1,] <- NA
BearDragon_NDA <- rbind(BearDragon_NDA_Prep, BearDragon_NDA)

# Recreate the first line of the NDA
first_line <- matrix("", nrow = 1, ncol = ncol(BearDragon_NDA))
first_line[,1] <- "beardragon"
first_line[,2] <- "1"

# Create a new file in folder called beardragon.csv, and put first line into this file
# beardragon.csv file will be saved into same folder as current r script
write.table(first_line, file = "beardragon.csv", sep = ",", append = FALSE, quote = FALSE, na = "", col.names = FALSE, row.names = FALSE)

# Append data in BearDragon_NDA into beardragon.cav file 
write.table(BearDragon_NDA, file = 'beardragon.csv', sep = ",", append = TRUE, na = "", quote = FALSE, row.names = FALSE)

#Remove any unnecessary dataframes for the NDA upload
rm(BearDragon_NDA_Prep, first_line)
#rm(Pedigree, Qualtrics, Redcap_Data)
#----------------------------------------------------------------------------------------------------------------------------------------
