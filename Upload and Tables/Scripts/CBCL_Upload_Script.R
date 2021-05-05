# title: "CBCL Upload Script"
# author: "Austin Fisenko"

# Empty Global Environment
#rm(list = ls())

# Loading library, scientific notation, and upload preparation
source("D:/Austin/Lab Work (D-Drive)/DataUploadAutomation/Measures/CBCL/Upload Preparation.R")
NDA_CBCL <- read.csv("cbcl1_501_template.csv", skip = 1)
options(digits = 3)
library(lmSupport)

# Select necessary items from qualtrics to import into CBCL
CBCL_Prep <- select(Qualtrics, c(Fam_ID, child_guid, child_famID, interview_date, interview_age_child, child_sex, GroupAssignment, Timepoint = Timepoint, contains("srm_cbcl")))

# Create a list of names to be targeted
New_CBCL_Names <- sprintf("srm_cbcl_%03d", seq(1:100))

# Recode text responses into numbers so they can be used in calculations
CBCL_Prep <- CBCL_Prep %>% 
  mutate_at(New_CBCL_Names,
            funs(recode(., "Not True (as far as you know)" = 0, 
                        "Somewhat or Sometimes True" = 1,
                        "Very True or Often True" = 2,.default = NaN)))

# Recode UPMC Group Assignment names to match UO Group Assignment names
CBCL_Prep <- CBCL_Prep %>% 
  mutate_at(c("GroupAssignment"),
            funs(recode(., "Assigned Group 3 (HC)" = "Healthy", 
                        'Assigned Group 2 (FSU)' = "NO DBT",
                        'Assigned Group 1 (DBT)' = "DBT")))

# Creating calculated columns for "cbcl_er"
CBCL_Prep <- add_column(CBCL_Prep, cbcl_er = varScore(CBCL_Prep, Forward = c("srm_cbcl_021", "srm_cbcl_046", "srm_cbcl_051", "srm_cbcl_079", "srm_cbcl_082", "srm_cbcl_083", "srm_cbcl_092", 
                                                                             "srm_cbcl_097", "srm_cbcl_099"), MaxMiss = .20),.after = "srm_cbcl_100")


# Creating calculated columns for "cbcl_ad"
CBCL_Prep <- add_column(CBCL_Prep, cbcl_ad = varScore(CBCL_Prep, Forward = c("srm_cbcl_010", "srm_cbcl_033", "srm_cbcl_037", "srm_cbcl_043", "srm_cbcl_047", "srm_cbcl_068", "srm_cbcl_087", 
                                                                             "srm_cbcl_090"), MaxMiss = .20),.after = "cbcl_er")


# Creating calculated columns for "cbcl_sc"
CBCL_Prep <- add_column(CBCL_Prep, cbcl_sc = varScore(CBCL_Prep, Forward = c("srm_cbcl_001", "srm_cbcl_007", "srm_cbcl_012", "srm_cbcl_019", "srm_cbcl_024", "srm_cbcl_039", "srm_cbcl_045", 
                                                                             "srm_cbcl_052", "srm_cbcl_078", "srm_cbcl_086", "srm_cbcl_093"), MaxMiss = .20),.after = "cbcl_ad")


# Creating calculated columns for "cbcl_w"
CBCL_Prep <- add_column(CBCL_Prep, cbcl_w = varScore(CBCL_Prep, Forward = c("srm_cbcl_002", "srm_cbcl_004", "srm_cbcl_023", "srm_cbcl_062", "srm_cbcl_067", "srm_cbcl_070", "srm_cbcl_071", 
                                                                            "srm_cbcl_098"), MaxMiss = .20),.after = "cbcl_sc")


# Creating calculated columns for "cbcl_sp"
CBCL_Prep <- add_column(CBCL_Prep, cbcl_sp = varScore(CBCL_Prep, Forward = c("srm_cbcl_022", "srm_cbcl_038", "srm_cbcl_048", "srm_cbcl_064", "srm_cbcl_074",
                                                                             "srm_cbcl_084", "srm_cbcl_094"), MaxMiss = .20),.after = "cbcl_w")


