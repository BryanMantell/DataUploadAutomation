# Load Library -----------------------------------------------------------------
#empty Global Environment
rm(list = ls())
library(dplyr)
library(data.table)

# Set the working directory 
# for Bryan
# setwd("C:/Users/bryan/Documents/GitHub/DataUploadAutomation/Measures/CCNES")
setwd("~/Documents/Min/Coding/DataUploadAutomation/Measures/CCNES")

# Import File -------------------------------------------------------------
Pedigree <- read.csv("Reference_Pedigree.csv")

UO_CCNES_T1 <- read.csv("UO_T1_Qualtrics.csv")
UO_CCNES_T2 <- read.csv("UO_T2_Qualtrics.csv")
UO_CCNES_T3 <- read.csv("UO_T3_Qualtrics.csv")
UO_CCNES_T4 <- read.csv("UO_T4_Qualtrics.csv")

UPMC_CCNES_T1 <- read.csv("UPMC_T1_CCNES.csv")
UPMC_CCNES_T2 <- read.csv("UPMC_T2_CCNES.csv")
UPMC_CCNES_T3 <- read.csv("UPMC_T3_CCNES.csv")
UPMC_CCNES_T4 <- read.csv("UPMC_T4_CCNES.csv")

#NDA Structure
NDA_CCNES <- read.csv("pabq01_template.csv", skip = 1)

# Column Names Variable  --------------------------------------------------------------------

# OLD UO CCNES Column Names
# for each item in UO paste number 1 to 6
# sprintf used to formate str
# I use for loop because My variable name are start from different number
odd_UO_CCNES_names <- c()
for (i in sprintf("Q%03d",140:151)) {
  name <- paste(i, 1:6, sep = "_")
  odd_UO_CCNES_names <- c(odd_UO_CCNES_names, name)
}

# OLD UPMC CCNES Column Names for T1 & T4
odd_UPMC_CCNES_names <- c()
for (i in sprintf("Q10.%d",2:13)) {
  Name <- paste(i, 1:6, sep = "_")
  odd_UPMC_CCNES_names <- c(odd_UPMC_CCNES_names, Name)
}
# OLD UPMC CCNES Column Names for T2 & T3
odd_UPMC_CCNES_names2 <- c()
for (i in sprintf("Q8.%d",2:13)) {
  Name <- paste(i, 1:6, sep = "_")
  odd_UPMC_CCNES_names2 <- c(odd_UPMC_CCNES_names2, Name)
}

# CCNES prep Column Names
new_CCNES_names <- sprintf("srm_ccnes_%02d",1:72)

# NDA structure Column Names
pabq <- paste("pabq",1:12, sep = "")
NDA_Names <- c()
for (i in pabq) {
  Name <- paste(i, letters[seq(1:6)], sep = "")
  NDA_Names <- c(NDA_Names, Name)
}

# Prep Sheet --------------------------------------------------------------------------------------
# Replace UO column names
setnames(UO_CCNES_T1, odd_UO_CCNES_names, new_CCNES_names)
setnames(UO_CCNES_T2, odd_UO_CCNES_names, new_CCNES_names)
setnames(UO_CCNES_T3, odd_UO_CCNES_names, new_CCNES_names)
setnames(UO_CCNES_T4, odd_UO_CCNES_names, new_CCNES_names)

# Replace UPMC column names
setnames(UPMC_CCNES_T1, odd_UPMC_CCNES_names, new_CCNES_names)
setnames(UPMC_CCNES_T2, odd_UPMC_CCNES_names2, new_CCNES_names)
setnames(UPMC_CCNES_T3, odd_UPMC_CCNES_names2, new_CCNES_names)
setnames(UPMC_CCNES_T4, odd_UPMC_CCNES_names, new_CCNES_names)

# Edit UO CCNES Time 1 - 4 to have only CCNES quesions, FamID and Timepoint. Rename as needed
UO_CCNES_T1 <- select(UO_CCNES_T1, c(FamID = Q221, Timepoint = Q146, contains("ccnes")))  
UO_CCNES_T2 <- select(UO_CCNES_T2, c(FamID = Q116, Timepoint = Q117, contains("ccnes")))
UO_CCNES_T3 <- select(UO_CCNES_T3, c(FamID = Q174, Timepoint = Q176, contains("ccnes")))
UO_CCNES_T4 <- select(UO_CCNES_T4, c(FamID = Q203, Timepoint = Q206, contains("ccnes")))

# Edit UPMC CCNES Time 1 - 4 to have only CCNES quesions and FamID. Rename as needed
UPMC_CCNES_T1 <- select(UPMC_CCNES_T1, c(FamID = Q1.2, contains("ccnes")))
UPMC_CCNES_T2 <- select(UPMC_CCNES_T2, c(FamID = Q1.2, contains("ccnes")))  
UPMC_CCNES_T3 <- select(UPMC_CCNES_T3, c(FamID = Q1.2, contains("ccnes")))  
UPMC_CCNES_T4 <- select(UPMC_CCNES_T4, c(FamID = Q1.2, contains("ccnes")))

