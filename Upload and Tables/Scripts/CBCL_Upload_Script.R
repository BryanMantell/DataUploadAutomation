# title: "CBCL Upload Script"
# author: "Austin Fisenko"

# Empty Global Environment
#rm(list = ls())

# Loading library, scientific notation, and upload preparation
setwd("~/GitHub/DataUploadAutomation/Upload and Tables/Data")
#source("~/GitHub/DataUploadAutomation/Upload and Tables/Data/Upload Preparation.R")
CBCL_NDA <- read.csv("cbcl1_501_template.csv", skip = 1)

# Select necessary items from qualtrics to import into CBCL
CBCL_Prep <- select(Qualtrics, c(Fam_ID, child_guid, child_famID, interview_date, interview_age_child, child_sex, GroupAssignment, Timepoint, contains("srm_cbcl")))

# Create a list of names to be targeted
New_CBCL_Names <- sprintf("srm_CBCL_%03d", seq(1:100))

# Recode text responses into numbers so they can be used in calculations
CBCL_Prep <- CBCL_Prep %>% 
  mutate_at(New_CBCL_Names,
            funs(recode(., "Not True (as far as you know)" = 0, 
                        "Somewhat or Sometimes True" = 1,
                        "Very True or Often True" = 2,
                        '0' = 0,
                        '1' = 1,
                        '2' = 2,.default = NaN)))

# Recode UPMC Group Assignment names to match UO Group Assignment names
CBCL_Prep <- CBCL_Prep %>% 
  mutate_at(c("GroupAssignment"),
            funs(recode(., "Assigned Group 3 (HC)" = "Healthy", 
                        'Assigned Group 2 (FSU)' = "NO DBT",
                        'Assigned Group 1 (DBT)' = "DBT")))

# Creating calculated columns for "CBCL_ER"
CBCL_Prep <- add_column(CBCL_Prep, CBCL_ER_r = varScore(CBCL_Prep, Forward = c("srm_CBCL_021", "srm_CBCL_046", "srm_CBCL_051", "srm_CBCL_079", "srm_CBCL_082", "srm_CBCL_083", "srm_CBCL_092", 
                                                                               "srm_CBCL_097", "srm_CBCL_099"), MaxMiss = .20),.after = "srm_CBCL_100")


# Creating calculated columns for "CBCL_AD"
CBCL_Prep <- add_column(CBCL_Prep, CBCL_AD_r = varScore(CBCL_Prep, Forward = c("srm_CBCL_010", "srm_CBCL_033", "srm_CBCL_037", "srm_CBCL_043", "srm_CBCL_047", "srm_CBCL_068", "srm_CBCL_087", 
                                                                               "srm_CBCL_090"), MaxMiss = .20),.after = "CBCL_ER_r")


# Creating calculated columns for "CBCL_SC"
CBCL_Prep <- add_column(CBCL_Prep, CBCL_SC_r = varScore(CBCL_Prep, Forward = c("srm_CBCL_001", "srm_CBCL_007", "srm_CBCL_012", "srm_CBCL_019", "srm_CBCL_024", "srm_CBCL_039", "srm_CBCL_045", 
                                                                               "srm_CBCL_052", "srm_CBCL_078", "srm_CBCL_086", "srm_CBCL_093"), MaxMiss = .20),.after = "CBCL_AD_r")


# Creating calculated columns for "CBCL_W"
CBCL_Prep <- add_column(CBCL_Prep, CBCL_W_r = varScore(CBCL_Prep, Forward = c("srm_CBCL_002", "srm_CBCL_004", "srm_CBCL_023", "srm_CBCL_062", "srm_CBCL_067", "srm_CBCL_070", "srm_CBCL_071", 
                                                                              "srm_CBCL_098"), MaxMiss = .20),.after = "CBCL_SC_r")


# Creating calculated columns for "CBCL_SP"
CBCL_Prep <- add_column(CBCL_Prep, CBCL_SP_r = varScore(CBCL_Prep, Forward = c("srm_CBCL_022", "srm_CBCL_038", "srm_CBCL_048", "srm_CBCL_064", "srm_CBCL_074",
                                                                               "srm_CBCL_084", "srm_CBCL_094"), MaxMiss = .20),.after = "CBCL_W_r")


