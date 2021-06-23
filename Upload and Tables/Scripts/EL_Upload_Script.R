# Title: EL Upload Script

# Setup


# import data frame
#setwd("c:/GitHub/DataUploadAutomation/Upload and Tables/Data")
#source("~/GitHub/DataUploadAutomation/Upload and Tables/Data/Upload Preparation.R")
source("~/GitHub/DataUploadAutomation/Upload and Tables/Data/Upload Preparation.R")

Emotion_Labeling_NDA <- read.csv("elt01_template.csv", skip=1)

options(digits = 3)

#rename elt_exp names
eltpart1_exp <- "oc_elt_exp"
num_items <- seq(1:8)
new_eltpart1_names <- paste(eltpart1_exp, num_items, sep = "_")

#rename elt_rec names
eltpart2_rec <- "oc_elt_rec"
num_items <- seq (1:4) 
new_eltpart2_names <- paste(eltpart2_rec, num_items, sep = "_")

#replace old eltpart1 names with new names
eltpart1_exp <- "eltpart1_exp"
num_items <- seq (1:8)
old_eltpart1_names <- paste(eltpart1_exp, num_items, sep = "")
setnames(Redcap_Data, old_eltpart1_names, new_eltpart1_names)

#replace old eltpart2 names with new names
eltpart2_rec <- "eltpart2_rec"
num_items <- seq (1:4)
old_eltpart2_names <- paste(eltpart2_rec, num_items, sep = "")

setnames(Redcap_Data, old_eltpart2_names, new_eltpart2_names)

#EL_PREP <- select(Redcap_Data, c(child_guid, child_famID, interview_date, interview_age_child, child_sex, GroupAssignment, Timepoint, starts_with("oc_elt_")))
EL_PREP <- select(Redcap_Data, c(child_guid, child_famID, interview_date, interview_age, child_sex, timepoint, starts_with("oc_elt_")))
exp <- colnames(select(EL_PREP, c("oc_elt_exp_2", "oc_elt_exp_4", "oc_elt_exp_6", "oc_elt_exp_8")))

rec <- colnames(select(EL_PREP, c("oc_elt_rec_1", "oc_elt_rec_2", "oc_elt_rec_3", "oc_elt_rec_4")))

# add mean columns 
EL_PREP$oc_elt_exp_total <- rowMeans(EL_PREP[,exp], na.rm = TRUE)
EL_PREP$oc_elt_rec_total <- rowMeans(EL_PREP[,rec], na.rm = TRUE)

# Move relevant info to NDA dataframe
Emotion_Labeling_NDA <- select(EL_PREP, c(subjectkey = child_guid, src_subject_id = child_famID, interview_date, interview_age, sex = child_sex, visit = timepoint, starts_with("oc_elt_")))

# Recreate first line in orignial NDA file
Emotion_Labeling_NDA <- bind_rows(Emotion_Labeling_NDA, EL_PREP)
first_line <- matrix("", nrow = 1, ncol = ncol(Emotion_Labeling_NDA))
first_line[,1] <- "el"
# assign the second cell in first_line as "el"
first_line[,2] <- "1"

# NDA output ---------
# Create a new file in folder called el.csv, and put first line into this file
# el.csv file will be saved into same folder as current r script
write.table(first_line, file = "el01.csv", sep = ",", append = FALSE, quote = FALSE, na = "", col.names = FALSE, row.names = FALSE)

# Append data in Emotion_Ladeling_NDA into el.csv file 
write.table(Emotion_Labeling_NDA, file = 'el01.csv', sep = ",", append = TRUE, na = "", quote = FALSE, row.names = FALSE)




