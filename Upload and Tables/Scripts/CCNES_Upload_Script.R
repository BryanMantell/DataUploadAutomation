# title: "CCNES NDA Upload"
# author: "Min Zhang"
# date: "5/16/2020"

# Setup ####
# Empty environment, loading library, set knitr and scientific notation
#setwd("~/GitHub/DataUploadAutomation/Upload and Tables/Data")
NDA_CCNES <- read.csv("pabq01_template.csv", skip = 1)
#setwd("~/Documents/Min/DataUploadAutomation/Upload and Tables/Output for NDA")


CCNES_Prep <- select(Qualtrics, c(Fam_ID, child_guid, child_famID, interview_date, interview_age_child, child_sex, GroupAssignment, Timepoint = Timepoint, contains("srm_ccnes")))
# Recode and Reverse-Score ####
# Re-code the strings of text to numbers 
CCNES_Prep <- CCNES_Prep %>% 
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
setnames(CCNES_Prep, new_CCNES_names, Reverse_CCNES_names)

# Reversed Scored
CCNES_Prep <- CCNES_Prep %>% 
  mutate_at(c("srm_CCNES_07r", "srm_CCNES_39r", "srm_CCNES_45r", "srm_CCNES_55r"),
            funs(recode(., "1" = 7, 
                        '2' = 6,
                        '3' = 5,
                        '4' = 4,
                        '5' = 3,
                        '6' = 2,
                        '7' = 1, defaut = NaN)))

# Recode Group Assignment
CCNES_Prep <- CCNES_Prep %>% 
  mutate_at(c("GroupAssignment"),
            funs(recode(., "Assigned Group 3 (HC)" = "Healthy", 
                        'Assigned Group 2 (FSU)' = "NO DBT",
                        'Assigned Group 1 (DBT)' = "DBT")))


# Calculated Columns ####
# Check NA percentage   0:100%data     1 0% data 
#CCNES_Prep$NACheck <- rowSums(is.na(select(CCNES_Prep, starts_with("srm"))))/ncol(dplyr::select(CCNES_Prep, starts_with("srm")))

# Calculating column with 80% imputation (varScore)
CCNES_Prep <- add_column(CCNES_Prep, CCNES_DR_imputation = varScore(CCNES_Prep, Forward = c("srm_CCNES_02", 
                                                                                            "srm_CCNES_07r", "srm_CCNES_13",  "srm_CCNES_22", 
                                                                                            "srm_CCNES_29", "srm_CCNES_33", "srm_CCNES_39r", 
                                                                                            "srm_CCNES_45r", "srm_CCNES_50", "srm_CCNES_55r", 
                                                                                            "srm_CCNES_62", "srm_CCNES_70"), MaxMiss = .20),.after = "srm_CCNES_72")

# Calculating ccnes_pr
CCNES_Prep <- add_column(CCNES_Prep, CCNES_PR_imputation = varScore(CCNES_Prep, Forward = c("srm_CCNES_01",
                                                                                            "srm_CCNES_12", "srm_CCNES_18", "srm_CCNES_19", 
                                                                                            "srm_CCNES_28", "srm_CCNES_34", "srm_CCNES_41", 
                                                                                            "srm_CCNES_47", "srm_CCNES_53", "srm_CCNES_56", 
                                                                                            "srm_CCNES_63", "srm_CCNES_71"), MaxMiss = .20),.after = "CCNES_DR_imputation")
# Calculating ccnes_ee
CCNES_Prep <- add_column(CCNES_Prep, CCNES_EE_imputation = varScore(CCNES_Prep, Forward = c("srm_CCNES_05", 
                                                                                            "srm_CCNES_11", "srm_CCNES_17", "srm_CCNES_20", 
                                                                                            "srm_CCNES_30", "srm_CCNES_35", "srm_CCNES_42", 
                                                                                            "srm_CCNES_43", "srm_CCNES_49", "srm_CCNES_57", 
                                                                                            "srm_CCNES_66", "srm_CCNES_68"), MaxMiss = .20),.after = "CCNES_PR_imputation")
