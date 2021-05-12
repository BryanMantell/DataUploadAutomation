# title: "PKBS Table Script"
# author:  Jacob Mulleavey

# Empty Global Environment
#rm(list = ls())

# Scientific Notation
options(digits = 3)

# Install Package, this only need to be done once.
#install.packages("rlang")
#install.packages("dplyr")
#install.packages(c("tidyverse","data.table","contrib.url","knitr"))
#install.packages('plyr', repos = "http://cran.us.r-project.org")
#install.packages("lmSupport")
#install.packages("magrittr")
#install.packages("kableExtra")


# Load packages, this need to be done every time you run this script. 
library(dplyr)
library(tidyverse)
library(data.table)
library(knitr)
library(lmSupport)
library(magrittr)
library(kableExtra)

# Source data, templates and create NDA dataframe
source("~/Documents/GitHub/DataUploadAutomation/DataUploadAutomation/Upload and Tables/Scripts/PKBS_Upload_Script.R")


# PKBS Means Table (67%)
#----------------------------------------------------------------------------------------------------------------------------------------
# Select necessary columns for means table
Progress <- select((PKBS_Prep), c(FamID, GroupAssignment, Timepoint, starts_with("srm"), pkbs_total))

# Calculate row mean for each individual
Progress$Row_Mean <- rowMeans(select(PKBS_Prep, c(starts_with("srm"))), na.rm = T)

# Change FamID as character and assign to ID variable
ID <- c(as.character(Progress$FamID))

# Add Site column to Progress, if ID start with 9 then site is UO, else is UPMC
Progress$site <- ifelse(startsWith(ID, "9"), "UO", "UPMC")

# Group by GroupAssignment and Timepoint, and calcultae Group Mean
Progress_Mean <- Progress %>%
  group_by(GroupAssignment, Timepoint, site) %>%
  summarise(GroupMean = mean(pkbs_total, na.rm = T), count = n())

# Select only UO Mean
UO <- Progress_Mean[Progress_Mean$site == "UO",]
# Select only UPMC Mean
UPMC <- Progress_Mean[Progress_Mean$site == "UPMC",]

# Calculate mean from both sites
Both_site_Mean <- Progress %>%
  group_by(GroupAssignment, Timepoint) %>%
  summarise(BothSiteMean_PKBS = mean(pkbs_total, na.rm = T), n = sum(count = n()))

# Change GroupMean column names according to site
colnames(UO)[colnames(UO) == "GroupMean"] = "UO_PKBS"
colnames(UO)[colnames(UO) == "count"] = "UO_PKBS_Original_N"
colnames(UPMC)[colnames(UPMC) == "GroupMean"] = "UPMC_PKBS"
colnames(UPMC)[colnames(UPMC) == "count"] = "UPMC_PKBS_Original_N"
colnames(Both_site_Mean)[colnames(Both_site_Mean) == "n"] = "BothSite_Original_N"

# Combine UO, UPMC, and Both_Site data 
Mean_Table <- data.frame(UO[,c("UO_PKBS","GroupAssignment")],UPMC[,"UPMC_PKBS"],Both_site_Mean[,c("BothSiteMean_PKBS","BothSite_Original_N")])

# Convert Mean_Table, make original column as row
Mean_Table <- t(Mean_Table)

# Make Mean_Table a data frame
Mean_Table <- data.frame(Mean_Table)

# Re-order Mean Table
Mean_Table <- Mean_Table[c(5,6,7,8,9,10,11,12,1,2,3,4)]

# Add Timepoint column
Timepoint_names <- c("T1","T2", "T3", "T4","T1","T2", "T3", "T4","T1","T2", "T3", "T4")

# Rename column name
setnames(Mean_Table, names(Mean_Table), Timepoint_names)

# Create Table
kable(Mean_Table) %>%
  kable_styling(bootstrap_options = "striped", full_width = F) %>%
  add_header_above(c(" " = 1, "Controls means" = 4, "FSU means" = 4, "DBT means" = 4)) %>%
  add_header_above(c("PKBS Table Means (67%)" = 13)) %>%
  column_spec(c(1,5,9), border_right = T, include_thead = F) %>%
  column_spec(c(2,3,4,5,6,7,8,9,10,11,12,13), width_min = "2cm", width_max = "2cm")
#----------------------------------------------------------------------------------------------------------------------------------------

# PKBS Means Table (100%)
#----------------------------------------------------------------------------------------------------------------------------------------
# Select necessary columns for means table
Progress <- select((PKBS_100), c(FamID, GroupAssignment, Timepoint, starts_with("srm"), pkbs_total))