# Creating calculated columns for "CBCL_AP"
CBCL_Prep <- add_column(CBCL_Prep, CBCL_AP_r = varScore(CBCL_Prep, Forward = c("srm_CBCL_005", "srm_CBCL_006", "srm_CBCL_056", "srm_CBCL_059",
                                                                               "srm_CBCL_095"), MaxMiss = .20),.after = "CBCL_SP_r")


# Creating calculated columns for "CBCL_AB"
CBCL_Prep <- add_column(CBCL_Prep, CBCL_AB_r = varScore(CBCL_Prep, Forward = c("srm_CBCL_008", "srm_CBCL_015", "srm_CBCL_016", "srm_CBCL_018", "srm_CBCL_020", "srm_CBCL_027", "srm_CBCL_029", 
                                                                               "srm_CBCL_035", "srm_CBCL_040", "srm_CBCL_042", "srm_CBCL_044", "srm_CBCL_053", "srm_CBCL_058", "srm_CBCL_066", 
                                                                               "srm_CBCL_069", "srm_CBCL_081", "srm_CBCL_085", "srm_CBCL_088", "srm_CBCL_096"), MaxMiss = .20),.after = "CBCL_AP_r")


# Creating calculated columns for "CBCL_OP"
CBCL_Prep <- add_column(CBCL_Prep, CBCL_OP_r = varScore(CBCL_Prep, Forward = c("srm_CBCL_003", "srm_CBCL_009", "srm_CBCL_011", "srm_CBCL_013", "srm_CBCL_014", "srm_CBCL_017", "srm_CBCL_025", 
                                                                               "srm_CBCL_026", "srm_CBCL_028", "srm_CBCL_030", "srm_CBCL_031", "srm_CBCL_032", "srm_CBCL_034", "srm_CBCL_036", 
                                                                               "srm_CBCL_041", "srm_CBCL_049", "srm_CBCL_050", "srm_CBCL_054", "srm_CBCL_055", "srm_CBCL_057", "srm_CBCL_060",
                                                                               "srm_CBCL_061", "srm_CBCL_063", "srm_CBCL_065", "srm_CBCL_072", "srm_CBCL_073", "srm_CBCL_075", "srm_CBCL_076",
                                                                               "srm_CBCL_077", "srm_CBCL_080", "srm_CBCL_089", "srm_CBCL_091", "srm_CBCL_100"), MaxMiss = .20),.after = "CBCL_AB_r")


# Creating calculated columns for "CBCL_INT"
CBCL_Prep <- add_column(CBCL_Prep, CBCL_INT_r = varScore(CBCL_Prep, Forward = c("srm_CBCL_021", "srm_CBCL_046", "srm_CBCL_051", "srm_CBCL_079", "srm_CBCL_082", "srm_CBCL_083", "srm_CBCL_092", 
                                                                                "srm_CBCL_097", "srm_CBCL_099", "srm_CBCL_010", "srm_CBCL_033", "srm_CBCL_037", "srm_CBCL_043", "srm_CBCL_047", 
                                                                                "srm_CBCL_068", "srm_CBCL_087", "srm_CBCL_090", "srm_CBCL_001", "srm_CBCL_007", "srm_CBCL_012", "srm_CBCL_019",
                                                                                "srm_CBCL_024", "srm_CBCL_039", "srm_CBCL_045", "srm_CBCL_052", "srm_CBCL_078", "srm_CBCL_086", "srm_CBCL_093", 
                                                                                "srm_CBCL_002", "srm_CBCL_004", "srm_CBCL_023", "srm_CBCL_062", "srm_CBCL_067", "srm_CBCL_070", "srm_CBCL_071",
                                                                                "srm_CBCL_098"), MaxMiss = .20),.after = "CBCL_OP_r")


