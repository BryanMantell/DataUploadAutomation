#Establish 67% Table dataframe and import relevant data
Progress67 <- select(EL_PREP67, c(Fam_ID, GroupAssignment, timepoint, starts_with("oc_elt_")))

EL_PREP67[, c(10,12,14,16:23)] <- sapply(EL_PREP67[, c(10,12,14,16:23)] ,as.numeric)

# Calculate row mean for each individual  
#Progress67$Row_Mean <- rowMeans(select(EL_PREP67,c(starts_with("oc_elt"))), na.rm = T)

Progress67$Row_Mean <- rowMeans(select(EL_PREP67, c(10,12,14,16:23)))

# Change FamId as character and assign to ID variable 
ID <- c(as.character(Progress67$Fam_ID))

# Add Site column to Progress, if ID start with 9 then site is UO, else is UPMC
Progress67$site <- ifelse(startsWith(ID, "9"),"UO","UPMC")

# Group by GroupAssissignment and Timepoint, and calculate the Group Mean
Progress_Mean <- Progress67 %>%
  group_by(GroupAssignment,timepoint,site) %>%
  summarise(GroupMean = mean(Row_Mean,na.rm = T),count = n())

# Select only UO Mean
UO <- Progress_Mean[Progress_Mean$site == "UO",]
# Select only UPMC Mean 
UPMC <- Progress_Mean[Progress_Mean$site == "UPMC",]

# Calculate Both site Mean 
Both_site_Mean <- Progress67 %>%
  group_by(GroupAssignment, timepoint) %>%
  summarise(BothSite_EmotionalLabeling_Mean = mean(Row_Mean,na.rm = T),n = n())

# Change GroupMean Column names according to site
colnames(UO)[colnames(UO) == "GroupMean"] = "UO_EmotionalLabeling"
colnames(UPMC)[colnames(UPMC) == "GroupMean"] = "UPMC_EmotionalLabeling"

# Combine UO,UPMC and both_site data 
Mean_Table67 <- data.frame(UO[,c("UO_EmotionalLabeling")],UPMC[,"UPMC_EmotionalLabeling"],Both_site_Mean[,c("BothSite_EmotionalLabeling_Mean","n","GroupAssignment")])

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

# Table output ----------
# Add a header 
kable(Mean_Table) %>%
  kable_styling(bootstrap_options = "striped", full_width = F) %>%
  add_header_above(c(" " = 1, "Controls Group means" = 4, "FSU Group means" = 4, "DBT Group means" = 4)) %>%
  add_header_above(c("Emotion Labeling Mean Table 67%" = 13)) %>%
  column_spec(c(1,5,9), border_right = T, include_thead = T) %>%
  column_spec(c(2,3,4,5,6,7,8,9,10,11,12,13), width_min = "2cm", width_max = "2cm")
