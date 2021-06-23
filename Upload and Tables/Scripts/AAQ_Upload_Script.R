# title: "AAQ Upload Script"
# author: Jacob Mulleavey

# Scientific Notation
options(digits = 3)

# Source data, templates and create NDA dataframe
setwd("~/GitHub/DataUploadAutomation/Upload and Tables/Data")
#getwd()

AAQ_NDA <- read.csv("acceptance01_template.csv", skip = 1)

# Select the relevant sets of information from Qualtrics necessary for the AAQ
AAQ_Prep <- select(Qualtrics, c(mom_guid, FamID_Mother, interview_date, interview_age_Mom, mother_sex, Timepoint, contains("srm_aaq")))          

# Calculated Columns
#----------------------------------------------------------------------------------------------------------------------------------------
# Change number to numeric values and Create Calculated Column 
AAQ_Prep[,7:16] <- sapply(AAQ_Prep[,7:16],as.numeric)

# Create Sums column
AAQ_Prep <- add_column(AAQ_Prep, aaq_total = varScore(AAQ_Prep, c("srm_aaq_1", "srm_aaq_2", "srm_aaq_3", "srm_aaq_4", "srm_aaq_5", 
                                                                   "srm_aaq_6", "srm_aaq_7", "srm_aaq_8", "srm_aaq_9", "srm_aaq_10"), 
                                                         Reverse = NULL, Range = NULL, Prorate = TRUE, MaxMiss = .33))
#----------------------------------------------------------------------------------------------------------------------------------------

# NDA Sheet
#----------------------------------------------------------------------------------------------------------------------------------------
# Retrieve and rename relevant columns from AAQ Prep Sheet for NDA structure
AAQ_NDA_Prep <- select(AAQ_Prep, c(subjectkey = "mom_guid", src_subject_id = "FamID_Mother", interview_age = "interview_age_Mom", interview_date, 
                                   sex = "mother_sex", visit = "Timepoint",starts_with("srm"), aaq_total))       

# Create columns names to match the existing NDA template
NDA_names <- c("aaq2_1", "aaq_1_16", "aaq2_3", "aaq2_4", "aaq2_5", "aaq32", "aaq2_6", "aaq24", "aaq2_8", "aaq2_9")

setnames(AAQ_NDA_Prep, new_AAQ_names, NDA_names, skip_absent = FALSE)
colnames(AAQ_NDA_Prep)[17] <- "aaq_score"

# Merge AAQ Prep Sheet into NDA structure
#AAQ_NDA[1,] <- NA
AAQ_NDA <- bind_rows(mutate_all(AAQ_NDA, as.character), mutate_all(AAQ_NDA_Prep, as.character))

# Recreate the first line of the NDA
first_line <- matrix("", nrow = 1, ncol = ncol(AAQ_NDA))
first_line[,1] <- "acceptance"
first_line[,2] <- "1"

#Remove Column X
AAQ_NDA <- AAQ_NDA[-c(90)]

# Create a new file in folder called acceptance01.csv, and put first line into this file
# acceptance01.csv file will be saved into same folder as current r script
write.table(first_line, file = "acceptance01.csv", sep = ",", append = FALSE, quote = FALSE, na = "", col.names = FALSE, row.names = FALSE)

# Append data in AAQ_NDA into acceptance01.csv file 
write.table(AAQ_NDA, file = 'acceptance01.csv', sep = ",", append = TRUE, na = "", quote = FALSE, row.names = FALSE)

#Remove any unnecessary dataframes for the NDA upload
rm(AAQ_NDA_Prep, first_line)
#rm(Pedigree, Qualtrics, Redcap_Data)
#----------------------------------------------------------------------------------------------------------------------------------------