# Creating calculated columns for "CBCL_EXT"
CBCL_Prep <- add_column(CBCL_Prep, CBCL_EXT_r = varScore(CBCL_Prep, Forward = c("srm_CBCL_005", "srm_CBCL_006", "srm_CBCL_056", "srm_CBCL_059", "srm_CBCL_095", "srm_CBCL_008", "srm_CBCL_015",
                                                                                "srm_CBCL_016", "srm_CBCL_018", "srm_CBCL_020", "srm_CBCL_027", "srm_CBCL_029", "srm_CBCL_035", "srm_CBCL_040",
                                                                                "srm_CBCL_042", "srm_CBCL_044", "srm_CBCL_053", "srm_CBCL_058", "srm_CBCL_066", "srm_CBCL_069", "srm_CBCL_081",
                                                                                "srm_CBCL_085", "srm_CBCL_088", "srm_CBCL_096"), MaxMiss = .20),.after = "CBCL_INT_r")


# Creating calculated columns for "CBCL_TOT"
CBCL_Prep <- add_column(CBCL_Prep, CBCL_TOT_r = varScore(CBCL_Prep, Forward = c("srm_CBCL_001", "srm_CBCL_002", "srm_CBCL_003", "srm_CBCL_004", "srm_CBCL_005", "srm_CBCL_006", "srm_CBCL_007",
                                                                                "srm_CBCL_008", "srm_CBCL_009", "srm_CBCL_010", "srm_CBCL_011", "srm_CBCL_012", "srm_CBCL_013", "srm_CBCL_014",
                                                                                "srm_CBCL_015", "srm_CBCL_016", "srm_CBCL_017", "srm_CBCL_018", "srm_CBCL_019", "srm_CBCL_020", "srm_CBCL_021",
                                                                                "srm_CBCL_022", "srm_CBCL_023", "srm_CBCL_024", "srm_CBCL_025", "srm_CBCL_026", "srm_CBCL_027", "srm_CBCL_028",
                                                                                "srm_CBCL_029", "srm_CBCL_030", "srm_CBCL_031", "srm_CBCL_032", "srm_CBCL_033", "srm_CBCL_034", "srm_CBCL_035",
                                                                                "srm_CBCL_036", "srm_CBCL_037", "srm_CBCL_038", "srm_CBCL_039", "srm_CBCL_040", "srm_CBCL_041", "srm_CBCL_042",
                                                                                "srm_CBCL_043", "srm_CBCL_044", "srm_CBCL_045", "srm_CBCL_046", "srm_CBCL_047", "srm_CBCL_048", "srm_CBCL_049",
                                                                                "srm_CBCL_050", "srm_CBCL_051", "srm_CBCL_052", "srm_CBCL_053", "srm_CBCL_054", "srm_CBCL_055", "srm_CBCL_056",
                                                                                "srm_CBCL_057", "srm_CBCL_058", "srm_CBCL_059", "srm_CBCL_060", "srm_CBCL_061", "srm_CBCL_062", "srm_CBCL_063",
                                                                                "srm_CBCL_064", "srm_CBCL_065", "srm_CBCL_066", "srm_CBCL_067", "srm_CBCL_068", "srm_CBCL_069", "srm_CBCL_070",
                                                                                "srm_CBCL_071", "srm_CBCL_072", "srm_CBCL_073", "srm_CBCL_074", "srm_CBCL_075", "srm_CBCL_076", "srm_CBCL_077",
                                                                                "srm_CBCL_078", "srm_CBCL_079", "srm_CBCL_080", "srm_CBCL_081", "srm_CBCL_082", "srm_CBCL_083", "srm_CBCL_084",
                                                                                "srm_CBCL_085", "srm_CBCL_086", "srm_CBCL_087", "srm_CBCL_088", "srm_CBCL_089", "srm_CBCL_090", "srm_CBCL_091",
                                                                                "srm_CBCL_092", "srm_CBCL_093", "srm_CBCL_094", "srm_CBCL_095", "srm_CBCL_096", "srm_CBCL_097", "srm_CBCL_098",
                                                                                "srm_CBCL_099", "srm_CBCL_100"), MaxMiss = .20),.after = "CBCL_EXT_r")
# Import CBCL's t-Scores to be referenced in conversion
CBCL_Codebook <- read.csv("CBCL_Codebook.csv")

# Separate the codebook into individual subscales
ER_Tscores <- select(CBCL_Codebook, CBCL_ER_r, CBCL_ER_t)
ER_Tscores <- ER_Tscores[-c(20:201), ]

