# title: "CCNES Mean Table"
# author: "Min Zhang"

source("~/Documents/GitHub/DataUploadAutomation/Upload and Tables/Scripts/CCNES_Upload_Script.R")


# Mean Tables ####
# All responsees Table ####
# Mean Table with all data (no drop)

# Select needed column
# TODO: Timepoint.x need to be fix 
Progress <- select(CCNES_Prep, c(Fam_ID, GroupAssignment, Timepoint, starts_with("srm_CCNES"), NACheck))

# Calculate row mean for each individual  
Progress$Supported_Mean <- rowMeans(CCNES_Prep[,c("CCNES_EE_imputation","CCNES_EFR_imputation", "CCNES_PFR_imputation")], na.rm = TRUE)
Progress$Unsupproted_Mean <- rowMeans(CCNES_Prep[,c("CCNES_DR_imputation", "CCNES_PR_imputation", "CCNES_MR_imputation")], na.rm = TRUE)

# Change FamId as character and assign to ID variable 
ID <- c(as.character(Progress$Fam_ID))

# Add Site column to Progress, if ID start with 9 then site is UO, else is UPMC
Progress$site <- ifelse(startsWith(ID, "9"),"UO","UPMC")

# Group by GroupAssissignment and Timepoint, and calculate the Supported_Mean and Unsupproted_Mean
Progress_Supported_Mean <- Progress %>%
  group_by(GroupAssignment, Timepoint, site) %>%
  summarise(SupportedMean = mean(Supported_Mean,na.rm = T), n = n())

Progress_unsupported_Mean <- Progress %>%
  group_by(GroupAssignment,Timepoint,site) %>%
  summarise(UnsupprotedMean = mean(Unsupproted_Mean,na.rm = T), n = n())

# Joint  Supported and un-supported 
Progress_Mean <- merge(Progress_Supported_Mean, Progress_unsupported_Mean)

# Select only UO Mean
UO <- Progress_Mean[Progress_Mean$site == "UO",]
# Select only UPMC Mean 
UPMC <- Progress_Mean[Progress_Mean$site == "UPMC",]

# Calculate Both site Mean for supported elements
Progress_Supported_Mean_both <- Progress %>%
  group_by(GroupAssignment,Timepoint) %>%
  summarise("BothSite_CCNES_SupportedMean" = mean(Supported_Mean,na.rm = T), n = n())

# Calculate Both site Mean for unsupported elements
Progress_unsupported_Mean_both <- Progress %>%
  group_by(GroupAssignment,Timepoint) %>%
  summarise("BothSite_CCNES_UnsupprotedMean" = mean(Unsupproted_Mean,na.rm = T), n = n())

# merge Supported and unsupported table for both site table 
Both_site_Mean <- merge(Progress_Supported_Mean_both, Progress_unsupported_Mean_both)
#Progress_Mean <- Progress_Mean[order(GroupAssignment),] 

# Change GroupMean Column names according to site
colnames(UO)[colnames(UO) == "SupportedMean"] = "UO_CCNES_SupportedMean"
colnames(UO)[colnames(UO) == "UnsupprotedMean"] = "UO_CCNES_UnsupprotedMean"
colnames(UPMC)[colnames(UPMC) == "SupportedMean"] = "UPMC_CCNES_SupportedMean"
colnames(UPMC)[colnames(UPMC) == "UnsupprotedMean"] = "UPMC_CCNES_UnsupprotedMean"

# Combine UO,UPMC and both_site data 
Mean_Table <- data.frame(UO[,c("UO_CCNES_SupportedMean","UO_CCNES_UnsupprotedMean")],UPMC[,c("UPMC_CCNES_SupportedMean","UPMC_CCNES_UnsupprotedMean")],Both_site_Mean[,c("BothSite_CCNES_SupportedMean","BothSite_CCNES_UnsupprotedMean","n","GroupAssignment")])

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

# Table output 
# Add a header 
kable(Mean_Table) %>%
  kable_styling(bootstrap_options = c("striped")) %>%
  add_header_above(c(" " = 1, "Controls Group means" = 4, "FSU Group means" = 4, "DBT Group means" = 4)) %>%
  add_header_above(c("CCNES Mean Table (All Data)" = 13)) %>%
  column_spec(c(1,5,9), border_right = T, include_thead = T) %>%
  column_spec(c(2,3,4,5,6,7,8,9,10,11,12,13), width_min = "2cm", width_max = "2cm")