# Creating calculated columns for "cbcl_ap"
CBCL_Prep <- add_column(CBCL_Prep, cbcl_ap = varScore(CBCL_Prep, Forward = c("srm_cbcl_005", "srm_cbcl_006", "srm_cbcl_056", "srm_cbcl_059",
                                                                             "srm_cbcl_095"), MaxMiss = .20),.after = "cbcl_sp")


# Creating calculated columns for "cbcl_ab"
CBCL_Prep <- add_column(CBCL_Prep, cbcl_ab = varScore(CBCL_Prep, Forward = c("srm_cbcl_008", "srm_cbcl_015", "srm_cbcl_016", "srm_cbcl_018", "srm_cbcl_020", "srm_cbcl_027", "srm_cbcl_029", 
                                                                             "srm_cbcl_035", "srm_cbcl_040", "srm_cbcl_042", "srm_cbcl_044", "srm_cbcl_053", "srm_cbcl_058", "srm_cbcl_066", 
                                                                             "srm_cbcl_069", "srm_cbcl_081", "srm_cbcl_085", "srm_cbcl_088", "srm_cbcl_096"), MaxMiss = .20),.after = "cbcl_ap")


# Creating calculated columns for "cbcl_op"
CBCL_Prep <- add_column(CBCL_Prep, cbcl_op = varScore(CBCL_Prep, Forward = c("srm_cbcl_003", "srm_cbcl_009", "srm_cbcl_011", "srm_cbcl_013", "srm_cbcl_014", "srm_cbcl_017", "srm_cbcl_025", 
                                                                             "srm_cbcl_026", "srm_cbcl_028", "srm_cbcl_030", "srm_cbcl_031", "srm_cbcl_032", "srm_cbcl_034", "srm_cbcl_036", 
                                                                             "srm_cbcl_041", "srm_cbcl_049", "srm_cbcl_050", "srm_cbcl_054", "srm_cbcl_055", "srm_cbcl_057", "srm_cbcl_060",
                                                                             "srm_cbcl_061", "srm_cbcl_063", "srm_cbcl_065", "srm_cbcl_072", "srm_cbcl_073", "srm_cbcl_075", "srm_cbcl_076",
                                                                             "srm_cbcl_077", "srm_cbcl_080", "srm_cbcl_089", "srm_cbcl_091", "srm_cbcl_100"), MaxMiss = .20),.after = "cbcl_ab")


# Creating calculated columns for "cbcl_int"
CBCL_Prep <- add_column(CBCL_Prep, cbcl_int = varScore(CBCL_Prep, Forward = c("srm_cbcl_021", "srm_cbcl_046", "srm_cbcl_051", "srm_cbcl_079", "srm_cbcl_082", "srm_cbcl_083", "srm_cbcl_092", 
                                                                              "srm_cbcl_097", "srm_cbcl_099", "srm_cbcl_010", "srm_cbcl_033", "srm_cbcl_037", "srm_cbcl_043", "srm_cbcl_047", 
                                                                              "srm_cbcl_068", "srm_cbcl_087", "srm_cbcl_090", "srm_cbcl_001", "srm_cbcl_007", "srm_cbcl_012", "srm_cbcl_019",
                                                                              "srm_cbcl_024", "srm_cbcl_039", "srm_cbcl_045", "srm_cbcl_052", "srm_cbcl_078", "srm_cbcl_086", "srm_cbcl_093", 
                                                                              "srm_cbcl_002", "srm_cbcl_004", "srm_cbcl_023", "srm_cbcl_062", "srm_cbcl_067", "srm_cbcl_070", "srm_cbcl_071",
                                                                              "srm_cbcl_098"), MaxMiss = .20),.after = "cbcl_op")


