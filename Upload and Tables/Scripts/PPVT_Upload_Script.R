# title: "PPVT Upload Script"
# author: "Austin Fisenko"

# Empty Global Environment
#rm(list = ls())

# Load preparation script and NDA templates
setwd("~/GitHub/DataUploadAutomation/Upload and Tables/Data")
#source("~/GitHub/DataUploadAutomation/Upload and Tables/Data/Upload Preparation.R")
PPVT_NDA <- read.csv("ppvt_4a02_template.csv", skip = 1, stringsAsFactors = FALSE)
UPMC_PPVT_Data <- read.csv("UPMC_PPVT_Data.csv", stringsAsFactors = FALSE)

# Redcap column names for locating old names to be replaced with Prep names and NDA names
PPVT_names <- c("om_ppvt_rs", "om_ppvt_ss", "oc_ppvt_rs", "oc_ppvt_ss")
NDA_PPVT_names <- c("ss_rawscore", "ss_standardscore")

# Select needed columns and rename in Redcap_Data & UPMC_PPVT_Data, then merge the two timepoints together
Redcap_Data_PPVT <- select(Redcap_Data, c(Fam_ID, om_ppvt_rs, om_ppvt_ss, oc_ppvt_rs, oc_ppvt_ss))
UPMC_PPVT_Data <- select(UPMC_PPVT_Data, c(Fam_ID = STEADY.ID., om_ppvt_rs = Parent.PPVT.Raw.Score, om_ppvt_ss = Parent.PPVT.Standard.Score, oc_ppvt_rs = Child.PPVT.Raw.Score, oc_ppvt_ss = Child.PPVT.Standard.Score))

PPVT_BothSite_Data <- rbind(Redcap_Data_PPVT, UPMC_PPVT_Data)

# Select revelent pedigree information, rename as needed.
Pedigree_Prep <- data.frame(select(Pedigree, Fam_ID, child_guid, mom_guid, child_famID, FamID_Mother, interview_date, interview_age_Mom, interview_age_child, child_sex, sex_mother, GroupAssignment), Timepoint = 1)

# Merge Predigree and redcap files
PPVT_PREP <- merge(Pedigree_Prep, PPVT_BothSite_Data,by = c("Fam_ID"), all = TRUE)

# Clean Environment
rm(Pedigree_Prep, Redcap_Data_PPVT, PPVT_BothSite_Data, UPMC_PPVT_Data)

# Create NDA prep sheet for mom and child data, select all the needed columns from prep sheet
NDA_PPVT_Prep_Child <- select(PPVT_PREP, c(subjectkey = child_guid, src_subject_id = child_famID, interview_date, interview_age = interview_age_child, sex = child_sex, ss_rawscore = oc_ppvt_rs, ss_standardscore = oc_ppvt_ss))
NDA_PPVT_Prep_Mom <- select(PPVT_PREP, c(subjectkey = mom_guid, src_subject_id = FamID_Mother, interview_date, interview_age = interview_age_Mom, sex = sex_mother, ss_rawscore = om_ppvt_rs, ss_standardscore = om_ppvt_ss))

# Remove duplicate data from mom and child prep sheets
NDA_PPVT_Prep_Child <- na.omit(NDA_PPVT_Prep_Child, ss_rawscore)
NDA_PPVT_Prep_Mom <- na.omit(NDA_PPVT_Prep_Mom, ss_rawscore)

# Bind child and mom data into one data frame and order by ID
NDA_PPVT_Prep <- rbind(NDA_PPVT_Prep_Child, NDA_PPVT_Prep_Mom)

# Arrange PPVT data so Mother and Child subjectkeys are next to each other for readability. 
NDA_PPVT_Prep <- arrange(NDA_PPVT_Prep, src_subject_id)

# Recreate first line in orignial NDA file 
PPVT_NDA <- bind_rows(mutate_all(PPVT_NDA, as.character), mutate_all(NDA_PPVT_Prep, as.character))
first_line <- matrix("", nrow = 1, ncol = ncol(PPVT_NDA))
first_line[,1] <- "ppvt_4a"
# assign the second cell in first_line as 2
first_line[,2] <- "2"

# NDA output ---------
# Create a new file in folder called ppvt_4a.csv, and put first line into this file
# ppvt_4a.csv file will be saved into same folder as current r script
write.table(first_line, file = "NDA Upload/ppvt_4a.csv", sep = ",", append = FALSE, quote = FALSE, na = "", col.names = FALSE, row.names = FALSE)

# Append data in NDA_DCCS into dccs.cav file 
write.table(PPVT_NDA, file = 'NDA Upload/ppvt_4a.csv', sep = ",", append = TRUE, na = "", quote = FALSE, row.names = FALSE)

#Clean Global Environment
rm(first_line, PPVT_names)