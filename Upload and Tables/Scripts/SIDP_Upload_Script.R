# title: "SIDP"
# author: "Min Zhang"
# date: "26/5/2021"

setwd("~/GitHub/DataUploadAutomation/Upload and Tables/Data")

NDA_SIDP <- read.csv("sidp01_template.csv", skip = 1)
SIDP_UPMC <- read.csv("UPMC_SIDP.csv")
SIDP_UO <-  read.csv("UO_SIDP.csv")

# Select relevant pedigree information, rename as needed. (Include GroupAssignment for treatment progress calculation.)
SIDP_UO$site <- "Ore" 
SIDP_UO$visit <- 0
SIDP <- rbind(SIDP_UO, SIDP_UPMC)

SIDP <- select(SIDP, c(FamID, sex = gender, starts_with("par"), starts_with("scz"), starts_with("szt"), starts_with("ant"), starts_with("brd"), starts_with("hst"), starts_with("nar"), starts_with("avd"), starts_with("dpn"), starts_with("obc"), site, visit))

Pedigree <- select(Pedigree, c(child_guid, FamID, interview_age = ChildAge_Intake, GroupAssignment))

SIDP_Prep <- merge(SIDP, Pedigree, by = "FamID")

# Re-code UO Groupassignment 
SIDP_Prep <- SIDP_Prep %>% 
  mutate_at(c("GroupAssignment"),
            funs(recode(., "Assigned Group 3 (HC)" = "Healthy", 
                        'Assigned Group 2 (FSU)' = "NO DBT",
                        'Assigned Group 1 (DBT)' = "DBT")))

# Create NDA Prep sheet, select all the needed columns from Prep sheet
NDA_SIDP_Prep <- SIDP_Prep %>%
  rename(src_subject_id = FamID, subjectkey = child_guid)

# Add empty line in original NDA file for merge
# NDA_SIDP[1,] <- NA
# Recreate first line in original NDA file
NDA_SIDP <- bind_rows(NDA_SIDP, NDA_SIDP_Prep)
first_line <- matrix("", nrow = 1, ncol = ncol(NDA_SIDP))
first_line[,1] <- "sidp"
# assign the second cell in first_line as dccs
first_line[,2] <- "1"

# NDA output ####
# Create a new file in folder called dccs.csv, and put first line into this file
# dccs.csv file will be saved into same folder as current r script
write.table(first_line, file = "sidp01.csv", sep = ",", append = FALSE, quote = FALSE, na = "", col.names = FALSE, row.names = FALSE)

# Append data in NDA_DCCS into dccs.csv file 
write.table(NDA_SIDP, file = 'sidp01.csv', sep = ",", append = TRUE, na = "", quote = FALSE, row.names = FALSE)