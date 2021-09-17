# title: "AutomatingtheDataUpload - DimensionalCardSort"
# author: "Min Zhang"
# date: "6/2/21


setwd("~/GitHub/DataUploadAutomation/Upload and Tables/Data")
DCS_NDA <- read.csv("dccs01_template.csv", skip = 1, stringsAsFactors = FALSE)


# Rename Columns
# Create old & new variable names
# Old DCS name: oc_dcs_01 ~ oc_dcs_36
# NDA name: dcs01 ~ dcs36
# Redcap column name: oc_dcs_1:36
old_DCS_names <- sprintf("oc_dcs_%02d", 1:36)

# DCCS NDA Columns Name TODO:wait for Bryan to confirm
DCS_NDA_names <- sprintf("dcs%02d", 1:36)

# Prep Sheet
# Select relevant pedigree information, rename as needed. (Include GroupAssignment for treatment progress calculation.)
# Assign Timepoint base on redcap_event_name
Redcap_Data$Timepoint = sapply(strsplit(as.character(Redcap_Data$redcap_event_name), split = '_', fixed = T), function(x) (x[2])) 

Pedigree_Name <- names(Pedigree)
# Select needed columns and rename in Redcap_Data
DCS_Prep <- select(Redcap_Data, c(Pedigree_Name,starts_with("oc_dcs_")))
DCS_Prep <- select(DCS_Prep, -c(oc_dcs_notes))

# Turn -9999s to NA
DCS_Prep[DCS_Prep == -9999] <- NA

# Merge Pedigree and redcap files
#DCS_Prep <- merge(Pedigree, DCS_Prep,by = c("Timepoint","Fam_ID"), all = TRUE)

# Recode
# Re=-code UO Groupassignment 
DCS_Prep <- DCS_Prep %>% 
  mutate_at(c("GroupAssignment"),
            funs(recode(., "Assigned Group 3 (HC)" = "Healthy", 
                        'Assigned Group 2 (FSU)' = "NO DBT",
                        'Assigned Group 1 (DBT)' = "DBT")))


# TODO: apply 67% rule 
# Check NA percentage   0:100%data     1 0% data 
DCS_Prep$NACheck <- rowSums(is.na(select(DCS_Prep, starts_with("oc_cds_"))))/ncol(dplyr::select(DCS_Prep, starts_with("srm")))
DCS_Prep <- add_column(DCS_Prep, dcs_total = varScore(DCS_Prep, Forward = c("oc_dcs_01", "oc_dcs_02", "oc_dcs_03",
                                                                        "oc_dcs_04", "oc_dcs_05", "oc_dcs_06",
                                                                        "oc_dcs_07", "oc_dcs_08", "oc_dcs_09", 
                                                                        "oc_dcs_10", "oc_dcs_11", "oc_dcs_12", 
                                                                        "oc_dcs_13", "oc_dcs_14", "oc_dcs_15", 
                                                                        "oc_dcs_16", "oc_dcs_17", "oc_dcs_18",
                                                                        "oc_dcs_19", "oc_dcs_20", "oc_dcs_21", 
                                                                        "oc_dcs_22", "oc_dcs_23", "oc_dcs_24",
                                                                        "oc_dcs_25", "oc_dcs_26", "oc_dcs_27",
                                                                        "oc_dcs_28", "oc_dcs_29", "oc_dcs_30", 
                                                                        "oc_dcs_31", "oc_dcs_32", "oc_dcs_33",
                                                                        "oc_dcs_34", "oc_dcs_35", "oc_dcs_36"), MaxMiss = .20))


# NDA Sheet
# Create NDA Prep sheet, select all the needed columns from Prep sheet
DCS_NDA_Prep <- select(DCS_Prep, c(subjectkey = child_guid, src_subject_id = child_famID, interview_date, interview_age = interview_age_child, sex = child_sex, visit = Timepoint, starts_with("oc_dcs_"), nih_dccs_raw = dcs_total))

# Replace columns name 
setnames(DCS_NDA_Prep, old_DCS_names, DCS_NDA_names)

# Recreate first line in original NDA file
DCS_NDA <- bind_rows(mutate_all(DCS_NDA, as.character), mutate_all(DCS_NDA_Prep, as.character))
first_line <- matrix("", nrow = 1, ncol = ncol(DCS_NDA))
first_line[,1] <- "dccs"
# assign the second cell in first_line as dccs
first_line[,2] <- "1"

# NDA output ####
# Create a new file in folder called dccs.csv, and put first line into this file
# dccs.csv file will be saved into same folder as current r script
write.table(first_line, file = "NDA Upload/dccs01.csv", sep = ",", append = FALSE, quote = FALSE, na = "", col.names = FALSE, row.names = FALSE)

# Append data in NDA_DCCS into dccs.csv file 
write.table(DCS_NDA, file = 'NDA Upload/dccs01.csv', sep = ",", append = TRUE, na = "", quote = FALSE, row.names = FALSE)


# clean envirment 
rm(DCS_NDA_Prep, first_line)

