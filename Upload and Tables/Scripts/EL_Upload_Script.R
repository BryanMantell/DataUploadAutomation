# Title: EL Upload Script
#Setwd
setwd("~/GitHub/DataUploadAutomation/Upload and Tables/Data")

Emotion_Labeling_NDA <- read.csv("elt01_template.csv", skip=1)
options(digits = 3)

#EL_PREP <- select(Redcap_Data, c(child_guid, child_famID, interview_date, interview_age_child, child_sex, GroupAssignment, Timepoint, starts_with("oc_elt_")))
EL_PREP <- select(Redcap_Data, c(child_guid, child_famID, interview_date, interview_age_child, child_sex, Timepoint, starts_with("oc_elt_")))

# add mean columns 
EL_PREP$oc_elt_exp_total <- rowMeans(EL_PREP[,exp], na.rm = TRUE)
EL_PREP$oc_elt_rec_total <- rowMeans(EL_PREP[,rec], na.rm = TRUE)

# Remove -9999s
EL_PREP[EL_PREP == -9999] <- NA

# Move relevant info to NDA dataframe
EL_NDA_Prep <- select(EL_PREP, c(subjectkey = child_guid, src_subject_id = child_famID, interview_date, interview_age = interview_age_child, sex = child_sex, visit = Timepoint, starts_with("oc_elt_")))

# Recreate first line in orignial NDA file
Emotion_Labeling_NDA <- bind_rows(mutate_all(Emotion_Labeling_NDA, as.character), mutate_all(EL_NDA_Prep, as.character))
first_line <- matrix("", nrow = 1, ncol = ncol(Emotion_Labeling_NDA))

# assign the second cell in first_line as "el"
first_line[,1] <- "el"
first_line[,2] <- "1"

# NDA output ---------
# Create a new file in folder called el.csv, and put first line into this file
# el.csv file will be saved into same folder as current r script
write.table(first_line, file = "NDA Upload/el01.csv", sep = ",", append = FALSE, quote = FALSE, na = "", col.names = FALSE, row.names = FALSE)

# Append data in Emotion_Ladeling_NDA into el.csv file 
write.table(Emotion_Labeling_NDA, file = 'NDA Upload/el01.csv', sep = ",", append = TRUE, na = "", quote = FALSE, row.names = FALSE)

# NDA output ---------
# Create a new file in folder called el.csv, and put first line into this file
# el.csv file will be saved into same folder as current r script
write.table(first_line, file = "NDA Upload/el01.csv", sep = ",", append = FALSE, quote = FALSE, na = "", col.names = FALSE, row.names = FALSE)

# Append data in Emotion_Ladeling_NDA into el.csv file 
write.table(Emotion_Labeling_NDA, file = 'NDA Upload/el01.csv', sep = ",", append = TRUE, na = "", quote = FALSE, row.names = FALSE)