# Calculating ccnes_efr
CCNES_Prep <- add_column(CCNES_Prep, CCNES_EFR_imputation = varScore(CCNES_Prep, Forward = C("srm_CCNES_06", 
                                                                                             "srm_CCNES_08", "srm_CCNES_16", "srm_CCNES_23", 
                                                                                             "srm_CCNES_25", "srm_CCNES_31", "srm_CCNES_38", 
                                                                                             "srm_CCNES_48", "srm_CCNES_54", "srm_CCNES_58", 
                                                                                             "srm_CCNES_65", "srm_CCNES_69"), MaxMiss = .20),.after = "CCNES_EFR_imputation")
# Calculating ccnes_pfr
CCNES_Prep <- add_column(CCNES_Prep, CCNES_PFR_imputation = varScore(CCNES_Prep, Forward = c("srm_CCNES_03", 
                                                                                             "srm_CCNES_10", "srm_CCNES_15", "srm_CCNES_24", 
                                                                                             "srm_CCNES_26", "srm_CCNES_36", "srm_CCNES_37", 
                                                                                             "srm_CCNES_44", "srm_CCNES_52", "srm_CCNES_59", 
                                                                                             "srm_CCNES_64", "srm_CCNES_67"), MaxMiss = .20),.after = "CCNES_PFR_imputation")
# Calculating ccnes_mr
CCNES_Prep <- add_column(CCNES_Prep, CCNES_MR_imputation = varScore(CCNES_Prep, Forward = c("srm_CCNES_04", 
                                                                                            "srm_CCNES_09", "srm_CCNES_14", "srm_CCNES_21", 
                                                                                            "srm_CCNES_27", "srm_CCNES_32",  "srm_CCNES_40", 
                                                                                            "srm_CCNES_46", "srm_CCNES_51",  "srm_CCNES_60", 
                                                                                            "srm_CCNES_61", "srm_CCNES_72"), MaxMiss = .20),.after = "CCNES_MR_imputation")


# NDA Sheet ####
# Create NDA Prep sheet, select all the needed columns from Prep sheet
NDA_CCNES_Prep <- select(CCNES_Prep, c(subjectkey = child_guid, src_subject_id = child_famID, sex = child_sex ,interview_age_child, interview_date, starts_with("srm_CCNES")))

# Combine NDA and Prep sheet
# Make sure put original NDA structure at first, because the order of the new sheet will be the order of the first item in bind_rows function
setnames(NDA_CCNES_Prep, Reverse_CCNES_names, CCNES_NDA_Names)


# Recreate first line in original NDA file
# Make a empty row, with same number of column in NDA_CCNES, as first line of NDA sheet
NDA_CCNES[1,] <- NA

# ncol(NDA_CCNES)  is number of columns in NDA_CCNES
NDA_CCNES <- bind_rows(NDA_CCNES,NDA_CCNES_Prep)

# Recreate first line in original NDA file
# Make a empty row, with same number of column in NDA_CCNES, as first line of NDA sheet
# ncol(NDA_CCNES)  is number of columns in NDA_CCNES
first_line <- matrix("", nrow = 1, ncol = ncol(NDA_CCNES))

# assign the first cell in first_line as pabq which is the first cell in original NDA structure
first_line[,1] <- "pabq"

# assign the second cell in first_line as pabq
first_line[,2] <- "1"

# NDA output ####
# Create a new file in folder called pabq.csv, and put first line into this file
# pabq.csv file will be saved into same folder as current r script
write.table(first_line, file = "pabq.csv", sep = ",", append = FALSE, quote = FALSE, na = "", col.names = FALSE, row.names = FALSE)

# Append data in NDA_CCNES into pabq.cav file 
write.table(NDA_CCNES, file = 'pabq.csv', sep = ",", append = TRUE, na = "", quote = FALSE, row.names = FALSE)

# Clean Global Environment 
rm(first_line)
