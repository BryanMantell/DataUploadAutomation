# Title: EL Upload Script

# Setup


# import data frame
#setwd("~/GitHub/DataUploadAutomation/Upload and Tables/Data")
source("~/GitHub/DataUploadAutomation/Upload and Tables/Data/Upload Preparation.R")


Emotion_Labeling_NDA <- read.csv("elt01_template.csv", skip=1)

options(digits = 3)

library(lmSupport) 
library(plyr)



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




