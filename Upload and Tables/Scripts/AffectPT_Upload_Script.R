# title: "AffectPT Upload Script
# author:  Jacob Mulleavey

# Scientific Notation
options(digits = 3)

# Source data, templates and create NDA dataframe
setwd("~/GitHub/DataUploadAutomation/Upload and Tables/Data")
#getwd()

AffectPT_NDA <- read.csv("apt01_template.csv", skip = 1)

# Select the relevant sets of information from RedCap necessary for the AffectPT
AffectPT_Prep <- select(Redcap_Data, c(child_guid, child_famID, interview_date, interview_age_child, child_sex, Timepoint, contains("oc_apt_")))

# Calculated Columns
#----------------------------------------------------------------------------------------------------------------------------------------
# Add empty scoring column to the existing data frame
AffectPT_Prep[, c("oc_apt_02", "oc_apt_04", "oc_apt_06", "oc_apt_08", "oc_apt_10", "oc_apt_12", 
                  "oc_apt_14", "oc_apt_16")] <- NA

# Remove total column from the prep script because it will be based on recoded columns in coming lines of code
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
AffectPT_NDA_Prep <- select(AffectPT_Prep, subjectkey = "child_guid", src_subject_id = "child_famID", interview_date, interview_age = "interview_age_child", sex = "child_sex", visit = "Timepoint", contains("oc_apt"))

# Match Prep Sheet column names to required NDA names
NDA_names <- c(paste("apt", 1:16, sep = ""))
prep_names <- c("oc_apt_01", "oc_apt_02", "oc_apt_03", "oc_apt_04", 
                "oc_apt_05", "oc_apt_06", "oc_apt_07", "oc_apt_08", "oc_apt_09", "oc_apt_10", "oc_apt_11", 
                "oc_apt_12", "oc_apt_13", "oc_apt_14", "oc_apt_15", "oc_apt_16")
setnames(AffectPT_NDA_Prep, prep_names, NDA_names, skip_absent = FALSE)

# Drop total column
AffectPT_NDA_Prep <- AffectPT_NDA_Prep[-c(23)]

# Combine NDA Template with NDA Structure
AffectPT_NDA[1,] <- NA
AffectPT_NDA <- bind_rows(AffectPT_NDA, AffectPT_NDA_Prep)

first_line <- matrix("", nrow = 1, ncol = ncol(AffectPT_NDA))
first_line[,1] <- "apt"
first_line[,2] <- "1"

# Remove empty row
AffectPT_NDA <- AffectPT_NDA[-c(1),]

#Turn any -9999 response to NA
na_if(AffectPT_NDA, -9999)

# Create a new file in folder called apt01.csv, and put first line into this file
# apt01.csv file will be saved into same folder as current r script
write.table(first_line, file = "apt01.csv", sep = ",", append = FALSE, quote = FALSE, na = "", col.names = FALSE, row.names = FALSE)

# Append data in AffectPT_NDA into apt01.csv file 
write.table(AffectPT_NDA, file = 'apt01.csv', sep = ",", append = TRUE, na = "", quote = FALSE, row.names = FALSE)

#Remove any unnecessary dataframes for the NDA upload
rm(AffectPT_NDA_Prep, first_line)
#rm(Pedigree, Qualtrics, Redcap_Data)
#----------------------------------------------------------------------------------------------------------------------------------------


