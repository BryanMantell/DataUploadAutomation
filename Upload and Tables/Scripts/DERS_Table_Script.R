# title: "CCNES Mean Table"
# author: "Min Zhang"

# All responsees Table 
#Mean Table with all data (no drop)

# Select needed column
Progress <- select(Qualtrics, c(Fam_ID, GroupAssignment, Timepoint, starts_with("srm"), Row_sum = DERS_total_raw, NACheck))

# Change Fam_ID as character and assign to ID variable 
ID <- c(as.character(Progress$Fam_ID))

# Add Site column to Progress, if ID start with 9 then site is UO, else is UPMC
Progress$site <- ifelse(startsWith(ID, "9"),"UO","UPMC")


# Group by GroupAssignment and Timepoint, and calculate the Group Mean
Progress_Mean <- Progress %>%
  group_by(GroupAssignment,Timepoint,site) %>%
  summarise(GroupMean = mean(Row_sum,na.rm = T), N_Ori = n())

# Calculate Both site Mean 
Both_site_Mean <- Progress %>%
  group_by(GroupAssignment, Timepoint) %>%
  summarise(BothSite_DERS_Mean = mean(Row_sum,na.rm = T), BothSite_Original_N = n())

# Select only UO Mean
UO <- Progress_Mean[Progress_Mean$site == "UO",]
# Select only UPMC Mean 
UPMC <- Progress_Mean[Progress_Mean$site == "UPMC",]

# Change GroupMean Column names according to site
colnames(UO)[colnames(UO) == "GroupMean"] = "UO_DERS"
colnames(UO)[colnames(UO) == "N_Ori"] = "UO_DERS_Original_N"
colnames(UPMC)[colnames(UPMC) == "GroupMean"] = "UPMC_DERS"
colnames(UPMC)[colnames(UPMC) == "N_Ori"] = "UPMC_DERS_Original_N"

# Combine UO,UPMC and both_site data 
Mean_Table <- data.frame(UO[,c("UO_DERS")],UPMC[,"UPMC_DERS"],Both_site_Mean[,c("BothSite_DERS_Mean", "BothSite_Original_N", "GroupAssignment")])

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

# Table output ####
# Add a header 
kable(Mean_Table) %>%
  kable_styling(bootstrap_options = c("striped")) %>%
  add_header_above(c(" " = 1, "Controls Group means" = 4, "FSU Group means" = 4, "DBT Group means" = 4)) %>%
  add_header_above(c("DERS Mean Table (All Data)" = 13)) %>%
  column_spec(c(1,5,9), border_right = T, include_thead = T) %>%
  column_spec(c(2,3,4,5,6,7,8,9,10,11,12,13), width_min = "2cm", width_max = "2cm")


# 67% Responses Table
# Drop participant have less than 67% data 

# Drop people who are less than 67% 
DERS_Drop <- Progress[Progress$NACheck > 0.67, ]
Progress67 <- Progress[Progress$NACheck <= 0.67, ]

# Group by GroupAssignment and Timepoint, and calculate the Group Mean
Progress_Mean_67 <- Progress67 %>%
  group_by(GroupAssignment,Timepoint,site) %>%
  summarise(GroupMean = mean(Row_sum,na.rm = T), N_67 = n())

# Calculate Both site Mean 
Both_site_Mean_67 <- Progress67 %>%
  group_by(GroupAssignment, Timepoint) %>%
  summarise(BothSite_DERS_Mean67 = mean(Row_sum,na.rm = T), BothSite_DERS_67_N = n())

# Select only UO Mean
UO67 <- Progress_Mean_67[Progress_Mean_67$site == "UO",]
# Select only UPMC Mean 
UPMC67 <- Progress_Mean_67[Progress_Mean_67$site == "UPMC",]

# Change GroupMean Column names according to site
colnames(UO67)[colnames(UO67) == "GroupMean"] = "UO_DERS67"
colnames(UO67)[colnames(UO67) == "N_67"] = "UO_DERS_67_N"
colnames(UPMC67)[colnames(UPMC67) == "GroupMean"] = "UPMC_DERS67"
colnames(UPMC67)[colnames(UPMC67) == "N_67"] = "UPMC_DERS_67_N"

# Combine UO,UPMC and both_site data 
Mean_Table67 <- data.frame(UO67[,c("UO_DERS67")],UPMC67[,"UPMC_DERS67"],Both_site_Mean_67[,c("BothSite_DERS_Mean67","BothSite_DERS_67_N", "GroupAssignment")])

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