# 67% Responses Table ####
# Drop participant have less than 67% data 

# Drop participant who has less than 67% data
CCNES_DROP <- Progress[Progress$NACheck > 0.67, ]
# Data contain 67% data or more
Progress67 <- Progress[Progress$NACheck <= 0.67, ]

# Group by GroupAssissignment and Timepoint, and calculate the Supported_Mean and Unsupproted_Mean
Progress_Supported_Mean67 <- Progress67 %>%
  group_by(GroupAssignment,Timepoint,site) %>%
  summarise(SupportedMean67 = mean(Supported_Mean,na.rm = T), n = n())

Progress_unsupported_Mean67 <- Progress67 %>%
  group_by(GroupAssignment,Timepoint,site) %>%
  summarise(UnsupprotedMean67 = mean(Unsupproted_Mean,na.rm = T), n = n())

# Joint  Supported and un-supported 
Progress_Mean67 <- merge(Progress_Supported_Mean67, Progress_unsupported_Mean67)

# Select only UO Mean
UO67 <- Progress_Mean67[Progress_Mean67$site == "UO",]
# Select only UPMC Mean 
UPMC67 <- Progress_Mean67[Progress_Mean67$site == "UPMC",]

# Colculate Both site Mean 
Progress_Supported_Mean_both67 <- Progress67 %>%
  group_by(GroupAssignment,Timepoint) %>%
  summarise("BothSite_CCNES_SupportedMean67" = mean(Supported_Mean, na.rm = T), n = n())

# Calculate Both site Mean for unsupported elements
Progress_unsupported_Mean_both67 <- Progress67 %>%
  group_by(GroupAssignment,Timepoint) %>%
  summarise("BothSite_CCNES_UnsupprotedMean67" = mean(Unsupproted_Mean,na.rm = T), n = n())

# merge Supported and unsupported table for both site table 
Both_site_Mean67 <- merge(Progress_Supported_Mean_both67, Progress_unsupported_Mean_both67)
#Progress_Mean <- Progress_Mean[order(GroupAssignment),] 

# Change GroupMean Column names according to site
colnames(UO67)[colnames(UO67) == "SupportedMean67"] = "UO_CCNES_SupportedMean"
colnames(UO67)[colnames(UO67) == "UnsupprotedMean67"] = "UO_CCNES_UnsupprotedMean"
colnames(UPMC67)[colnames(UPMC67) == "SupportedMean67"] = "UPMC_CCNES_SupportedMean"
colnames(UPMC67)[colnames(UPMC67) == "UnsupprotedMean67"] = "UPMC_CCNES_UnsupprotedMean"

# Combine UO,UPMC and both_site data 
Mean_Table67 <- data.frame(UO[,c("UO_CCNES_SupportedMean","UO_CCNES_UnsupprotedMean")],UPMC[,c("UPMC_CCNES_SupportedMean","UPMC_CCNES_UnsupprotedMean")],Both_site_Mean67[,c("BothSite_CCNES_SupportedMean67","BothSite_CCNES_UnsupprotedMean67","n","GroupAssignment")])

# Convert Mean_Table, make original column as row
Mean_Table67 <- t(Mean_Table67)

# Make Mean_Table as a data.frame
Mean_Table67 <- data.frame(Mean_Table67)

# Reorder Mean_Table
Mean_Table67 <- Mean_Table67[c(5,6,7,8,9,10,11,12,1,2,3,4)]

# Add Timepoint column 
Timepoint_names <- c("T1","T2", "T3", "T4","T1","T2", "T3", "T4","T1","T2", "T3", "T4")

# Rename column name 
setnames(Mean_Table67, names(Mean_Table67), Timepoint_names)

# Table output 
# Add a header 
kable(Mean_Table67) %>%
  kable_styling(bootstrap_options = c("striped")) %>%
  add_header_above(c(" " = 1, "Controls Group means with 67% rule" = 4, "FSU Group means" = 4, "DBT Group means" = 4)) %>%
  add_header_above(c("CCNES Mean Table (67% Drop Rule)" = 13)) %>%
  column_spec(c(1,5,9), border_right = T, include_thead = T) %>%
  column_spec(c(2,3,4,5,6,7,8,9,10,11,12,13), width_min = "2cm", width_max = "2cm")