# Creating calculated columns for "cbcl_ext"
CBCL_Prep <- add_column(CBCL_Prep, cbcl_ext = varScore(CBCL_Prep, Forward = c("srm_cbcl_005", "srm_cbcl_006", "srm_cbcl_056", "srm_cbcl_059", "srm_cbcl_095", "srm_cbcl_008", "srm_cbcl_015",
                                                                              "srm_cbcl_016", "srm_cbcl_018", "srm_cbcl_020", "srm_cbcl_027", "srm_cbcl_029", "srm_cbcl_035", "srm_cbcl_040",
                                                                              "srm_cbcl_042", "srm_cbcl_044", "srm_cbcl_053", "srm_cbcl_058", "srm_cbcl_066", "srm_cbcl_069", "srm_cbcl_081",
                                                                              "srm_cbcl_085", "srm_cbcl_088", "srm_cbcl_096"), MaxMiss = .20),.after = "cbcl_int")


# Creating calculated columns for "cbcl_total"
CBCL_Prep <- add_column(CBCL_Prep, cbcl_total = varScore(CBCL_Prep, Forward = c("srm_cbcl_001", "srm_cbcl_002", "srm_cbcl_003", "srm_cbcl_004", "srm_cbcl_005", "srm_cbcl_006", "srm_cbcl_007",
                                                                                "srm_cbcl_008", "srm_cbcl_009", "srm_cbcl_010", "srm_cbcl_011", "srm_cbcl_012", "srm_cbcl_013", "srm_cbcl_014",
                                                                                "srm_cbcl_015", "srm_cbcl_016", "srm_cbcl_017", "srm_cbcl_018", "srm_cbcl_019", "srm_cbcl_020", "srm_cbcl_021",
                                                                                "srm_cbcl_022", "srm_cbcl_023", "srm_cbcl_024", "srm_cbcl_025", "srm_cbcl_026", "srm_cbcl_027", "srm_cbcl_028",
                                                                                "srm_cbcl_029", "srm_cbcl_030", "srm_cbcl_031", "srm_cbcl_032", "srm_cbcl_033", "srm_cbcl_034", "srm_cbcl_035",
                                                                                "srm_cbcl_036", "srm_cbcl_037", "srm_cbcl_038", "srm_cbcl_039", "srm_cbcl_040", "srm_cbcl_041", "srm_cbcl_042",
                                                                                "srm_cbcl_043", "srm_cbcl_044", "srm_cbcl_045", "srm_cbcl_046", "srm_cbcl_047", "srm_cbcl_048", "srm_cbcl_049",
                                                                                "srm_cbcl_050", "srm_cbcl_051", "srm_cbcl_052", "srm_cbcl_053", "srm_cbcl_054", "srm_cbcl_055", "srm_cbcl_056",
                                                                                "srm_cbcl_057", "srm_cbcl_058", "srm_cbcl_059", "srm_cbcl_060", "srm_cbcl_061", "srm_cbcl_062", "srm_cbcl_063",
                                                                                "srm_cbcl_064", "srm_cbcl_065", "srm_cbcl_066", "srm_cbcl_067", "srm_cbcl_068", "srm_cbcl_069", "srm_cbcl_070",
                                                                                "srm_cbcl_071", "srm_cbcl_072", "srm_cbcl_073", "srm_cbcl_074", "srm_cbcl_075", "srm_cbcl_076", "srm_cbcl_077",
                                                                                "srm_cbcl_078", "srm_cbcl_079", "srm_cbcl_080", "srm_cbcl_081", "srm_cbcl_082", "srm_cbcl_083", "srm_cbcl_084",
                                                                                "srm_cbcl_085", "srm_cbcl_086", "srm_cbcl_087", "srm_cbcl_088", "srm_cbcl_089", "srm_cbcl_090", "srm_cbcl_091",
                                                                                "srm_cbcl_092", "srm_cbcl_093", "srm_cbcl_094", "srm_cbcl_095", "srm_cbcl_096", "srm_cbcl_097", "srm_cbcl_098",
                                                                                "srm_cbcl_099", "srm_cbcl_100"), MaxMiss = .20),.after = "cbcl_ext")

# Create NDA prep sheet
# Select all the needed columns from CBCL_Prep sheet
NDA_CBCL_Prep <- select(CBCL_Prep, c(subjectkey = child_guid, src_subject_id = child_famID, sex = child_sex ,interview_age_child, interview_date, starts_with("srm")))

