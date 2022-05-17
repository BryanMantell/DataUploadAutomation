#t itle: "SIDP"
# author: "Min Zhang"
# date: "26/5/2021"

setwd("~/GitHub/DataUploadAutomation/Upload and Tables/Data")
NDA_SIDP <- read.csv("Templates/sidp01_template.csv", skip = 1)
SIDP_UPMC <- read.csv("UPMC_SIDP.csv", skip = 1)
SIDP_UO <-  read.csv("UO_SIDP.csv")

# Select relevant pedigree information, rename as needed. (Include GroupAssignment for treatment progress calculation.)
SIDP <- rbind(SIDP_UO, SIDP_UPMC) 
SIDP <- subset(SIDP, select = -c(interview_age, subjectkey))
Pedigree <- select(Pedigree, c(src_subject_id = Fam_ID, interview_age = interview_age_child, GroupAssignment, subjectkey = child_guid))

SIDP_Prep <- merge (SIDP, Pedigree, by = "src_subject_id") %>% rename(sex = gender)
SIDP_Prep$sex <- "F"

# Re-code UO Groupassignment 
SIDP_Prep <- SIDP_Prep %>% 
  mutate_at(c("GroupAssignment"),
            funs(recode(., "Assigned Group 3 (HC)" = "Healthy", 
                        'Assigned Group 2 (FSU)' = "NO DBT",
                        'Assigned Group 1 (DBT)' = "DBT")))


# Add empty line in original NDA file for merge
# NDA_SIDP[1,] <- NA
# Recreate first line in original NDA file
NDA_SIDP <- rbind(NDA_SIDP, SIDP_Prep)
first_line <- matrix("", nrow = 1, ncol = ncol(NDA_SIDP))
first_line[,1] <- "sidp"
# assign the second cell in first_line as dccs
first_line[,2] <- "1"

# NDA output ####
# Create a new file in folder called dccs.csv, and put first line into this file
# dccs.csv file will be saved into same folder as current r script
write.table(first_line, file = "NDA Upload/sidp01.csv", sep = ",", append = FALSE, quote = FALSE, na = "", col.names = FALSE, row.names = FALSE)

# Append data in NDA_DCCS into dccs.csv file 
write.table(NDA_SIDP, file = 'NDA Upload/sidp01.csv', sep = ",", append = TRUE, na = "", quote = FALSE, row.names = FALSE)
