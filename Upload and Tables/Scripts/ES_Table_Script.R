# title: "EmotionStrategies Upload Script"
# author: "Austin Fisenko"

# Empty Global Environment
#rm(list = ls())

# Load preparation script and NDA templates
setwd("~/GitHub/DataUploadAutomation/Upload and Tables/Data")
#source("~/GitHub/DataUploadAutomation/Upload and Tables/Scripts/ES_Upload_Script.R")

# Treatment Progress sheet
# Select needed column
Progress <- select(ES_PREP, c(Fam_ID, GroupAssignment, Timepoint, oc_es_hap_total, oc_es_ang_total, oc_es_sad_total, oc_es_total,))

# Calculate row mean for each individual  
Progress$Row_Mean_Hap <- rowMeans(select(ES_PREP,c(oc_es_hap_total)), na.rm = TRUE)
Progress$Row_Mean_Ang <- rowMeans(select(ES_PREP,c(oc_es_ang_total)), na.rm = TRUE)
Progress$Row_Mean_Sad <- rowMeans(select(ES_PREP,c(oc_es_sad_total)), na.rm = TRUE)
Progress$Row_Mean_Total <- rowMeans(select(ES_PREP,c(oc_es_total)), na.rm = TRUE)

# Change FamId as character and assign to ID variable 
ID <- c(as.character(Progress$Fam_ID))

# Add Site column to Progress, if ID start with 9 then site is UO, else is UPMC
Progress$site <- ifelse(startsWith(ID, "9"),"UO","UPMC")

# Group by GroupAssignmentand Timepoint, and calculate the Group Mean
Progress_Hap_Mean <- Progress %>%
  group_by(GroupAssignment,Timepoint,site) %>%
  summarise(HapMean = mean(Row_Mean_Hap,na.rm = T),count = n())

Progress_Ang_Mean <- Progress %>%
  group_by(GroupAssignment,Timepoint,site) %>%
  summarise(AngMean = mean(Row_Mean_Ang,na.rm = T),count = n())

Progress_Sad_Mean <- Progress %>%
  group_by(GroupAssignment,Timepoint,site) %>%
  summarise(SadMean = mean(Row_Mean_Sad,na.rm = T),count = n())

Progress_Total_Mean <- Progress %>%
  group_by(GroupAssignment,Timepoint,site) %>%
  summarise(TotalMean = mean(Row_Mean_Total,na.rm = T),count = n())

# Join happy, angry, sad, and total
Progress_Mean <- merge(Progress_Hap_Mean, Progress_Ang_Mean)
Progress_Mean <- merge(Progress_Mean, Progress_Sad_Mean)
Progress_Mean <- merge(Progress_Mean, Progress_Total_Mean)

# Select only UO Mean
UO <- Progress_Mean[Progress_Mean$site == "UO",]
# Select only UPMC Mean 
UPMC <- Progress_Mean[Progress_Mean$site == "UPMC",]

# Calculate Both site Mean 
Progress_Hap_Mean_Both <- Progress %>%
  group_by(GroupAssignment, Timepoint) %>%
  summarise("BothSite_ES_HappyMean" = mean(Row_Mean_Hap,na.rm = T),n = n())

Progress_Ang_Mean_Both <- Progress %>%
  group_by(GroupAssignment, Timepoint) %>%
  summarise("BothSite_ES_AngryMean" = mean(Row_Mean_Ang,na.rm = T),n = n())

Progress_Sad_Mean_Both <- Progress %>%
  group_by(GroupAssignment, Timepoint) %>%
  summarise("BothSite_ES_SadMean" = mean(Row_Mean_Sad,na.rm = T),n = n())

Progress_Total_Mean_Both <- Progress %>%
  group_by(GroupAssignment, Timepoint) %>%
  summarise("BothSite_ES_TotalMean" = mean(Row_Mean_Total,na.rm = T),n = n())

