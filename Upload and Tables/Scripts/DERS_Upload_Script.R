# title: "DERS"
# author: "Min Zhang, Bayan"
# date: "5/19/2021"

source("~/Documents/GitHub/DataUploadAutomation/Upload and Tables/Data/Upload Preparation.R")

#NDA_ders <- read.csv("ders01_template.csv")

Qualtrics <- select(Qualtrics, c(Fam_ID, child_guid, child_famID, interview_date, interview_age_child, child_sex, GroupAssignment, Timepoint = Timepoint, contains("srm_ders")))

Qualtrics <- Qualtrics %>% 
  mutate_at(new_ders_names,
            funs(recode(., "Almost Never (0-10%)" = 1, 
                        "Sometimes (11%-35%)" = 2,
                        "About half the time (36%-65%)" = 3,
                        "Most of the time (66-90%)" = 4,
                        "Almost Always (91-100%)" = 5)))

# Rename the reverse scored columns 
Reverse_ders_names <- new_ders_names
revers_ders_cols <- c("srm_ders_1", "srm_ders_2", "srm_ders_6", "srm_ders_7", "srm_ders_8", "srm_ders_10", 
                      "srm_ders_17", "srm_ders_20", "srm_ders_22","srm_ders_24", "srm_ders_34")
revers_ders_cols <- paste(revers_ders_cols, "r", sep = "")
Reverse_ders_names[c(1,2,6,7,8,10,17,20,22,24,34)] <- revers_ders_cols
setnames(Qualtrics, new_ders_names, Reverse_ders_names)

# Reverse score certain items
Qualtrics[,revers_ders_cols] = 6 - Qualtrics[,revers_ders_cols]

# Recode UO groupassignment 
Qualtrics <- Qualtrics %>% 
  mutate_at(c("GroupAssignment"),
            funs(recode(., "Assigned Group 3 (HC)" = "Healthy", 
                        'Assigned Group 2 (FSU)' = "NO DBT",
                        'Assigned Group 1 (DBT)' = "DBT")))



# Calculated awareness
Qualtrics <- add_column(Qualtrics, 
                        DERS_awareness_imputation = varScore(Qualtrics, Forward = 
                                                               c("srm_ders_2r", "srm_ders_6r", "srm_ders_8r", 
                                                                 "srm_ders_10r","srm_ders_17r", "srm_ders_34r"), 
                                                     MaxMiss = .02), .after = "srm_ders_36")
# Calculated clarity
Qualtrics <- add_column(Qualtrics, 
                        DERS_clarity_imputation = varScore(Qualtrics, Forward =  
                                                             c("srm_ders_1r", "srm_ders_4", "srm_ders_5", 
                                                               "srm_ders_7r", "srm_ders_9"),MaxMiss = .02),
                        .after = "DERS_awareness_imputation")

# Calculated goals 
Qualtrics <- add_column(Qualtrics, 
                        DERS_goals_imputation = varScore(Qualtrics, Forward =  
                                                           c("srm_ders_13", "srm_ders_18", "srm_ders_20r", 
                                                             "srm_ders_26", "srm_ders_33"),MaxMiss = .02),
                        .after = "DERS_clarity_imputation")

# Calculated impulse 
Qualtrics <- add_column(Qualtrics, 
                        DERS_impulse_imputation = varScore(Qualtrics, Forward =  
                                                             c("srm_ders_3", "srm_ders_14", "srm_ders_19", 
                                                               "srm_ders_24r", "srm_ders_27", "srm_ders_32"),MaxMiss = .02), .after = "DERS_goals_imputation")

# Calculated nonacceptance
Qualtrics <- add_column(Qualtrics, 
                        DERS_nonacceptance_imputation = varScore(Qualtrics, Forward =  
                                                                   c("srm_ders_11", "srm_ders_12", "srm_ders_21", 
                                                                     "srm_ders_23", "srm_ders_25", "srm_ders_29"),MaxMiss = .02), .after = "DERS_impulse_imputation")

# Calculated strategies 
Qualtrics <- add_column(Qualtrics, 
                        DERS_strategies_imputation = varScore(Qualtrics, Forward =  
                                                                c("srm_ders_15", "srm_ders_16", "srm_ders_22r", 
                                                                  "srm_ders_28", "srm_ders_30", "srm_ders_31", 
                                                                  "srm_ders_35", "srm_ders_36"),MaxMiss = .02),
                        .after = "DERS_nonacceptance_imputation")

# Calculated total 
Qualtrics <- add_column(Qualtrics, DERS_total_imputation = varScore(Qualtrics, Forward =  select(Qualtrics,c(starts_with("srm_ders"))),MaxMiss = .02), .after = "DERS_strategies_imputation")
# Mean with 67% rule ####
# Check NA percentage
#Qualtrics$NACheck <- rowSums(is.na(select(Qualtrics, starts_with("srm"))))/ncol(dplyr::select(Qualtrics, starts_with("srm")))


# NDA Sheet
# Create NDA prep sheet, select all the needed columns from prep sheet
NDA_ders_Prep <- select(Qualtrics, c(subjectkey= child_guid, src_subject_id= child_famID,  sex = child_sex  ,interview_age_child, interview_date, starts_with("srm_ders")))

# Combine NDA and prep sheet
# Make sure put original NDA structure at first, because the order of the new sheet will be the order of the first item in bind_rows function
setnames(NDA_ders_Prep, Reverse_ders_names, NDA_DERS_names)

# Recreate first line in orignial NDA file
# Make a empty row, with same number of column in NDA_ders, as first line of NDA sheet
NDA_ders[1,] <- NA
# ncol(NDA_ders)  is number of columns in NDA_ders
NDA_ders <- bind_rows(NDA_ders,NDA_ders_Prep)

# Recreate first line in orignial NDA file
# Make a empty row, with same number of column in NDA_ders, as first line of NDA sheet
# ncol(NDA_ders)  is number of columns in NDA_ders
first_line <- matrix("", nrow = 1, ncol = ncol(NDA_ders))
# assign the firt cell in first_line as ders which is the first cell in orignial NDA structure
first_line[,1] <- "ders"
# assign the second cell in first_lineas ders
first_line[,2] <- "1"

# NDA output ####
# Create a new file in folder called ders.csv, and put first line into this file
# ders.csv file will be saved into same folder as current r script
write.table(first_line, file = "ders.csv", sep = ",", append = FALSE, quote = FALSE, na = "", col.names = FALSE, row.names = FALSE)

# Append data in NDA_ders into ders.cav file 
write.table(NDA_ders, file = 'ders.csv', sep = ",", append = TRUE, na = "", quote = FALSE, row.names = FALSE)