# Create NDA structure column names, they are unique and without a pattern so they must be made manually 
NDA_CBCL_Names <- paste(c("cbcl56a", "cbcl1", "cbcl_nt", "cbcl_eye", "cbcl8", "cbcl10", "cbcl_out", "cbcl_wait", "cbcl_chew", "cbcl11", "cbcl_help", "cbcl49", "cbcl14", "cbcl15", "cbcl_defiant", "cbcl_dem", "cbcl20", 
                          "cbcl21", "cbcl_diar", "cbcl_disob", "cbcl_dist", "cbcl_alonsleep", "cbcl_answer", "cbcl24", "cbcl25", "cbcl_fun", "cbcl26", "cbcl_home", "cbcl_frust", "cbcl27", "cbcl_eat", "cbcl29", "cbcl_feel", "cbcl36", 
                          "cbcl37", "cbcl_every", "cbcl_upset", "cbcl_troubsleep", "cbcl56b", "cbcl_hit", "cbcl_breath", "cbcl_hurt", "cbcl_unhap", "cbcl_angry", "cbcl56c", "cbcl46", "cbcl45", "cbcl47", "cbcl53", "cbcl54", "cbcl_panic",
                          "cbcl_bow", "cbcl57", "cbcl58", "cbcl60", "cbcl62", "cbcl56d", "cbcl_punish", "cbcl_shift", "cbcl56e", "cbcl_reat", "cbcl_play", "cbcl_rock", "cbcl_bed", "cbcl_toil", "cbcl68", "cbcl_aff", "cbcl71", "cbcl_selfish",
                          "cbcl_littleaf", "cbcl_inter", "cbcl_fear", "cbcl75", "cbcl76", "cbcl_smear", "cbcl79", "cbcl_stares", "cbcl56f", "cbcl_sad", "cbcl84", "cbcl86", "cbcl87", "cbcl88", "cbcl_crie", "cbcl95", "cbcl_clean", "cbcl50",
                          "cbcl_uncoop", "cbcl102", "cbcl103", "cbcl104", "cbcl_people", "cbcl56g", "cbcl_wake", "cbcl_wand", "cbcl19", "cbcl109", "cbcl_withdr", "cbcl112", "cbcl113a"))

# Change names in the NDA_CBCL_Prep to match the NDA structure column names
New_CBCL_Names <- sprintf("srm_cbcl_%03d", seq(1:100))
setnames(NDA_CBCL_Prep, New_CBCL_Names, NDA_CBCL_Names)

# Make an empty row in the NDA sheet for compatibility (to avoid some potential errors)
NDA_CBCL[1,] <- NA

# Combine NDA CBCL Prep sheet with the NDA structure
NDA_CBCL <- bind_rows(NDA_CBCL,NDA_CBCL_Prep)

# Recreate first line in orignial NDA file
# Make an empty row, with same number of column in NDA_CBCL, as first line of NDA sheet
# ncol(NDA_CBCL)  is number of columns in NDA_CBCL
first_line <- matrix("", nrow = 1, ncol = ncol(NDA_CBCL))

# assign the first cell in first_line as cbcl1_5 which is the first cell in orignial NDA structure
first_line[,1] <- "cbcl1_5"

# assign the second cell in first_line as "1"
first_line[,2] <- "1"

# Create a new file in folder called cbcl1_5.csv, and put first line into this file
# cbcl1_5.csv file will be saved into same folder as this current r script
write.table(first_line, file = "cbcl1_5.csv", sep = ",", append = FALSE, quote = FALSE, na = "", col.names = FALSE, row.names = FALSE)

# Append data in NDA_CBCL into cbcl1_5.csv file 
write.table(NDA_CBCL, file = 'cbcl1_5.csv', sep = ",", append = TRUE, na = "", quote = FALSE, row.names = FALSE)

# Clean environment of intermediate calculations for NDA structure
rm(NDA_CBCL_Prep, NDA_CBCL_Names, first_line, New_CBCL_Names)