# Create Time Point coloumn in each UPMC Sheet
UPMC_CCNES_T1$Timepoint <- 1
UPMC_CCNES_T2$Timepoint <- 2
UPMC_CCNES_T3$Timepoint <- 3
UPMC_CCNES_T4$Timepoint <- 4

# Select revelent pedigree information, rename as needed. (Include GroupAssignment for treatment progross calculation.)
Pedigree_T1 <- select(Pedigree, FamID, mother_FamID = FamID_Mother, mom_guid, mother_sex = MomGender, interview_date = Time1Date, interview_age = MomAge_T1, GroupAssignment)
Pedigree_T2 <- select(Pedigree, FamID, mother_FamID = FamID_Mother, mom_guid, mother_sex = MomGender, interview_date = Time2Date, interview_age = MomAge_T2, GroupAssignment)
Pedigree_T3 <- select(Pedigree, FamID, mother_FamID = FamID_Mother, mom_guid, mother_sex = MomGender, interview_date = Time3Date, interview_age = MomAge_T3, GroupAssignment)
Pedigree_T4 <- select(Pedigree, FamID, mother_FamID = FamID_Mother, mom_guid, mother_sex = MomGender, interview_date = Time4Date, interview_age = MomAge_T4, GroupAssignment)

# Merge Predigree and UO/UPMC files 
CCNES_T1 <- rbind(merge(Pedigree_T1, UO_CCNES_T1, by = "FamID"), merge(Pedigree_T1, UPMC_CCNES_T1, by = "FamID"))
CCNES_T2 <- rbind(merge(Pedigree_T2, UO_CCNES_T2, by = "FamID"), merge(Pedigree_T2, UPMC_CCNES_T2, by = "FamID"))
CCNES_T3 <- rbind(merge(Pedigree_T3, UO_CCNES_T3, by = "FamID"), merge(Pedigree_T3, UPMC_CCNES_T3, by = "FamID"))
CCNES_T4 <- rbind(merge(Pedigree_T4, UO_CCNES_T4, by = "FamID"), merge(Pedigree_T4, UPMC_CCNES_T4, by = "FamID"))

# Bind 4 time points
CCNES_PREP <- rbind(CCNES_T1,CCNES_T2,CCNES_T3,CCNES_T4)

# Change gemder to F instead of False
CCNES_PREP$mother_sex <- "F"

# Clean Flobal Enviorment
rm(UO_CCNES_T1, UO_CCNES_T2, UO_CCNES_T3, UO_CCNES_T4, UPMC_CCNES_T1, UPMC_CCNES_T2, UPMC_CCNES_T3, UPMC_CCNES_T4,Pedigree_T1,Pedigree_T2,Pedigree_T3,Pedigree_T4,CCNES_T1,CCNES_T2,CCNES_T3,CCNES_T4)


# Recode the strings of text to numbers -----------------------------------------------------------------------------
CCNES_PREP <- CCNES_PREP %>% 
  mutate_at(new_CCNES_names,
            funs(recode(., "1 - Very Unlikely" = 1, 
                        '1' = 1,
                        '2' = 2,
                        '3' = 3,
                        '4 - Medium Liklihood' = 4,
                        '4' = 4,
                        '5' = 5,
                        '6' = 6,
                        '7' = 7,
                        '7 - Very Likely' = 7,.default = NaN)))


# Adding r at end of variable which needed to be reversed
Reverse_CCNES_names <- new_CCNES_names
Reverse_CCNES_names[c(7,39,45,55)] <- paste(new_CCNES_names[c(7,39,45,55)],"r", sep = "")
setnames(CCNES_PREP, new_CCNES_names, Reverse_CCNES_names)

# Reversed Scored
CCNES_PREP <- CCNES_PREP %>% 
  mutate_at(c("srm_ccnes_07r", "srm_ccnes_39r", "srm_ccnes_45r", "srm_ccnes_55r"),
            funs(recode(., "1" = 7, 
                        '2' = 6,
                        '3' = 5,
                        '4' = 4,
                        '5' = 3,
                        '6' = 2,
                        '7' = 1,.default = NaN)))

# # reverse score alternative
# Reverse_CCNES_names <- new_CCNES_names
# revers_CCNES_cols <- c("srm_ccnes_07", "srm_ccnes_39", "srm_ccnes_45", "srm_ccnes_55")
# revers_CCNES_cols <- paste(revers_CCNES_cols, "r", sep = "")
# Reverse_CCNES_names[c(7,39,45,55)] <- revers_CCNES_cols
# setnames(CCNES_PREP, new_CCNES_names, Reverse_CCNES_names)
# CCNES_PREP[,revers_CCNES_cols] = 8 - CCNES_PREP[,revers_CCNES_cols]


# Calculation  ------------------------------------------------------------