AD_Tscores <- select(CBCL_Codebook, CBCL_AD_r, CBCL_AD_t)
AD_Tscores <- AD_Tscores[-c(18:201), ]

SC_Tscores <- select(CBCL_Codebook, CBCL_SC_r, CBCL_SC_t)
SC_Tscores <- SC_Tscores[-c(24:201), ]

W_Tscores <- select(CBCL_Codebook, CBCL_W_r, CBCL_W_t)
W_Tscores <- W_Tscores[-c(18:201), ]

SP_Tscores <- select(CBCL_Codebook, CBCL_SP_r, CBCL_SP_t)
SP_Tscores <- SP_Tscores[-c(16:201), ]

AP_Tscores <- select(CBCL_Codebook, CBCL_AP_r, CBCL_AP_t)
AP_Tscores <- AP_Tscores[-c(12:201), ]

AB_Tscores <- select(CBCL_Codebook, CBCL_AB_r, CBCL_AB_t)
AB_Tscores <- AB_Tscores[-c(40:201), ]

#OP_Tscores <- select(CBCL_Codebook, CBCL_OP_r, CBCL_OP_t)
#OP_Tscores <- OP_Tscores[-c(16:201), ]

INT_Tscores <- select(CBCL_Codebook, CBCL_INT_r, CBCL_INT_t)
INT_Tscores <- INT_Tscores[-c(74:201), ]

EXT_Tscores <- select(CBCL_Codebook, CBCL_EXT_r, CBCL_EXT_t)
EXT_Tscores <- EXT_Tscores[-c(50:201), ]

TOT_Tscores <- select(CBCL_Codebook, CBCL_TOT_r, CBCL_TOT_t)

# Merge T scores with next to raw scores
CBCL_Prep <- merge(CBCL_Prep, ER_Tscores, by = "CBCL_ER_r", all.x = TRUE)
CBCL_Prep <- merge(CBCL_Prep, AD_Tscores, by = "CBCL_AD_r", all.x = TRUE)
CBCL_Prep <- merge(CBCL_Prep, SC_Tscores, by = "CBCL_SC_r", all.x = TRUE)
CBCL_Prep <- merge(CBCL_Prep, W_Tscores, by = "CBCL_W_r", all.x = TRUE)
CBCL_Prep <- merge(CBCL_Prep, SP_Tscores, by = "CBCL_SP_r", all.x = TRUE)
CBCL_Prep <- merge(CBCL_Prep, AP_Tscores, by = "CBCL_AP_r", all.x = TRUE)
CBCL_Prep <- merge(CBCL_Prep, AB_Tscores, by = "CBCL_AB_r", all.x = TRUE)
#CBCL_Prep <- merge(CBCL_Prep, OP_Tscores, by = "CBCL_OP_r", all.x = TRUE)
CBCL_Prep <- merge(CBCL_Prep, INT_Tscores, by = "CBCL_INT_r", all.x = TRUE)
CBCL_Prep <- merge(CBCL_Prep, EXT_Tscores, by = "CBCL_EXT_r", all.x = TRUE)
CBCL_Prep <- merge(CBCL_Prep, TOT_Tscores, by = "CBCL_TOT_r", all.x = TRUE)

