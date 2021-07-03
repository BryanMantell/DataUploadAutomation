# title: "PPVT Upload Script"
# author: "Austin Fisenko"


# Set working directory and Load preparation script, NDA templates, and PPVT specific redcap data
setwd("~/GitHub/DataUploadAutomation/Upload and Tables/Data")
PPVT_NDA <- read.csv("ppvt_4a02_template.csv", skip = 1, stringsAsFactors = FALSE)
UPMC_PPVT_Data <- read.csv("UPMC_PPVT_Data.csv", stringsAsFactors = FALSE)
UO_PPVT_Data <- read.csv("UO_PPVT_Data.csv", stringsAsFactors = FALSE)

# Run Preparation Script if not running from Upload Driver as intended
#source("~/GitHub/DataUploadAutomation/Upload and Tables/Scripts/Upload Preparation.R")

# Create Redcap column names for locating old names to be replaced with Prep names and NDA names later on
PPVT_names <- c("om_ppvt_rs", "om_ppvt_ss", "oc_ppvt_rs", "oc_ppvt_ss")
NDA_PPVT_names <- c("ss_rawscore", "ss_standardscore")

# Select and rename needed columns from PPVT data across both sites
UPMC_PPVT_Data <- select(UPMC_PPVT_Data, c(Fam_ID = STEADY.ID., om_ppvt_rs = Parent.PPVT.Raw.Score, om_ppvt_ss = Parent.PPVT.Standard.Score, oc_ppvt_rs = Child.PPVT.Raw.Score, oc_ppvt_ss = Child.PPVT.Standard.Score))

# Additionally, Seperate and recombine UO mom and child data so it matches UPMC format when merging
UO_PPVTMom_Data <- select(UO_PPVT_Data, c(Fam_ID = fam_id, om_ppvt_rs, om_ppvt_ss))
UO_PPVTChild_Data <- select(UO_PPVT_Data, c(Fam_ID = fam_id, oc_ppvt_rs, oc_ppvt_ss))
Redcap_Data_PPVT <- merge(na.omit(UO_PPVTMom_Data), na.omit(UO_PPVTChild_Data), all=TRUE)

# Combine UO and UPMC data into a single dataframe
PPVT_BothSite_Data <- rbind(Redcap_Data_PPVT, UPMC_PPVT_Data)

# Select relevent pedigree information from the Preparation Script's created pedigree
Pedigree_Prep <- data.frame(select(Pedigree, Fam_ID, Timepoint, child_guid, mom_guid, child_famID, FamID_Mother, interview_date, interview_age_Mom, interview_age_child, child_sex, sex_mother, GroupAssignment))

# Filter Pedigree so that is only has PPVT's Timepoint 1 data
Pedigree_Prep <- Pedigree_Prep[Pedigree_Prep$Timepoint == 1, ] 

# Merge Predigree and PPVT redcap data
PPVT_PREP <- merge(Pedigree_Prep, PPVT_BothSite_Data,by = c("Fam_ID"), all.x = TRUE)

# Clean Environment of intermediaries
rm(Pedigree_Prep, Redcap_Data_PPVT, PPVT_BothSite_Data, UPMC_PPVT_Data, UO_PPVTChild_Data, UO_PPVTMom_Data, UO_PPVT_Data)

# Pull apart PPVT_Prep so that the data can be placed into a proper template such that Mom and child are on their own rows
# Filter mother data by Fam_ID for UO and UPMC individually to assign differing timepoints
PPVT_PREP_UO_Mom <- select(PPVT_PREP, c(Fam_ID, guid = mom_guid, src_subject_id = FamID_Mother, interview_date, interview_age = interview_age_Mom, sex = sex_mother, GroupAssignment, om_ppvt_rs, om_ppvt_ss))
PPVT_PREP_UO_Mom <- add_column(PPVT_PREP_UO_Mom, Timepoint = "0")
PPVT_PREP_UO_Mom <- PPVT_PREP_UO_Mom[PPVT_PREP_UO_Mom$Fam_ID > 12000, ]