# Calculated Columns
CCNES_PREP$ccnes_DR_raw <- rowMeans(CCNES_PREP[,c("srm_ccnes_02", "srm_ccnes_07r", "srm_ccnes_13", 
                                              "srm_ccnes_22", "srm_ccnes_29", "srm_ccnes_33", 
                                              "srm_ccnes_39r", "srm_ccnes_45r", "srm_ccnes_50", 
                                              "srm_ccnes_55r", "srm_ccnes_62", "srm_ccnes_70")], na.rm = TRUE)
# countNA <- rowSums(!is.na(CCNES_PREP))
# rowSums(is.na(dat))
# ccnes_DR_cor <- 

CCNES_PREP$ccnes_PR <- rowMeans(CCNES_PREP[,c("srm_ccnes_01", "srm_ccnes_12", "srm_ccnes_18", 
                                              "srm_ccnes_19", "srm_ccnes_28", "srm_ccnes_34", 
                                              "srm_ccnes_41", "srm_ccnes_47", "srm_ccnes_53", 
                                              "srm_ccnes_56", "srm_ccnes_63", "srm_ccnes_71")], na.rm = TRUE)

CCNES_PREP$ccnes_EE <- rowMeans(CCNES_PREP[,c("srm_ccnes_05", "srm_ccnes_11", "srm_ccnes_17", 
                                              "srm_ccnes_20", "srm_ccnes_30", "srm_ccnes_35", 
                                              "srm_ccnes_42", "srm_ccnes_43", "srm_ccnes_49", 
                                              "srm_ccnes_57", "srm_ccnes_66", "srm_ccnes_68")], na.rm = TRUE)

CCNES_PREP$ccnes_EFR <- rowMeans(CCNES_PREP[,c("srm_ccnes_06", "srm_ccnes_08", "srm_ccnes_16", 
                                               "srm_ccnes_23", "srm_ccnes_25", "srm_ccnes_31", 
                                               "srm_ccnes_38", "srm_ccnes_48", "srm_ccnes_54",
                                               "srm_ccnes_58", "srm_ccnes_65", "srm_ccnes_69")], na.rm = TRUE)

CCNES_PREP$ccnes_PFR <- rowMeans(CCNES_PREP[,c("srm_ccnes_03", "srm_ccnes_10", "srm_ccnes_15", 
                                               "srm_ccnes_24", "srm_ccnes_26", "srm_ccnes_36", 
                                               "srm_ccnes_37", "srm_ccnes_44", "srm_ccnes_52",
                                               "srm_ccnes_59", "srm_ccnes_64", "srm_ccnes_67")], na.rm = TRUE)
CCNES_PREP$ccnes_MR <- rowMeans(CCNES_PREP[,c("srm_ccnes_04", "srm_ccnes_09", "srm_ccnes_14", 
                                              "srm_ccnes_21", "srm_ccnes_27", "srm_ccnes_32", 
                                              "srm_ccnes_40", "srm_ccnes_46", "srm_ccnes_51", 
                                              "srm_ccnes_60", "srm_ccnes_61", "srm_ccnes_72")], na.rm = TRUE)

# NDA Sheet ----------------------------------------------------------------------------
# Create NDA prep sheet, select all the needed columns from prep sheet
NDA_CCNES_Prep <- select(CCNES_PREP, c(subjectkey = mom_guid, src_subject_id = mother_FamID, sex = mother_sex ,interview_age, interview_date, starts_with("srm")))
                         
# Combine NDA and prep sheet
# Make sure put original NDA structure at first, because the order of the new sheet will be the order of the first item in bind_rows function
setnames(NDA_CCNES_Prep, Reverse_CCNES_names, NDA_Names)

# Recreate first line in orignial NDA file
# Make a empty row, with same number of column in NDA_CCNES, as first line of NDA sheet
# ncol(NDA_CCNES)  is number of columns in NDA_CCNES
NDA_CCNES <- bind_rows(NDA_CCNES,NDA_CCNES_Prep)

# Recreate first line in orignial NDA file
# Make a empty row, with same number of column in NDA_CCNES, as first line of NDA sheet
# ncol(NDA_CCNES)  is number of columns in NDA_CCNES
first_line <- matrix("", nrow = 1, ncol = ncol(NDA_CCNES))
# assign the firt cell in first_line as pabq which is the first cell in orignial NDA structure
first_line[,1] <- "pabq"
# assign the second cell in first_lineas pabq
first_line[,2] <- "1"


# Create a new file in folder called pabq.csv, and put first line into this file
# pabq.csb file will be saved into same folder as current r script
write.table(first_line, file = "pabq.csv", sep = ",", append = FALSE, quote = FALSE, na = "", col.names = FALSE, row.names = FALSE)

# Append data in NDA_CCNES into pabq.cav file 
write.table(NDA_CCNES, file = 'pabq.csv', sep = ",", append = TRUE, na = "", quote = FALSE, row.names = FALSE)





