# Calculate row mean for each individual
Progress$Row_Mean <- rowMeans(select(PKBS_Prep, c(starts_with("srm"))), na.rm = T)

# Change FamID as character and assign to ID variable
ID <- c(as.character(Progress$FamID))

# Add Site column to Progress, if ID start with 9 then site is UO, else is UPMC
Progress$site <- ifelse(startsWith(ID, "9"), "UO", "UPMC")

# Group by GroupAssignment and Timepoint, and calculate Group Mean
Progress_Mean <- Progress %>%
  group_by(GroupAssignment, Timepoint, site) %>%
  summarise(GroupMean = mean(pkbs_total, na.rm = T), count = n())

# Select only UO Mean
UO100 <- Progress_Mean[Progress_Mean$site == "UO",]
# Select only UPMC Mean
UPMC100 <- Progress_Mean[Progress_Mean$site == "UPMC",]

# Calculate mean from both sites
Both_site_Mean100 <- Progress %>%
  group_by(GroupAssignment, Timepoint) %>%
  summarise(BothSiteMean_PKBS = mean(pkbs_total, na.rm = T), n = sum(count = n()))

# Change GroupMean column names according to site
colnames(UO100)[colnames(UO100) == "GroupMean"] = "UO_PKBS"
colnames(UO100)[colnames(UO100) == "count"] = "UO_PKBS_100_N"
colnames(UPMC100)[colnames(UPMC100) == "GroupMean"] = "UPMC_PKBS"
colnames(UPMC100)[colnames(UPMC100) == "count"] = "UPMC_PKBS_100_N"
colnames(Both_site_Mean100)[colnames(Both_site_Mean100) == "n"] = "BothSite_PKBS_100_N"

# Combine UO, UPMC, and Both_Site data 
Mean_Table <- data.frame(UO100[,c("UO_PKBS","GroupAssignment")],UPMC100[,"UPMC_PKBS"],Both_site_Mean100[,c("BothSiteMean_PKBS","BothSite_PKBS_100_N")])

# Convert Mean_Table, make original column as row
Mean_Table <- t(Mean_Table)

# Make Mean_Table a data frame
Mean_Table <- data.frame(Mean_Table)

# Re-order Mean Table
Mean_Table <- Mean_Table[c(5,6,7,8,9,10,11,12,1,2,3,4)]

# Add Timepoint column
Timepoint_names <- c("T1","T2", "T3", "T4","T1","T2", "T3", "T4","T1","T2", "T3", "T4")

# Rename column name
setnames(Mean_Table, names(Mean_Table), Timepoint_names)

# Add a header
install.packages(knitr)

# Create Table
kable(Mean_Table) %>%
  kable_styling(bootstrap_options = "striped", full_width = F) %>%
  add_header_above(c(" " = 1, "Controls means" = 4, "FSU means" = 4, "DBT means" = 4)) %>%
  add_header_above(c("PKBS Table Means (100%)" = 13)) %>%
  column_spec(c(1,5,9), border_right = T, include_thead = F) %>%
  column_spec(c(2,3,4,5,6,7,8,9,10,11,12,13), width_min = "2cm", width_max = "2cm")
#----------------------------------------------------------------------------------------------------------------------------------------

# PKBS Ns Table
#----------------------------------------------------------------------------------------------------------------------------------------
# Create N table, GroupAssignment and Timepoint are dupliced here, just checking it's align

N <- data.frame(UO[, c("Timepoint", "UO_PKBS_Original_N", "GroupAssignment")],
                UO100[, c("Timepoint", "UO_PKBS_100_N", "GroupAssignment")],
                UPMC[, c("Timepoint", "UPMC_PKBS_Original_N", "GroupAssignment")],
                UPMC100[, c("Timepoint", "UPMC_PKBS_100_N", "GroupAssignment")],
                Both_site_Mean[,c("Timepoint", "BothSite_Original_N", "GroupAssignment")],
                Both_site_Mean100[,c("Timepoint", "BothSite_PKBS_100_N", "GroupAssignment")]
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

# Create Table
kable(N) %>%
  kable_styling(bootstrap_options = c("striped"), fixed_thead = T) %>%
  add_header_above(c(" " = 1, "DBT Group" = 4, "Control Group" = 4, "FSU Group" = 4, "Totals" = 4)) %>%
  add_header_above(c("Participant Numbers" = 17)) %>%
  column_spec(c(1,5,9,13), border_right = T, include_thead = F) %>%
  column_spec(1:16, width_min = "2cm", width_max = "5cm") %>%
  row_spec(1:6, background = "#d3d3d3")
#----------------------------------------------------------------------------------------------------------------------------------------





