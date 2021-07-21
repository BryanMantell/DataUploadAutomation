# title: "PKBS Upload Script
# author:  Jacob Mulleavey

# Scientific Notation
options(digits = 3)

# Source data, templates and create NDA dataframe
setwd("~/GitHub/DataUploadAutomation/Upload and Tables/Data")
#getwd()

PKBS_NDA <- read.csv("pkbs01_template.csv", skip = 1)

# Select the relevant sets of information from Qualtrics necessary for the PKBS
PKBS_Prep <- select(Qualtrics, c(Timepoint, mom_guid, FamID_Mother, interview_date, interview_age_Mom, mother_sex, contains("srm_pkbs")))

# Re-code
#----------------------------------------------------------------------------------------------------------------------------------------
# Turn Likert Scale from text string to numeric value
PKBS_Prep[PKBS_Prep == "Never (0)"] <- 0; PKBS_Prep[PKBS_Prep == "Rarely (1)"] <- 1;
PKBS_Prep[PKBS_Prep == "Sometimes (2)"] <- 2; PKBS_Prep[PKBS_Prep == "Often (3)"] <- 3;
#----------------------------------------------------------------------------------------------------------------------------------------

# Calculated Columns
#----------------------------------------------------------------------------------------------------------------------------------------
# Change number to numeric values and Create Calculated Column 
PKBS_Prep[,7:39] <- sapply(PKBS_Prep[,7:39],as.numeric)

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
PKBS_NDA_Prep <- select(PKBS_Prep, c(subjectkey = "mom_guid", src_subject_id = "FamID_Mother", interview_age = "interview_age_Mom", interview_date, sex = "mother_sex", visit = "Timepoint",starts_with("srm"), pkbs_total))       


NDA_names <- c("pkbs_social2", "pkbs_social7", "pkbs_social10", "pkbs_social12", "pkbs_social16", "pkbs_social22", "pkbs_social23", "pkbs_social25", 
               "pkbs_social28", "pkbs_social29", "pkbs_social30", "pkbs_social32", "pkbs_social5", "pkbs_social14", "pkbs_social15", "pkbs_social17", 
               "pkbs_social19", "pkbs_social20", "pkbs_social21", "pkbs_social24", "pkbs_social27", "pkbs_social33", "pkbs_social34", "pkbs_social1", 
               "pkbs_social3", "pkbs_social6", "pkbs_social8", "ssis_p_soc_23_oft", "pkbs_social11", "pkbs_social13", "pkbs_social18", "pkbs_social26", 
               "pkbs_social31")

setnames(PKBS_NDA_Prep, new_PKBS_names, NDA_names, skip_absent = FALSE)
colnames(PKBS_NDA_Prep)[40] <- "basc_social_raw"


# Merge PKBS Prep Sheet into NDA structure
#PKBS_NDA[1,] <- NA
PKBS_NDA <- bind_rows(mutate_all(PKBS_NDA, as.character), mutate_all(PKBS_NDA_Prep, as.character))

# Recreate the first line of the NDA
first_line <- matrix("", nrow = 1, ncol = ncol(PKBS_NDA))
first_line[,1] <- "pkbs"
first_line[,2] <- "1"

# Create a new file in folder called pkbs01.csv, and put first line into this file
# pkbs01.csv file will be saved into same folder as current r script
write.table(first_line, file = "NDA Upload/pkbs01.csv", sep = ",", append = FALSE, quote = FALSE, na = "", col.names = FALSE, row.names = FALSE)

# Append data in PKBS_NDA into pkbs01.cav file 
write.table(PKBS_NDA, file = 'NDA Upload/pkbs01.csv', sep = ",", append = TRUE, na = "", quote = FALSE, row.names = FALSE)

#Remove any unnecessary dataframes for the NDA upload
rm(PKBS_NDA_Prep, first_line)
#rm(Pedigree, Qualtrics, Redcap_Data)
#----------------------------------------------------------------------------------------------------------------------------------------
