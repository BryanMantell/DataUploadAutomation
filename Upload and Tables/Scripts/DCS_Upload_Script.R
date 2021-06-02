# title: "AutomatingtheDataUpload - DimensionalCardSort"
# author: "Min Zhang"
# date: "6/2/21


setwd("~/GitHub/DataUploadAutomation/Upload and Tables/Data")
NDA_DCCS <- read.csv("dccs01_template.csv", skip = 1, stringsAsFactors = FALSE)


# Rename Columns
# Create old & new variable names
# Old DCS name: oc_dcs_01 ~ oc_dcs_36
# NDA name: dcs01 ~ dcs36
# Redcap column name: oc_dcs_1:36
old_DCS_names <- sprintf("oc_dcs_%02d", 1:36)

# DCCS NDA Columns Name TODO:wait for Bryan to confirm
NDA_DCS_names <- sprintf("dcs%02d", 1:36)

# Prep Sheet
# Select relevant pedigree information, rename as needed. (Include GroupAssignment for treatment progress calculation.)
# Assign Timepoint base on redcap_event_name
Redcap_Data$Timepoint = sapply(strsplit(as.character(Redcap_Data$redcap_event_name), split = '_', fixed = T), function(x) (x[2])) 

# Select needed columns and rename in Redcap_Data
Redcap_Data <- select(Redcap_Data, c(Fam_ID = fam_id,  Timepoint, starts_with("oc_dcs_")))
Redcap_Data <- select(Redcap_Data, -c(oc_dcs_notes))

# Select revelent pedigree information, rename as needed. (Include GroupAssignment for treatment progross calculation.)
Pedigree_T1 <- data.frame(select(Pedigree, Fam_ID =  FamID, child_guid, child_famID = FamID_Child, interview_date = Time1Date, interview_age = MomAge_T1, child_sex = ChildGender, GroupAssignment), Timepoint = 1 )
Pedigree_T2 <- data.frame(select(Pedigree, Fam_ID =  FamID, child_guid, child_famID = FamID_Child, interview_date = Time2Date, interview_age = MomAge_T2, child_sex = ChildGender, GroupAssignment), Timepoint = 2 )
Pedigree_T3 <- data.frame(select(Pedigree, Fam_ID =  FamID, child_guid, child_famID = FamID_Child, interview_date = Time3Date, interview_age = MomAge_T3, child_sex = ChildGender, GroupAssignment), Timepoint = 3 )
Pedigree_T4 <- data.frame(select(Pedigree, Fam_ID =  FamID, child_guid, child_famID = FamID_Child, interview_date = Time4Date, interview_age = MomAge_T4, child_sex = ChildGender, GroupAssignment), Timepoint = 4 )

# Merge 4 pedigree
Pedigree_Prep <- rbind(Pedigree_T1, Pedigree_T2, Pedigree_T3, Pedigree_T4)

# Merge Pedigree and redcap files
DCS_Prep <- merge(Pedigree_Prep, Redcap_Data,by = c("Timepoint","Fam_ID"), all = TRUE)

# Clean Environment
rm(Pedigree, Pedigree_Prep, Pedigree_T1, Pedigree_T2, Pedigree_T3, Pedigree_T4, Redcap_Data)


# Recode
# Re=-code UO Groupassignment 
DCS_Prep <- DCS_Prep %>% 
  mutate_at(c("GroupAssignment"),
            funs(recode(., "Assigned Group 3 (HC)" = "Healthy", 
                        'Assigned Group 2 (FSU)' = "NO DBT",
                        'Assigned Group 1 (DBT)' = "DBT")))


# TODO: apply 67% rule 
# Check NA percentage   0:100%data     1 0% data 
DCS_Prep$NACheck <- rowSums(is.na(select(DCS_Prep, starts_with("srm"))))/ncol(dplyr::select(DCS_Prep, starts_with("srm")))


# NDA Sheet
# Create NDA Prep sheet, select all the needed columns from Prep sheet
NDA_DCCS_Prep <- select(DCS_Prep, c(subjectkey = child_guid, src_subject_id = child_famID, interview_date, interview_age, sex = child_sex, visit = Timepoint, starts_with("oc_dcs_") ))

# Replace columns name 
setnames(NDA_DCCS_Prep, old_DCS_names, NDA_DCS_names)

# Add empty line in original NDA file for merge
NDA_DCCS[1,] <- NA
# Recreate first line in original NDA file
NDA_DCCS <- bind_rows(NDA_DCCS, NDA_DCCS_Prep)
first_line <- matrix("", nrow = 1, ncol = ncol(NDA_DCCS))
first_line[,1] <- "dccs"
# assign the second cell in first_line as dccs
first_line[,2] <- "1"

# NDA output ####
# Create a new file in folder called dccs.csv, and put first line into this file
# dccs.csv file will be saved into same folder as current r script
write.table(first_line, file = "dccs01.csv", sep = ",", append = FALSE, quote = FALSE, na = "", col.names = FALSE, row.names = FALSE)

# Append data in NDA_DCCS into dccs.csv file 
write.table(NDA_DCCS, file = 'dccs01.csv', sep = ",", append = TRUE, na = "", quote = FALSE, row.names = FALSE)
