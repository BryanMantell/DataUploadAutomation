# title: "DERS"
# author: "Min Zhang, Bayan"
# date: "5/19/2021"

setwd("~/GitHub/DataUploadAutomation/Upload and Tables/Data")
#setwd("~/Documents/GitHub/DataUploadAutomation/Upload and Tables/Data")
#setwd("C:/Users/mzhang8/Downloads/Upload and Tables/Data")

# Read in NDA template
DERS_NDA <- read.csv("ders01_template.csv")

# Select needed column and name new frame as DERS_Prep
DERS_Prep <- select(Qualtrics, c(Fam_ID, child_guid, child_famID, interview_date, interview_age_child, child_sex, GroupAssignment, Timepoint = Timepoint, contains("srm_ders")))

# re-code participant's answer
DERS_Prep <- DERS_Prep %>% 
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
setnames(DERS_Prep, new_ders_names, Reverse_ders_names)

# Reverse score certain items
DERS_Prep[,revers_ders_cols] = 6 - DERS_Prep[,revers_ders_cols]

# Re-code UO groupassignment 
DERS_Prep <- DERS_Prep %>% 
  mutate_at(c("GroupAssignment"),
            funs(recode(., "Assigned Group 3 (HC)" = "Healthy", 
                        'Assigned Group 2 (FSU)' = "NO DBT",
                        'Assigned Group 1 (DBT)' = "DBT")))



# Calculated awareness
DERS_Prep <- add_column(DERS_Prep, 
                        DERS_awareness = varScore(DERS_Prep, Forward = 
                                                               c("srm_ders_2r", "srm_ders_6r", "srm_ders_8r", 
                                                                 "srm_ders_10r","srm_ders_17r", "srm_ders_34r"), 
                                                     MaxMiss = .02), .after = "srm_ders_36")
# Calculated clarity
DERS_Prep <- add_column(DERS_Prep, 
                        DERS_clarity = varScore(DERS_Prep, Forward =  
                                                             c("srm_ders_1r", "srm_ders_4", "srm_ders_5", 
                                                               "srm_ders_7r", "srm_ders_9"),MaxMiss = .02),
                        .after = "DERS_awareness")

# Calculated goals 
DERS_Prep <- add_column(DERS_Prep, 
                        DERS_goals = varScore(DERS_Prep, Forward =  
                                                           c("srm_ders_13", "srm_ders_18", "srm_ders_20r", 
                                                             "srm_ders_26", "srm_ders_33"),MaxMiss = .02),
                        .after = "DERS_clarity")

# Calculated impulse 
DERS_Prep <- add_column(DERS_Prep, 
                        DERS_impulse = varScore(DERS_Prep, Forward =  
                                                             c("srm_ders_3", "srm_ders_14", "srm_ders_19", 
                                                               "srm_ders_24r", "srm_ders_27", "srm_ders_32"),MaxMiss = .02), .after = "DERS_goals")

# Calculated nonacceptance
DERS_Prep <- add_column(DERS_Prep, 
                        DERS_nonacceptance = varScore(DERS_Prep, Forward =  
                                                                   c("srm_ders_11", "srm_ders_12", "srm_ders_21", 
                                                                     "srm_ders_23", "srm_ders_25", "srm_ders_29"),MaxMiss = .02), .after = "DERS_impulse")

# Calculated strategies 
DERS_Prep <- add_column(DERS_Prep, 
                        DERS_strategies = varScore(DERS_Prep, Forward =  
                                                                c("srm_ders_15", "srm_ders_16", "srm_ders_22r", 
                                                                  "srm_ders_28", "srm_ders_30", "srm_ders_31", 
                                                                  "srm_ders_35", "srm_ders_36"),MaxMiss = .02),
                        .after = "DERS_nonacceptance")

# Calculated total 
ders<-select(DERS_Prep, c(starts_with("srm_ders")))
DERS_Prep <- add_column(DERS_Prep, DERS_total = varScore(DERS_Prep, Forward =  names(ders),MaxMiss = .02), .after = "DERS_strategies")
rm(ders)
# Mean with 67% rule ####
# Check NA percentage
#DERS_Prep$NACheck <- rowSums(is.na(select(DERS_Prep, starts_with("srm"))))/ncol(dplyr::select(DERS_Prep, starts_with("srm")))


# NDA Sheet
# Create NDA prep sheet, select all the needed columns from prep sheet
DERS_NDA_Prep <- select(DERS_Prep, c(subjectkey= child_guid, src_subject_id= child_famID,  sex = child_sex  , interview_age = interview_age_child, interview_date, timept = Timepoint, starts_with("srm_ders")))

# Combine NDA and prep sheet
# Make sure put original NDA structure at first, because the order of the new sheet will be the order of the first item in bind_rows function
setnames(DERS_NDA_Prep, Reverse_ders_names, NDA_DERS_names)

# Recreate first line in original NDA file
# Make a empty row, with same number of column in DERS_NDA, as first line of NDA sheet
#DERS_NDA[1,] <- NA
# ncol(DERS_NDA)  is number of columns in DERS_NDA
DERS_NDA_Prep <- DERS_NDA_Prep %>%
  mutate_all(as.character)
DERS_NDA <- DERS_NDA %>%
  mutate_all(as.character)

DERS_NDA <- bind_rows(DERS_NDA, DERS_NDA_Prep)

# Assign required column but with data missing 999
DERS_NDA[,c("ders_awareness","ders_clarity","ders_goals","ders_impulse","ders_nonacceptance", "ders_strategies", "ders_total")] <- "999"
# Recreate first line in original NDA file
# Make a empty row, with same number of column in DERS_NDA, as first line of NDA sheet
# ncol(DERS_NDA)  is number of columns in DERS_NDA
first_line <- matrix("", nrow = 1, ncol = ncol(DERS_NDA))
# assign the first cell in first_line as ders which is the first cell in original NDA structure
first_line[,1] <- "ders"
# assign the second cell in first_line as ders
first_line[,2] <- "1"

# NDA output ####
# Create a new file in folder called ders.csv, and put first line into this file
# ders.csv file will be saved into same folder as current r script
write.table(first_line, file = "NDA Upload/ders01.csv", sep = ",", append = FALSE, quote = FALSE, na = "", col.names = FALSE, row.names = FALSE)

# Append data in DERS_NDA into ders.cav file 
write.table(DERS_NDA, file = 'NDA Upload/ders01.csv', sep = ",", append = TRUE, na = "", quote = FALSE, row.names = FALSE)

rm(first_line, DERS_NDA_Prep)