# 100% Responses Table
# Drop participant have less than 100% data 

# Data contain 100% data
Progress100 <- Progress[Progress$NACheck == 0, ]

# Group by GroupAssissignment and Timepoint, and calculate the Supported_Mean and Unsupproted_Mean
Progress_Supported_Mean100 <- Progress100 %>%
  group_by(GroupAssignment,Timepoint,site) %>%
  summarise(SupportedMean100 = mean(Supported_Mean,na.rm = T), n = n())

Progress_unsupported_Mean100 <- Progress100 %>%
  group_by(GroupAssignment,Timepoint,site) %>%
  summarise(UnsupprotedMean100 = mean(Unsupproted_Mean,na.rm = T), n = n())

# Joint  Supported and un-supported 
Progress_Mean100 <- merge(Progress_Supported_Mean100, Progress_unsupported_Mean100)

# Select only UO Mean
UO100 <- Progress_Mean100[Progress_Mean100$site == "UO",]
# Select only UPMC Mean 
UPMC100 <- Progress_Mean100[Progress_Mean100$site == "UPMC",]

# Colculate Both site Mean 
Progress_Supported_Mean_both100 <- Progress100 %>%
  group_by(GroupAssignment,Timepoint) %>%
  summarise("BothSite_CCNES_SupportedMean100" = mean(Supported_Mean, na.rm = T), n = n())

# Calculate Both site Mean for unsupported elements
Progress_unsupported_Mean_both100 <- Progress100 %>%
  group_by(GroupAssignment,Timepoint) %>%
  summarise("BothSite_CCNES_UnsupprotedMean100" = mean(Unsupproted_Mean,na.rm = T), n = n())

# merge Supported and unsupported table for both site table 
Both_site_Mean100 <- merge(Progress_Supported_Mean_both100, Progress_unsupported_Mean_both100)


# Change GroupMean Column names according to site
colnames(UO100)[colnames(UO100) == "SupportedMean100"] = "UO_CCNES_SupportedMean"
colnames(UO100)[colnames(UO100) == "UnsupprotedMean100"] = "UO_CCNES_UnsupprotedMean"
colnames(UPMC100)[colnames(UPMC100) == "SupportedMean100"] = "UPMC_CCNES_SupportedMean"
colnames(UPMC100)[colnames(UPMC100) == "UnsupprotedMean100"] = "UPMC_CCNES_UnsupprotedMean"

# Combine UO,UPMC and both_site data 
Mean_Table100 <- data.frame(UO[,c("UO_CCNES_SupportedMean","UO_CCNES_UnsupprotedMean")],UPMC[,c("UPMC_CCNES_SupportedMean","UPMC_CCNES_UnsupprotedMean")],Both_site_Mean100[,c("BothSite_CCNES_SupportedMean100","BothSite_CCNES_UnsupprotedMean100","n","GroupAssignment")])

# Convert Mean_Table, make original column as row
Mean_Table100 <- t(Mean_Table100)

# Make Mean_Table as a data.frame
Mean_Table100 <- data.frame(Mean_Table100)

# Reorder Mean_Table
Mean_Table100 <- Mean_Table100[c(5,6,7,8,9,10,11,12,1,2,3,4)]

# Add Timepoint column 
Timepoint_names <- c("T1","T2", "T3", "T4","T1","T2", "T3", "T4","T1","T2", "T3", "T4")

# Rename column name 
setnames(Mean_Table100, names(Mean_Table100), Timepoint_names)

# Table output ####
# Add a header 
kable(Mean_Table100) %>%
  kable_styling(bootstrap_options = c("striped")) %>%
  add_header_above(c(" " = 1, "Controls Group means" = 4, "FSU Group means" = 4, "DBT Group means" = 4)) %>%
  add_header_above(c("CCNES Mean Table 100% Drop Rule" = 13)) %>%
  column_spec(c(1,5,9), border_right = T, include_thead = T) %>%
  column_spec(c(2,3,4,5,6,7,8,9,10,11,12,13), width_min = "2cm", width_max = "2cm")


