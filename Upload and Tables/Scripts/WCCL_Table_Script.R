# Title: WCCL Table Script

# Setup


# import data frame

setwd("~/GitHub/DataUploadAutomation/Upload and Tables/Data")
source("~/GitHub/DataUploadAutomation/Upload and Tables/Data/Upload Preparation.R")

# Make Progress 
Progress <- select(WCCL_Prep, c(FamID, GroupAssignment, Timepoint, starts_with("srm"), NACheck))

# Change FamId as character and assign to ID variable 
ID <- c(as.character(Progress$FamID))

# Add Site column to Progress, if ID start with 9 then site is UO, else is UPMC
Progress$site <- ifelse(startsWith(ID, "9"),"UO","UPMC")


# Drop people who are at less than 67% response
WCCL_DROP <- Progress[Progress$NACheck > 0.67, ]
WCCL_Prep67 <- Progress[Progress$NACheck <= 0.67, ]
WCCL_Prep100 <- Progress[Progress$NACheck == 0, ]

#Table 67%

# Progress DBT_WCCL Table
Progress67 <- select(WCCL_Prep67, c(FamID, GroupAssignment, Timepoint, starts_with("srm")))

# Change FamId as character and assign to ID variable 
ID <- c(as.character(Progress67$FamID))

# Add Site column to Progress, if ID start with 9 then site is UO, else is UPMC
Progress67$site <- ifelse(startsWith(ID, "9"),"UO","UPMC")

# calculate rowmeans for each individual
Progress67$Row_Mean <- rowMeans(select(WCCL_Prep67,c(starts_with("srm"))), na.rm = T)

# Group by GroupAssignment and Timepoint, and calculate the Group Mean
Progress_Mean <- Progress67 %>%
  group_by(GroupAssignment,Timepoint,site) %>%
  summarise(GroupMean = mean(Row_Mean,na.rm = T),count = n())

# Select only UO Mean
UO <- Progress_Mean[Progress_Mean$site == "UO",]
# Select only UPMC Mean 
UPMC <- Progress_Mean[Progress_Mean$site == "UPMC",]

# Calculate Both site Means 
Both_site_Mean <- Progress_Mean %>%
  group_by(GroupAssignment, Timepoint) %>%
  summarise(BothSiteMean = mean(GroupMean,na.rm = T),n = sum(count))

# Progress_Mean <- Progress_Mean[order(GroupAssignment),] 


# Change GroupMean Column names according to site
colnames(UO)[colnames(UO) == "GroupMean"] = "UO_WCCL"
colnames(UPMC)[colnames(UPMC) == "GroupMean"] = "UPMC_WCCL"

# Combine UO,UPMC and both_site data 
Mean_Table <- data.frame(UO[,c("UO_WCCL")],UPMC[,"UPMC_WCCL"],Both_site_Mean[,c("BothSiteMean","n", "GroupAssignment")])

# Mean_Table <- select(Mean_Table, -c(GroupAssignment))

# Convert Mean_Table, make original column as row
Mean_Table <- t(Mean_Table)

# Make Mean_Table as a data.frame
Mean_Table <- data.frame(Mean_Table)

Mean_Table <- Mean_Table[c(5,6,7,8,9,10,11,12,1,2,3,4)]

# Add Timepoint column 
Timepoint_names <- c("T1","T2", "T3", "T4","T1","T2", "T3", "T4","T1","T2", "T3", "T4")

# Rename column name 
setnames(Mean_Table, names(Mean_Table), Timepoint_names)

# Add a header 
kable(Mean_Table) %>%
  kable_styling(bootstrap_options = "striped", full_width = F) %>%
  add_header_above(c(" " = 1, "Control Group means" = 4, "FSU means" = 4, "DBT Group means" = 4)) %>% add_header_above(c("WCCL Table Means 67%" = 13))%>%
  column_spec(c(1,5,9), border_right = T, include_thead = T) %>%
  column_spec(c(2,3,4,5,6,7,8,9,10,11,12,13), width_min = "2cm", width_max = "2cm")


#Table 100%
# Progress DBT_WCCL Table
Progress100 <- select(WCCL_Prep100, c(FamID, GroupAssignment, Timepoint, starts_with("srm")))

# Change FamId as character and assign to ID variable 
ID <- c(as.character(Progress100$FamID))

# Add Site column to Progress, if ID start with 9 then site is UO, else is UPMC
Progress100$site <- ifelse(startsWith(ID, "9"),"UO","UPMC")

# Calculate rowmeans for each individual
Progress100$Row_Mean <- rowMeans(select(WCCL_Prep100,c(starts_with("srm"))), na.rm = T)

# Group by GroupAssignment and Timepoint, and calculate the Group Mean
Progress_Mean <- Progress100 %>%
  group_by(GroupAssignment,Timepoint,site) %>%
  summarise(GroupMean = mean(Row_Mean,na.rm = T),count = n())

# Select only UO Mean
UO <- Progress_Mean[Progress_Mean$site == "UO",]
# Select only UPMC Mean 
UPMC <- Progress_Mean[Progress_Mean$site == "UPMC",]

# Calculate Both site Means 
Both_site_Mean <- Progress_Mean %>%
  group_by(GroupAssignment, Timepoint) %>%
  summarise(BothSiteMean = mean(GroupMean,na.rm = T),n = sum(count))

# Progress_Mean <- Progress_Mean[order(GroupAssignment),] 


# Change GroupMean Column names according to site
colnames(UO)[colnames(UO) == "GroupMean"] = "UO_WCCL"
colnames(UPMC)[colnames(UPMC) == "GroupMean"] = "UPMC_WCCL"

# Combine UO,UPMC and both_site data 
Mean_Table100 <- data.frame(UO[,c("UO_WCCL")],UPMC[,"UPMC_WCCL"],Both_site_Mean[,c("BothSiteMean","n", "GroupAssignment")])

# Mean_Table <- select(Mean_Table, -c(GroupAssignment))

# Convert Mean_Table, make original column as row
Mean_Table100 <- t(Mean_Table100)

# Make Mean_Table as a data.frame
Mean_Table100 <- data.frame(Mean_Table100)

Mean_Table100 <- Mean_Table100[c(5,6,7,8,9,10,11,12,1,2,3,4)]

# Add Timepoint column 
Timepoint_names <- c("T1","T2", "T3", "T4","T1","T2", "T3", "T4","T1","T2", "T3", "T4")

# Rename column name 
setnames(Mean_Table100, names(Mean_Table100), Timepoint_names)

# Add a header 
kable(Mean_Table100) %>%
  kable_styling(bootstrap_options = "striped", full_width = F) %>%
  add_header_above(c(" " = 1, "Control Group means" = 4, "FSU means" = 4, "DBT Group means" = 4)) %>% add_header_above(c("WCCL Table Means 100%" = 13))%>%
  column_spec(c(1,5,9), border_right = T, include_thead = T) %>%
  column_spec(c(2,3,4,5,6,7,8,9,10,11,12,13), width_min = "2cm", width_max = "2cm")

#N's Table
# Original Table ####
# Original by site
N_ori <- Progress %>%
  group_by(Timepoint, site, GroupAssignment) %>% 
  summarise(n_ori = n())

# Original both site 
N_ori_BothSite <- Progress %>%
  group_by(Timepoint, GroupAssignment) %>% 
  summarise(BothSite_Original_N = n())