```




Progress100 <- select(EL_PREP100, c(Fam_ID, GroupAssignment, timepoint, starts_with("oc_elt_")))

EL_PREP100[, c(10,12,14,16:23)] <- sapply(EL_PREP100[, c(10,12,14,16:23)],as.numeric)

# Calculate row mean for each individual  
Progress100$Row_Mean <- rowMeans(select(EL_PREP100, c(10,12,14,16:23)))

# Change FamId as character and assign to ID variable 
ID <- c(as.character(Progress100$Fam_ID))

# Add Site column to Progress, if ID start with 9 then site is UO, else is UPMC
Progress100$site <- ifelse(startsWith(ID, "9"),"UO","UPMC")

# Group by GroupAssissignment and Timepoint, and calculate the Group Mean
Progress_Mean <- Progress100 %>%
  group_by(GroupAssignment,timepoint,site) %>%
  summarise(GroupMean = mean(Row_Mean,na.rm = T),count = n())

# Select only UO Mean
UO <- Progress_Mean[Progress_Mean$site == "UO",]
# Select only UPMC Mean 
UPMC <- Progress_Mean[Progress_Mean$site == "UPMC",]

# Calculate Both site Mean 
Both_site_Mean <- Progress100 %>%
  group_by(GroupAssignment, timepoint) %>%
  summarise(BothSite_EmotionalLabeling_Mean = mean(Row_Mean,na.rm = T),n = n())

# Change GroupMean Column names according to site
colnames(UO)[colnames(UO) == "GroupMean"] = "UO_EmotionalLabeling"
colnames(UPMC)[colnames(UPMC) == "GroupMean"] = "UPMC_EmotionalLabeling"

# Combine UO,UPMC and both_site data 
Mean_Table100 <- data.frame(UO[,c("UO_EmotionalLabeling")],UPMC[,"UPMC_EmotionalLabeling"],Both_site_Mean[,c("BothSite_EmotionalLabeling_Mean","n","GroupAssignment")])

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

# Table output ----------
# Add a header 
kable(Mean_Table) %>%
  kable_styling(bootstrap_options = "striped", full_width = F) %>%
  add_header_above(c(" " = 1, "Controls Group means" = 4, "FSU Group means" = 4, "DBT Group means" = 4)) %>%
  add_header_above(c("Emotion Labeling Mean Table 100%" = 13)) %>%
  column_spec(c(1,5,9), border_right = T, include_thead = T) %>%
  column_spec(c(2,3,4,5,6,7,8,9,10,11,12,13), width_min = "2cm", width_max = "2cm")



# Original Table ####
# Original by site
N_ori <- Progress_Mean %>%
  group_by(timepoint, site, GroupAssignment) %>% 
  summarise(n_ori = n())

# Original both site 
N_ori_BothSite <-  %>%
  group_by(timepoint, GroupAssignment) %>% 
  summarise(BothSite_Original_N = n())


# 67% table ####
# 67% by site 
N67 <- Progress67 %>%
  group_by(timepoint, site, GroupAssignment) %>% 
  summarise(n_67 = n())

# 67% both site 
N67_BothSite <- Progress67 %>%
  group_by(timepoint, GroupAssignment) %>% 
  summarise(BothSite_67_N = n())

# 100% table ####
N100 <- Progress100 %>%
  group_by(timepoint, site, GroupAssignment) %>% 
  summarise(n_100 = n())

# 100% both site 
N100_BothSite <- Progress100 %>%
  group_by(timepoint, GroupAssignment) %>% 
  summarise(BothSite_100_N = n())

# N table ####

# combine all three n table 
N_bySite <- cbind(N_ori, N67, N100)
# Bind both site data 
BothSite_N <- cbind(N_ori_BothSite, N67_BothSite, N100_BothSite)


# Seperate UO and UPMC data 
UO_N <- data.frame(N_bySite[N_bySite$site == "UO",])
UPMC_N <- data.frame(N_bySite[N_bySite$site == "UPMC",])

# Change column names 
colnames(UO_N)[colnames(UO_N) == "n_ori"] = "UO_EL_Original_N"
colnames(UO_N)[colnames(UO_N) == "n_67"] = "UO_EL_67_N"
colnames(UO_N)[colnames(UO_N) == "n_100"] = "UO_EL_100_N"

colnames(UPMC_N)[colnames(UPMC_N) == "n_ori"] = "UPMC_EL_Original_N"
colnames(UPMC_N)[colnames(UPMC_N) == "n_67"] = "UPMC_EL_67_N"
colnames(UPMC_N)[colnames(UPMC_N) == "n_100"] = "UPMC_EL_100_N"

# Create N table (Selecting columns from UO_N, UPMC_N, BothSite_N)
N <- data.frame(UO_N[, c("timepoint","UO_EL_Original_N", "UO_EL_67_N", "UO_EL_100_N")], 
                UPMC_N[, c("UPMC_EL_Original_N", "UPMC_EL_67_N", "UPMC_EL_100_N", "GroupAssignment")],
                BothSite_N[, c("BothSite_Original_N", "BothSite_67_N", "BothSite_100_N", "GroupAssignment")])

# Reorder N table base on GroupAssignment 
N <- N[order(N$GroupAssignment),]

# Convert data frame to numeric
N <- as.data.frame(sapply(N, as.numeric))

# Transfer N table from Horzontal to Vertical
N <- data.frame(t(N))

# Colculate Total N 
N$T1 <- rowSums(N[,c(1,5,9)])
N$T2 <- rowSums(N[,c(2,6,10)])
N$T3 <- rowSums(N[,c(3,7,11)])
N$T4 <- rowSums(N[,c(4,8,12)])

# Timepoint names 
Timepoint_names <- c("T1","T2", "T3", "T4","T1","T2", "T3", "T4","T1","T2", "T3", "T4", "T1","T2", "T3", "T4")

# Rename column name 
setnames(N, names(N), Timepoint_names)

N <- N[-c(1,8,12),]


# Remove un-needed lines in table
# N <- N[-c(1,2,3),]

# Total number colculation 


kable(N) %>%
  kable_styling(bootstrap_options = c("striped"), fixed_thead = T) %>%
  add_header_above(c(" " = 1, "DBT Group" = 4, "Control Group" = 4, "FSU Group" = 4, "Totals" = 4)) %>%
  add_header_above(c("Participant Numbers" = 17)) %>%
  column_spec(c(1,5,9,13), border_right = T, include_thead = T) %>%
  column_spec(2:17, width_min = "2cm", width_max = "2cm") %>%
  row_spec(7:9, background = "#d3d3d3")