# Table output ####
# Add a header 
kable(Mean_Table67) %>%
  kable_styling(bootstrap_options = c("striped")) %>%
  add_header_above(c(" " = 1, "Controls Group means" = 4, "FSU Group means" = 4, "DBT Group means" = 4)) %>%
  add_header_above(c("DERS Mean Table" = 13)) %>%
  column_spec(c(1,5,9), border_right = T, include_thead = T) %>%
  column_spec(c(2,3,4,5,6,7,8,9,10,11,12,13), width_min = "2cm", width_max = "2cm")


# 100% Responses Table
#Drop participant have less than 100% data 

# Data contain 100% data
Progress100 <- Progress[Progress$NACheck == 0, ]
# Group by GroupAssignment and Timepoint, and calculate the Group Mean
Progress_Mean_100 <- Progress100 %>%
  group_by(GroupAssignment,Timepoint,site) %>%
  summarise(GroupMean = mean(Row_sum,na.rm = T), N_100 = n())

# Calculate Both site Mean 
Both_site_Mean_100 <- Progress100 %>%
  group_by(GroupAssignment, Timepoint) %>%
  summarise(BothSite_DERS_Mean100 = mean(Row_sum,na.rm = T), BothSite_DERS_100_N = n())

# Select only UO Mean
UO100 <- Progress_Mean_100[Progress_Mean_100$site == "UO",]
# Select only UPMC Mean 
UPMC100 <- Progress_Mean_100[Progress_Mean_100$site == "UPMC",]

# Change GroupMean Column names according to site
colnames(UO100)[colnames(UO100) == "GroupMean"] = "UO_DERS100"
colnames(UO100)[colnames(UO100) == "N_100"] = "UO_DERS_100_N"
colnames(UPMC100)[colnames(UPMC100) == "GroupMean"] = "UPMC_DERS100"
colnames(UPMC100)[colnames(UPMC100) == "N_100"] = "UPMC_DERS_100_N"

# Combine UO,UPMC and both_site data 
Mean_Table100 <- data.frame(UO100[,c("UO_DERS100")],UPMC100[,"UPMC_DERS100"],Both_site_Mean_100[,c("BothSite_DERS_Mean100","BothSite_DERS_100_N", "GroupAssignment")])

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
  add_header_above(c("DERS Mean Table" = 13)) %>%
  column_spec(c(1,5,9), border_right = T, include_thead = T) %>%
  column_spec(c(2,3,4,5,6,7,8,9,10,11,12,13), width_min = "2cm", width_max = "2cm")


# Ns Table
# Create N table, GroupAssignment and Timepoint are dupliced here, just checking it's align
N <- data.frame(UO[, c("Timepoint", "UO_DERS_Original_N", "GroupAssignment")],
                UO67[, c("Timepoint", "UO_DERS_67_N", "GroupAssignment")],
                UO100[, c("Timepoint", "UO_DERS_100_N", "GroupAssignment")],
                UPMC[, c("Timepoint", "UPMC_DERS_Original_N", "GroupAssignment")],
                UPMC67[, c("Timepoint", "UPMC_DERS_67_N", "GroupAssignment")],
                UPMC100[, c("Timepoint", "UPMC_DERS_100_N", "GroupAssignment")],
                Both_site_Mean[,c("Timepoint", "BothSite_Original_N", "GroupAssignment")],
                Both_site_Mean_67[,c("Timepoint", "BothSite_DERS_67_N", "GroupAssignment")],
                Both_site_Mean_100[,c("Timepoint", "BothSite_DERS_100_N", "GroupAssignment")]
)
# Remove dupliced column 
N <- N[,-c(1,3,4,6,7,9,10,12,13,15,16,18,19,21,22,24,25,27)]

# Convert data frame to numeric
N <- as.data.frame(sapply(N, as.numeric))

# Transfer N table from Horzontal to Vertical
N <- data.frame(t(N))

# Calculate Total N 
N$T1 <- rowSums(N[,c(1,5,9)])
N$T2 <- rowSums(N[,c(2,6,10)])
N$T3 <- rowSums(N[,c(3,7,11)])
N$T4 <- rowSums(N[,c(4,8,12)])

# Timepoint names 
Timepoint_names <- c("T1","T2", "T3", "T4","T1","T2", "T3", "T4","T1","T2", "T3", "T4", "T1","T2", "T3", "T4")

# Rename column name 
setnames(N, names(N), Timepoint_names)

# Create N table 
kable(N) %>%
  kable_styling(bootstrap_options = c("striped"), fixed_thead = T) %>%
  add_header_above(c(" " = 1, "DBT Group" = 4, "Control Group" = 4, "FSU Group" = 4, "Totals" = 4)) %>%
  add_header_above(c("Participant Numbers" = 17)) %>%
  column_spec(c(1,5,9,13), border_right = T, include_thead = T) %>%
  column_spec(2:17, width_min = "2cm", width_max = "2cm") %>%
  row_spec(7:9, background = "#d3d3d3")


