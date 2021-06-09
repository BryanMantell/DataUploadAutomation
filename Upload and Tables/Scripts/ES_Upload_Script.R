# title: "EmotionStrategies Upload Script"
# author: "Austin Fisenko"

# Empty Global Environment
#rm(list = ls())

# Load preparation script and NDA templates
setwd("~/GitHub/DataUploadAutomation/Upload and Tables/Data")
#source("~/GitHub/DataUploadAutomation/Upload and Tables/Data/Upload Preparation.R")
ES_NDA <- read.csv("ers01_template.csv", skip = 1, stringsAsFactors = FALSE)

# Redcap column names for locating old names to be replaced with Prep names and NDA names
NDA_ES_names <- sprintf("es_%01d", 1:12)

# Select needed columns and rename in Redcap_Data, rename to a different dataframe to avoid interference with other measures
ES_PREP <- select(Redcap_Data, c(child_guid, child_famID, interview_date, interview_age_Mom, interview_age_child, child_sex, GroupAssignment, Timepoint, starts_with("oc_es_")))
ES_PREP <- select(ES_PREP, -c(oc_es_notes, oc_es_hgen, oc_es_agen, oc_es_sgen, oc_es_intblue, oc_es_intgreen, oc_es_intmom))

# Select revelent pedigree information, rename as needed. (Include GroupAssignment for treatment progress calculation).
#Pedigree_Prep <- data.frame(select(Pedigree, child_guid, child_famID, interview_date, interview_age_Mom, interview_age_child, child_sex, GroupAssignment, Timepoint))

### Problem is here ###
# Exchange commas out of Prep Sheet to avoid CSV issues. Personal selection was a "/" but you can change it here to preference. 
ES_PREP <- lapply(ES_PREP, gsub, pattern = ",", replacement= "/")

# Merge Predigree and redcap files
#ES_PREP <- merge(Pedigree_Prep, Redcap_Data_ES,by = c("Timepoint"), all = TRUE)

# Clean Environment
#rm(Pedigree_Prep, Redcap_Data_ES)

# Set neccessary data to numeric so they can be used in calculations
ES_PREP[, c("oc_es_hap_1", "oc_es_hap_2", "oc_es_hap_3", "oc_es_ang_1", "oc_es_ang_2", "oc_es_ang_3", "oc_es_sad_1", "oc_es_sad_2", "oc_es_sad_3")] <- sapply(ES_PREP[, c("oc_es_hap_1", "oc_es_hap_2", "oc_es_hap_3", "oc_es_ang_1", "oc_es_ang_2", "oc_es_ang_3", "oc_es_sad_1", "oc_es_sad_2", "oc_es_sad_3")], as.numeric)

# Created calculated columns
ES_PREP <- add_column(ES_PREP, oc_es_hap_total = rowSums(ES_PREP[, c("oc_es_hap_1", "oc_es_hap_2", "oc_es_hap_3")]),.after = "oc_es_hap_3")

ES_PREP <- add_column(ES_PREP, oc_es_ang_total = rowSums(ES_PREP[, c("oc_es_ang_1", "oc_es_ang_2", "oc_es_ang_3")]),.after = "oc_es_ang_3")

ES_PREP <- add_column(ES_PREP, oc_es_sad_total = rowSums(ES_PREP[, c("oc_es_sad_1", "oc_es_sad_2", "oc_es_sad_3")]),.after = "oc_es_sad_3")

ES_PREP <- add_column(ES_PREP, oc_es_total = rowSums(ES_PREP[, c("oc_es_hap_1", "oc_es_hap_2", "oc_es_hap_3", "oc_es_ang_1", "oc_es_ang_2", "oc_es_ang_3", "oc_es_sad_1", "oc_es_sad_2", "oc_es_sad_3")]),.after = "oc_es_sad_total")

# Create NDA prep sheet, select all the needed columns from prep sheet but not total columns
NDA_ES_Prep <- select(ES_PREP, c(subjectkey = child_guid, src_subject_id = child_famID, interview_date, interview_age = interview_age_Mom, sex = child_sex, visit = Timepoint, starts_with("oc_es_")))
NDA_ES_Prep <- select(NDA_ES_Prep, -c(oc_es_hap_total, oc_es_ang_total, oc_es_sad_total, oc_es_total))

# Replace columns name 
setnames(NDA_ES_Prep, new_ES_names, NDA_ES_names)

# Recreate first line in orignial NDA file (visit is meant to be at the end)
ES_NDA <- bind_rows(mutate_all(ES_NDA, as.character), mutate_all(NDA_ES_Prep, as.character))
first_line <- matrix("", nrow = 1, ncol = ncol(ES_NDA))
first_line[,1] <- "ers"
# assign the second cell in first_line as 1
first_line[,2] <- "1"


# NDA output ---------
# Create a new file in folder called ers01.csv, and put first line into this file
# ers01.csv file will be saved into same folder as current r script
write.table(first_line, file = "ers01.csv", sep = ",", append = FALSE, quote = FALSE, na = "", col.names = FALSE, row.names = FALSE)

# Append data in NDA_DCCS into dccs.cav file 
write.table(ES_NDA, file = 'ers01.csv', sep = ",", append = TRUE, na = "", quote = FALSE, row.names = FALSE)

#Clean Global Environment
rm(first_line, NDA_ES_Prep, NDA_ES_names, new_ES_names)