PPVT_PREP_UPMC_Mom <- select(PPVT_PREP, c(Fam_ID, guid = mom_guid, src_subject_id = FamID_Mother, interview_date, interview_age = interview_age_Mom, sex = sex_mother, GroupAssignment, Timepoint, om_ppvt_rs, om_ppvt_ss))
PPVT_PREP_UPMC_Mom <- PPVT_PREP_UPMC_Mom[PPVT_PREP_UPMC_Mom$Fam_ID < 12000, ]

PPVT_PREP_Child <- select(PPVT_PREP, c(Fam_ID, guid = child_guid, src_subject_id = child_famID, interview_date, interview_age = interview_age_child, sex = child_sex, GroupAssignment, Timepoint, oc_ppvt_rs, oc_ppvt_ss))

# Merge selected data together so that mother and child each have their own rows, you should now have the complete PPVT_PREP sheet
PPVT_PREP_Mom <- merge(PPVT_PREP_UO_Mom, PPVT_PREP_UPMC_Mom, all = TRUE)
PPVT_PREP <- merge(PPVT_PREP_Mom, PPVT_PREP_Child, all = TRUE)

# Clean Environment of intermediaries
rm(PPVT_PREP_UO_Mom, PPVT_PREP_UPMC_Mom, PPVT_PREP_Child, PPVT_PREP_Mom)

#### NDA Upload ####
# Create NDA prep sheet separately for mom and child data since NDA uses one score to represent both
# Select all the needed columns from prep sheet
NDA_PPVT_Prep_Child <- select(PPVT_PREP, c(subjectkey = guid, src_subject_id, interview_date, interview_age, sex, ss_rawscore = oc_ppvt_rs, ss_standardscore = oc_ppvt_ss, visit = Timepoint))
NDA_PPVT_Prep_Child <- NDA_PPVT_Prep_Child[NDA_PPVT_Prep_Child$interview_age < 100, ]

NDA_PPVT_Prep_Mom <- select(PPVT_PREP, c(subjectkey = guid, src_subject_id, interview_date, interview_age, sex, ss_rawscore = om_ppvt_rs, ss_standardscore = om_ppvt_ss, visit = Timepoint))
NDA_PPVT_Prep_Mom <- NDA_PPVT_Prep_Mom[NDA_PPVT_Prep_Mom$interview_age > 100, ]

# Bind child and mom data into one data frame
NDA_PPVT_Prep <- rbind(NDA_PPVT_Prep_Child, NDA_PPVT_Prep_Mom)

# Arrange PPVT data so Mother and Child subjectkeys are next to each other for readability. 
#NDA_PPVT_Prep <- arrange(NDA_PPVT_Prep, src_subject_id)

# Recreate first line in original NDA file 
PPVT_NDA <- bind_rows(mutate_all(PPVT_NDA, as.character), mutate_all(NDA_PPVT_Prep, as.character))
first_line <- matrix("", nrow = 1, ncol = ncol(PPVT_NDA))
first_line[,1] <- "ppvt_4a"
# assign the second cell in first_line as 2
first_line[,2] <- "2"

# NDA output ---------
# Create a new file in folder called ppvt_4a.csv, and put first line into this file
# ppvt_4a.csv file will be saved into the NDA Upload Folder
write.table(first_line, file = "NDA Upload/ppvt_4a.csv", sep = ",", append = FALSE, quote = FALSE, na = "", col.names = FALSE, row.names = FALSE)

# Append data in NDA_DCCS into dccs.cav file 
write.table(PPVT_NDA, file = 'NDA Upload/ppvt_4a.csv', sep = ",", append = TRUE, na = "", quote = FALSE, row.names = FALSE)

#Clean Global Environment of intermediaries
rm(first_line, PPVT_names, NDA_PPVT_Prep, NDA_PPVT_Prep_Child, NDA_PPVT_Prep_Mom)
