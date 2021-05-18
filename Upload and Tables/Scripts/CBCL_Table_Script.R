# title: "CBCL Table Script"
# author: "Austin Fisenko"

# Empty Global Environment, potentially set working directory
#rm(list = ls())

# Load necessary data from CBCL upload script, set source to where your CBCL script is on your computer, set working directory to where your measures/CBCL folder
source("~/GitHub/DataUploadAutomation/Upload and Tables/Scripts/CBCL_Upload_Script.R")

Progress <- select(CBCL_Prep, c(Fam_ID, GroupAssignment, Timepoint, CBCL_TOT_t, CBCL_INT_t, CBCL_EXT_t, starts_with("srm")))

# Change FamId as character and assign it to the ID variable 
ID <- c(as.character(Progress$FamID))

# Add "Site" column to Progress, if an ID start with 9 then the site is UO, otherwise it is UPMC
Progress$site <- ifelse(startsWith(ID, "9"),"UO","UPMC")

# Group by GroupAssignment  and Timepoint, and calculate the Group Mean
# Grouping & calculation for CBCL total
Progress_Total_Mean <- Progress %>%
  group_by(GroupAssignment,timepoint,site) %>%
  summarise(TotalMean = mean(CBCL_TOT_t,na.rm = T),count = n())

# Grouping & calculation for CBCL Int
Progress_Int_Mean <- Progress %>%
  group_by(GroupAssignment,timepoint,site) %>%
  summarise(IntMean = mean(CBCL_INT_t,na.rm = T),count = n())

# Grouping & calculation for CBCL Ext
Progress_Ext_Mean <- Progress %>%
  group_by(GroupAssignment,timepoint,site) %>%
  summarise(ExtMean = mean(CBCL_EXT_t,na.rm = T),count = n())

# Merge Total, Int, and Ext calculations
Progress_Mean <- merge(Progress_Int_Mean, Progress_Ext_Mean)
Progress_Mean <- merge(Progress_Mean, Progress_Total_Mean)

# Select only UO Mean to have UO data separate
UO <- Progress_Mean[Progress_Mean$site == "UO",]

# Select only UPMC Mean to have UMPC data separate
UPMC <- Progress_Mean[Progress_Mean$site == "UPMC",]

# Calculate both site mean between UO and UMPC
# Grouping & calculation for CBCL total
Progress_Total_Mean_Both <- Progress %>%
  group_by(GroupAssignment, timepoint) %>%
  summarise("BothSite_CBCL_TotalMean" = mean(CBCL_TOT_t,na.rm = T),n = n())

# Grouping & calculation for CBCL Int
Progress_Int_Mean_Both <- Progress %>%
  group_by(GroupAssignment, timepoint) %>%
  summarise("BothSite_CBCL_IntMean" = mean(CBCL_INT_t,na.rm = T),n = n())

# Grouping & calculation for CBCL Ext
Progress_Ext_Mean_Both <- Progress %>%
  group_by(GroupAssignment, timepoint) %>%
  summarise("BothSite_CBCL_ExtMean" = mean(CBCL_EXT_t,na.rm = T),n = n())

# Merge both site Total, Int, and Ext calculations 
Both_Site_Mean <- merge(Progress_Int_Mean_Both, Progress_Ext_Mean_Both)
Both_Site_Mean <- merge(Both_Site_Mean, Progress_Total_Mean_Both)

# Change GroupMean Column names according to site and subscale
colnames(UO)[colnames(UO) == "TotalMean"] = "UO_CBCL_TotalMean"
colnames(UO)[colnames(UO) == "IntMean"] = "UO_CBCL_IntMean"
colnames(UO)[colnames(UO) == "ExtMean"] = "UO_CBCL_ExtMean"
colnames(UPMC)[colnames(UPMC) == "TotalMean"] = "UPMC_CBCL_TotalMean"
colnames(UPMC)[colnames(UPMC) == "IntMean"] = "UPMC_CBCL_IntMean"
colnames(UPMC)[colnames(UPMC) == "ExtMean"] = "UPMC_CBCL_ExtMean"

# Combine UO,UPMC and both_site data 
Mean_Table <- data.frame(UO[,c("UO_CBCL_TotalMean","UO_CBCL_IntMean", "UO_CBCL_ExtMean")],UPMC[,c("UPMC_CBCL_TotalMean", "UPMC_CBCL_IntMean", "UPMC_CBCL_ExtMean")],Both_Site_Mean[,c("BothSite_CBCL_TotalMean", "BothSite_CBCL_IntMean", "BothSite_CBCL_ExtMean","n", "GroupAssignment")])

# Convert Mean_Table, make original column as row
Mean_Table <- t(Mean_Table)

# Make Mean_Table as a data.frame
Mean_Table <- data.frame(Mean_Table)

# Reorder Mean_Table
Mean_Table <- Mean_Table[c(5,6,7,8,9,10,11,12,1,2,3,4)]

# Add Timepoint columns
Timepoint_names <- c("T1","T2", "T3", "T4","T1","T2", "T3", "T4","T1","T2", "T3", "T4")

# Rename column names
setnames(Mean_Table, names(Mean_Table), Timepoint_names)

# Table output ----------
# Add a header 
kable(Mean_Table) %>%
  kable_styling(bootstrap_options = "striped", full_width = T) %>%
  add_header_above(c(" " = 1, "Controls Group means" = 4, "FSU Group means" = 4, "DBT Group means" = 4)) %>%
  add_header_above(c("CBCL Mean Table (t-Scores" = 13)) %>%
  column_spec(c(1,5,9), border_right = T, include_thead = T) %>%
  column_spec(c(2,3,4,5,6,7,8,9,10,11,12,13), width_min = "2cm", width_max = "2cm")

# Clean Environment of intermediate calculations for "all data" table.
rm(Progress, Progress_Ext_Mean, Progress_Ext_Mean_Both, Progress_Int_Mean, Progress_Int_Mean_Both, Progress_Mean, Progress_Total_Mean, Progress_Total_Mean_Both, Both_Site_Mean)