# Reorder CBCL Prep to fix disarrangement from previous code
CBCL_Column_Order <- c("Fam_ID", "child_guid", "child_famID", "interview_date", "interview_age_child", "child_sex", "GroupAssignment", "Timepoint", "srm_CBCL_001", "srm_CBCL_002", "srm_CBCL_003", "srm_CBCL_004", "srm_CBCL_005", "srm_CBCL_006", "srm_CBCL_007", "srm_CBCL_008", "srm_CBCL_009", "srm_CBCL_010", "srm_CBCL_011", "srm_CBCL_012", "srm_CBCL_013", "srm_CBCL_014", "srm_CBCL_015", "srm_CBCL_016", "srm_CBCL_017", "srm_CBCL_018", "srm_CBCL_019", "srm_CBCL_020", "srm_CBCL_021", "srm_CBCL_022", "srm_CBCL_023", "srm_CBCL_024", "srm_CBCL_025", "srm_CBCL_026", "srm_CBCL_027", "srm_CBCL_028", "srm_CBCL_029", "srm_CBCL_030", "srm_CBCL_031", "srm_CBCL_032", "srm_CBCL_033", "srm_CBCL_034", "srm_CBCL_035", "srm_CBCL_036", "srm_CBCL_037", "srm_CBCL_038", "srm_CBCL_039", "srm_CBCL_040", "srm_CBCL_041", "srm_CBCL_042", "srm_CBCL_043", "srm_CBCL_044", "srm_CBCL_045", "srm_CBCL_046", "srm_CBCL_047", "srm_CBCL_048", "srm_CBCL_049", "srm_CBCL_050", "srm_CBCL_051", "srm_CBCL_052", "srm_CBCL_053", "srm_CBCL_054", "srm_CBCL_055", "srm_CBCL_056", "srm_CBCL_057", "srm_CBCL_058", "srm_CBCL_059", "srm_CBCL_060", "srm_CBCL_061", "srm_CBCL_062", "srm_CBCL_063", "srm_CBCL_064", "srm_CBCL_065", "srm_CBCL_066", "srm_CBCL_067", "srm_CBCL_068", "srm_CBCL_069", "srm_CBCL_070", "srm_CBCL_071", "srm_CBCL_072", "srm_CBCL_073", "srm_CBCL_074", "srm_CBCL_075", "srm_CBCL_076", "srm_CBCL_077", "srm_CBCL_078", "srm_CBCL_079", "srm_CBCL_080", "srm_CBCL_081", "srm_CBCL_082", "srm_CBCL_083", "srm_CBCL_084", "srm_CBCL_085", "srm_CBCL_086", "srm_CBCL_087", "srm_CBCL_088", "srm_CBCL_089", "srm_CBCL_090", "srm_CBCL_091", "srm_CBCL_092", "srm_CBCL_093", "srm_CBCL_094", "srm_CBCL_095", "srm_CBCL_096", "srm_CBCL_097", "srm_CBCL_098", "srm_CBCL_099", "srm_CBCL_100", "CBCL_ER_r", "CBCL_ER_t", "CBCL_AD_r", "CBCL_AD_t", "CBCL_SC_r", "CBCL_SC_t", "CBCL_W_r", "CBCL_W_t", "CBCL_SP_r", "CBCL_SP_t", "CBCL_AP_r", "CBCL_AP_t", "CBCL_AB_r", "CBCL_AB_t", "CBCL_INT_r", "CBCL_INT_t", "CBCL_EXT_r", "CBCL_EXT_t", "CBCL_TOT_r", "CBCL_TOT_t")

CBCL_Prep <- CBCL_Prep[, CBCL_Column_Order]
CBCL_Prep <- arrange(CBCL_Prep, Fam_ID)

rm(ER_Tscores, AD_Tscores, SC_Tscores, W_Tscores, SP_Tscores, AP_Tscores, AB_Tscores, INT_Tscores, EXT_Tscores, TOT_Tscores, CBCL_Column_Order, CBCL_Codebook)


# Create NDA prep sheet
# Select all the needed columns from CBCL_Prep sheet
NDA_CBCL_Prep <- select(CBCL_Prep, c(subjectkey = child_guid, src_subject_id = child_famID, sex = child_sex ,interview_age = interview_age_child, interview_date, starts_with("srm")))