Both_Site_Mean <- merge(Progress_Hap_Mean_Both, Progress_Ang_Mean_Both)
Both_Site_Mean <- merge(Both_Site_Mean, Progress_Sad_Mean_Both)
Both_Site_Mean <- merge(Both_Site_Mean, Progress_Total_Mean_Both)

# Filter group assignment so they all use the same language
UO <- UO %>% filter(GroupAssignment == "DBT"
                    | GroupAssignment == "NO DBT"
                    | GroupAssignment == "Healthy")
UPMC <- UPMC %>% filter(GroupAssignment == "DBT"
                        | GroupAssignment == "NO DBT"
                        | GroupAssignment == "Healthy")
Both_Site_Mean <- Both_Site_Mean %>% filter(GroupAssignment == "DBT"
                                            | GroupAssignment == "NO DBT"
                                            | GroupAssignment == "Healthy")

# Change GroupMean Column names according to site
colnames(UO)[colnames(UO) == "HapMean"] = "UO_ES_HappyMean"
colnames(UO)[colnames(UO) == "AngMean"] = "UO_ES_AngryMean"
colnames(UO)[colnames(UO) == "SadMean"] = "UO_ES_SadMean"
colnames(UO)[colnames(UO) == "TotalMean"] = "UO_ES_TotalMean"
colnames(UPMC)[colnames(UPMC) == "HapMean"] = "UPMC_ES_HappyMean"
colnames(UPMC)[colnames(UPMC) == "AngMean"] = "UPMC_ES_AngryMean"
colnames(UPMC)[colnames(UPMC) == "SadMean"] = "UPMC_ES_SadMean"
colnames(UPMC)[colnames(UPMC) == "TotalMean"] = "UPMC_ES_TotalMean"


# Combine UO,UPMC and both_site data 
Mean_Table <- data.frame(UO[,c("UO_ES_HappyMean","UO_ES_AngryMean", "UO_ES_SadMean", "UO_ES_TotalMean")],UPMC[,c("UPMC_ES_HappyMean", "UPMC_ES_AngryMean", "UPMC_ES_SadMean", "UPMC_ES_TotalMean")],Both_Site_Mean[,c("BothSite_ES_HappyMean", "BothSite_ES_AngryMean", "BothSite_ES_SadMean", "BothSite_ES_TotalMean", "n", "GroupAssignment")])


# Convert Mean_Table, make original column as row
Mean_Table <- t(Mean_Table)

# Make Mean_Table as a data.frame
Mean_Table <- data.frame(Mean_Table)

# Reorder Mean_Table
Mean_Table <- Mean_Table[c(5,6,7,8,9,10,11,12,1,2,3,4)]

# Add Timepoint column 
Timepoint_names <- c("T1","T2", "T3", "T4","T1","T2", "T3", "T4","T1","T2", "T3", "T4")

# Rename column name 
setnames(Mean_Table, names(Mean_Table), Timepoint_names)

# Table output ----------
# Add a header
kable(Mean_Table) %>%
  kable_styling(bootstrap_options = "striped", full_width = T) %>%
  add_header_above(c(" " = 1, "Controls Group means" = 4, "FSU Group means" = 4, "DBT Group means" = 4)) %>%
  add_header_above(c("Emotion Strategies Mean Table" = 13)) %>%
  column_spec(c(1,5,9), border_right = T, include_thead = T) %>%
  column_spec(c(2,3,4,5,6,7,8,9,10,11,12,13), width_min = "2cm", width_max = "2cm")

# Clean Environment
rm(Both_Site_Mean, Progress, Progress_Mean, Progress_Ang_Mean, Progress_Ang_Mean_Both, Progress_Hap_Mean, Progress_Hap_Mean_Both, Progress_Sad_Mean, Progress_Sad_Mean_Both, Progress_Total_Mean, Progress_Total_Mean_Both, UO, UPMC, ID, Timepoint_names)