# Ns Table ####
# Original data ####
# Original by site
N_ori <- Progress %>%
  group_by(Timepoint, site, GroupAssignment) %>% 
  summarise(n_ori = n())

# Original both site 
N_ori_BothSite <- Progress %>%
  group_by(Timepoint, GroupAssignment) %>% 
  summarise(BothSite_Original_N = n())

# 67% data ####
# 67% by site 
N67 <- Progress67 %>%
  group_by(Timepoint, site, GroupAssignment) %>% 
  summarise(n_67 = n())

# 67% both site 
N67_BothSite <- Progress67 %>%
  group_by(Timepoint, GroupAssignment) %>% 
  summarise(BothSite_67_N = n())

# 100% data ####
N100 <- Progress100 %>%
  group_by(Timepoint, site, GroupAssignment) %>% 
  summarise(n_100 = n())

# 100% both site 
N100_BothSite <- Progress100 %>%
  group_by(Timepoint, GroupAssignment) %>% 
  summarise(BothSite_100_N = n())

# N table 
# combine all three n table 
N_bySite <- merge(N_ori, N67, all = T)
N_bySite <- merge(N_bySite,N100, all = T)
# Bind both site data 
BothSite_N <- merge(N_ori_BothSite, N67_BothSite, all = T)
BothSite_N <- merge(BothSite_N, N100_BothSite, all = T)

# Seperate UO and UPMC data 
UO_N <- data.frame(N_bySite[N_bySite$site == "UO",])
UPMC_N <- data.frame(N_bySite[N_bySite$site == "UPMC",])

# Change column names 
colnames(UO_N)[colnames(UO_N) == "n_ori"] = "UO_CCNES_Original_N"
colnames(UO_N)[colnames(UO_N) == "n_67"] = "UO_CCNES_67_N"
colnames(UO_N)[colnames(UO_N) == "n_100"] = "UO_CCNES_100_N"

colnames(UPMC_N)[colnames(UPMC_N) == "n_ori"] = "UPMC_CCNES_Original_N"
colnames(UPMC_N)[colnames(UPMC_N) == "n_67"] = "UPMC_CCNES_67_N"
colnames(UPMC_N)[colnames(UPMC_N) == "n_100"] = "UPMC_CCNES_100_N"

# Create N table (Selecting columns from UO_N, UPMC_N, BothSite_N) GroupAssignment included twice here, just checking it's align
N <- data.frame(UO_N[, c("Timepoint","UO_CCNES_Original_N", "UO_CCNES_67_N", "UO_CCNES_100_N")], 
                UPMC_N[, c("UPMC_CCNES_Original_N", "UPMC_CCNES_67_N", "UPMC_CCNES_100_N", "GroupAssignment")],
                BothSite_N[, c("BothSite_Original_N", "BothSite_67_N", "BothSite_100_N", "GroupAssignment")])

# Reorder N table base on GroupAssignment 
N <- N[order(N$GroupAssignment),]

# Convert data frame to numeric
N <- as.data.frame(sapply(N, as.numeric))

# Transfer N table from Horizontal to Vertical
N <- data.frame(t(N))

# Calculate Total N 
N$T1 <- rowSums(N[,c(1,5,9)], na.rm = T)
N$T2 <- rowSums(N[,c(2,6,10)], na.rm = T)
N$T3 <- rowSums(N[,c(3,7,11)], na.rm = T)
N$T4 <- rowSums(N[,c(4,8,12)], na.rm = T)

# Timepoint names 
Timepoint_names <- c("T1","T2", "T3", "T4","T1","T2", "T3", "T4","T1","T2", "T3", "T4", "T1","T2", "T3", "T4")

# Rename column name 
setnames(N, names(N), Timepoint_names)


N <- N[-c(1,8,12),]

# N table output
kable(N) %>%
  kable_styling(bootstrap_options = c("striped"), fixed_thead = T) %>%
  add_header_above(c(" " = 1, "DBT Group" = 4, "Control Group" = 4, "FSU Group" = 4, "Totals" = 4)) %>%
  add_header_above(c("Participant Numbers" = 17)) %>%
  column_spec(c(1,5,9,13), border_right = T, include_thead = T) %>%
  column_spec(2:17, width_min = "2cm", width_max = "2cm") %>%
  row_spec(7:9, background = "#d3d3d3")