# Create NDA structure column names, they are unique and without a pattern so they must be made manually 
NDA_CBCL_Names <- paste(c("cbcl56a", "cbcl1", "cbcl_nt", "cbcl_eye", "cbcl8", "cbcl10", "cbcl_out", "cbcl_wait", "cbcl_chew", "cbcl11", "cbcl_help", "cbcl49", "cbcl14", "cbcl15", "cbcl_defiant", "cbcl_dem", "cbcl20", 
                          "cbcl21", "cbcl_diar", "cbcl_disob", "cbcl_dist", "cbcl_alonsleep", "cbcl_answer", "cbcl24", "cbcl25", "cbcl_fun", "cbcl26", "cbcl_home", "cbcl_frust", "cbcl27", "cbcl_eat", "cbcl29", "cbcl_feel", "cbcl36", 
                          "cbcl37", "cbcl_every", "cbcl_upset", "cbcl_troubsleep", "cbcl56b", "cbcl_hit", "cbcl_breath", "cbcl_hurt", "cbcl_unhap", "cbcl_angry", "cbcl56c", "cbcl46", "cbcl45", "cbcl47", "cbcl53", "cbcl54", "cbcl_panic",
                          "cbcl_bow", "cbcl57", "cbcl58", "cbcl60", "cbcl62", "cbcl56d", "cbcl_punish", "cbcl_shift", "cbcl56e", "cbcl_reat", "cbcl_play", "cbcl_rock", "cbcl_bed", "cbcl_toil", "cbcl68", "cbcl_aff", "cbcl71", "cbcl_selfish",
                          "cbcl_littleaf", "cbcl_inter", "cbcl_fear", "cbcl75", "cbcl76", "cbcl_smear", "cbcl79", "cbcl_stares", "cbcl56f", "cbcl_sad", "cbcl84", "cbcl86", "cbcl87", "cbcl88", "cbcl_crie", "cbcl95", "cbcl_clean", "cbcl50",
                          "cbcl_uncoop", "cbcl102", "cbcl103", "cbcl104", "cbcl_people", "cbcl56g", "cbcl_wake", "cbcl_wand", "cbcl19", "cbcl109", "cbcl_withdr", "cbcl112", "cbcl113a"))

# Change names in the NDA_CBCL_Prep to match the NDA structure column names
New_CBCL_Names <- sprintf("srm_CBCL_%03d", seq(1:100))
setnames(NDA_CBCL_Prep, New_CBCL_Names, NDA_CBCL_Names)

# Solution 2
CBCL_NDA <- bind_rows(mutate_all(CBCL_NDA, as.character), mutate_all(NDA_CBCL_Prep, as.character))

# Fill necessary NDA missing columns with 999 as on the NDA website
CBCL_NDA[,c("cbcl_emotional_raw", "cbcl_emotional", "cbcl_anxious_raw", "cbcl_anxious", "cbcl_somatic_c_raw", "cbcl_somatic_c", "cbcl_withdrawn_raw", "cbcl_withdrawn", "cbcl_sleep_raw", "cbcl_sleep", "cbcl_attention_raw", "cbcl_attention", "cbcl_aggressive_raw", "cbcl_aggressive", "cbcl_internal_raw", "cbcl_internal", "cbcl_external_raw", "cbcl_external", "cbcl_total_raw", "cbcl_total", "cbcl_affective_raw", "cbcl_affective", "cbcl_anxiety_raw", "cbcl_anxiety", "cbcl_pervasive_raw", "cbcl_pervasive", "cbcl_adhd_raw", "cbcl_adhd", "cbcl_oppositional_raw", "cbcl_oppositional", "phenotype", "cbcl_depresspr_raw", "cbcl_depresspr")] <- "999"

# Fill out relationship column with "1" since the mother is filling out the form for the child
CBCL_NDA$relationship <- "1"

# Recreate first line in orignial NDA file
# Make an empty row, with same number of column in CBCL_NDA, as first line of NDA sheet
# ncol(CBCL_NDA)  is number of columns in CBCL_NDA
first_line <- matrix("", nrow = 1, ncol = ncol(CBCL_NDA))

# assign the first cell in first_line as cbcl1_5 which is the first cell in orignial NDA structure
first_line[,1] <- "cbcl1_5"

# assign the second cell in first_line as "1"
first_line[,2] <- "1"

# Create a new file in folder called cbcl1_5.csv, and put first line into this file
# cbcl1_5.csv file will be saved into same folder as this current r script
write.table(first_line, file = "NDA Upload/cbcl1_5.csv", sep = ",", append = FALSE, quote = FALSE, na = "", col.names = FALSE, row.names = FALSE)

# Append data in CBCL_NDA into cbcl1_5.csv file 
write.table(CBCL_NDA, file = 'NDA Upload/cbcl1_5.csv', sep = ",", append = TRUE, na = "", quote = FALSE, row.names = FALSE)

# Clean environment of intermediate calculations for NDA structure
rm(NDA_CBCL_Prep, NDA_CBCL_Names, first_line, New_CBCL_Names)