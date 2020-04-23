# Measure: AAQ | Author: Bryan | Lasted Edited: 4/22/2020 By: Bryan

# Import Packages Needed
library(dplyr)
library(tidyverse)
library(eeptools)

# Import Pedigree and NDA Structure
Pedigree <- read.csv("Reference_Pedigree.csv")
NDA_AAQ <- read.csv("acceptance01_template.csv")

# Import AAQ Files 
UO_T1_AAQ <- read.csv("UO_T1_Qualtrics.csv", stringsAsFactors = FALSE)
UPMC_T1_AAQ <- read.csv("UPMC_T1_AAQ.csv", stringsAsFactors = FALSE)
UO_T2_AAQ <- read.csv("UO_T2_Qualtrics.csv", stringsAsFactors = FALSE)
UPMC_T2_AAQ <- read.csv("UPMC_T2_AAQ.csv", stringsAsFactors = FALSE)
UO_T3_AAQ <- read.csv("UO_T3_Qualtrics.csv", stringsAsFactors = FALSE)
UPMC_T3_AAQ <- read.csv("UPMC_T3_AAQ.csv", stringsAsFactors = FALSE)
UO_T4_AAQ <- read.csv("UO_T4_Qualtrics.csv", stringsAsFactors = FALSE)
UPMC_T4_AAQ <- read.csv("UPMC_T4_AAQ.csv", stringsAsFactors = FALSE)

# Edit UO AAQ Time 1 - 4 to have only the needed items
UO_T1_AAQ <- select(UO_T1_AAQ, FamID = Q221, srm_aaq_01 = Q154_1, srm_aaq_02 = Q154_2, srm_aaq_03 = Q154_3, 
                    srm_aaq_04 = Q154_4, srm_aaq_05 = Q154_5, srm_aaq_06 = Q154_6, srm_aaq_07 = Q154_7, 
                    srm_aaq_08 = Q154_8, srm_aaq_09 = Q154_9, srm_aaq_10 = Q154_10)
UO_T2_AAQ <- select(UO_T2_AAQ, FamID = Q116, srm_aaq_01 = Q154_1, srm_aaq_02 = Q154_2, srm_aaq_03 = Q154_3, 
                    srm_aaq_04 = Q154_4, srm_aaq_05 = Q154_5, srm_aaq_06 = Q154_6, srm_aaq_07 = Q154_7, 
                    srm_aaq_08 = Q154_8, srm_aaq_09 = Q154_9, srm_aaq_10 = Q154_10)
UO_T3_AAQ <- select(UO_T3_AAQ, FamID = Q174, srm_aaq_01 = Q154_1, srm_aaq_02 = Q154_2, srm_aaq_03 = Q154_3, 
                    srm_aaq_04 = Q154_4, srm_aaq_05 = Q154_5, srm_aaq_06 = Q154_6, srm_aaq_07 = Q154_7, 
                    srm_aaq_08 = Q154_8, srm_aaq_09 = Q154_9, srm_aaq_10 = Q154_10)
UO_T4_AAQ <- select(UO_T4_AAQ, FamID = Q203, srm_aaq_01 = Q154_1, srm_aaq_02 = Q154_2, srm_aaq_03 = Q154_3, 
                    srm_aaq_04 = Q154_4, srm_aaq_05 = Q154_5, srm_aaq_06 = Q154_6, srm_aaq_07 = Q154_7, 
                    srm_aaq_08 = Q154_8, srm_aaq_09 = Q154_9, srm_aaq_10 = Q154_10)

# Edit UPMC AAQ Time 1 - 4 to have only the needed items
UPMC_T1_AAQ <- select(UPMC_T1_AAQ, FamID = Q1.2, srm_aaq_01 = Q4.1_1, srm_aaq_02 = Q4.1_2, srm_aaq_03 = Q4.1_3, 
                      srm_aaq_04 = Q4.1_4, srm_aaq_05 = Q4.1_5, srm_aaq_06 = Q4.1_6, srm_aaq_07 = Q4.1_7, srm_aaq_08 = Q4.1_8,
                      srm_aaq_09 = Q4.1_9, srm_aaq_10 = Q4.1_10)
UPMC_T2_AAQ <- select(UPMC_T2_AAQ, FamID = Q1.2, srm_aaq_01 = Q4.1_1, srm_aaq_02 = Q4.1_2, srm_aaq_03 = Q4.1_3, 
                      srm_aaq_04 = Q4.1_4, srm_aaq_05 = Q4.1_5, srm_aaq_06 = Q4.1_6, srm_aaq_07 = Q4.1_7, srm_aaq_08 = Q4.1_8,
                      srm_aaq_09 = Q4.1_9, srm_aaq_10 = Q4.1_10)
UPMC_T3_AAQ <- select(UPMC_T3_AAQ, FamID = Q1.2, srm_aaq_01 = Q4.1_1, srm_aaq_02 = Q4.1_2, srm_aaq_03 = Q4.1_3, 
                      srm_aaq_04 = Q4.1_4, srm_aaq_05 = Q4.1_5, srm_aaq_06 = Q4.1_6, srm_aaq_07 = Q4.1_7, srm_aaq_08 = Q4.1_8,
                      srm_aaq_09 = Q4.1_9, srm_aaq_10 = Q4.1_10)
UPMC_T4_AAQ <- select(UPMC_T4_AAQ, FamID = Q1.2, srm_aaq_01 = Q4.1_1, srm_aaq_02 = Q4.1_2, srm_aaq_03 = Q4.1_3, 
                      srm_aaq_04 = Q4.1_4, srm_aaq_05 = Q4.1_5, srm_aaq_06 = Q4.1_6, srm_aaq_07 = Q4.1_7, srm_aaq_08 = Q4.1_8,
                      srm_aaq_09 = Q4.1_9, srm_aaq_10 = Q4.1_10)

# Bind UO and UPMC AAQ Data By Time Point
AAQ_T1 <- rbind(UO_T1_AAQ, UPMC_T1_AAQ)
AAQ_T2 <- rbind(UO_T2_AAQ, UPMC_T2_AAQ)
AAQ_T3 <- rbind(UO_T3_AAQ, UPMC_T3_AAQ)
AAQ_T4 <- rbind(UO_T4_AAQ, UPMC_T4_AAQ)

# Clean Global Enviorment 
rm(UO_T1_AAQ, UO_T2_AAQ, UO_T3_AAQ, UO_T4_AAQ, UPMC_T1_AAQ, UPMC_T2_AAQ, UPMC_T3_AAQ, UPMC_T4_AAQ)

# Create the Predigree data for each Time Point
Pedigree_T1 <- select(Pedigree, FamID, FamID_Mother, mom_guid, MomGender, Time1Date, MomAge_T1)
Pedigree_T2 <- select(Pedigree, FamID, FamID_Mother, mom_guid, MomGender, Time2Date, MomAge_T2)
Pedigree_T3 <- select(Pedigree, FamID, FamID_Mother, mom_guid, MomGender, Time3Date, MomAge_T3)
Pedigree_T4 <- select(Pedigree, FamID, FamID_Mother, mom_guid, MomGender, Time4Date, MomAge_T4)

# Merge Pedigree data to AAQ Time Points
AAQ_T1 <- merge(Pedigree_T1, AAQ_T1, by = 'FamID')
AAQ_T2 <- merge(Pedigree_T2, AAQ_T2, by = 'FamID')
AAQ_T3 <- merge(Pedigree_T3, AAQ_T3, by = 'FamID')
AAQ_T4 <- merge(Pedigree_T4, AAQ_T4, by = 'FamID')

# Clean Global Enviorment 
rm(Pedigree, Pedigree_T1, Pedigree_T2, Pedigree_T3, Pedigree_T4)

# Create Time Point coloumn in each AAQ Sheet and populate the cell with time point
AAQ_T1$timepoint <- "Time 1"
AAQ_T2$timepoint <- "Time 2"
AAQ_T3$timepoint <- "Time 3"
AAQ_T4$timepoint <- "Time 4"

# Rename each of the AAQ Date and Age coloumns so they match
AAQ_T1 <- AAQ_T1 %>% rename( interview_date = Time1Date, interview_age = MomAge_T1)
AAQ_T2 <- AAQ_T2 %>% rename( interview_date = Time2Date, interview_age = MomAge_T2)
AAQ_T3 <- AAQ_T3 %>% rename( interview_date = Time3Date, interview_age = MomAge_T3)
AAQ_T4 <- AAQ_T4 %>% rename( interview_date = Time4Date, interview_age = MomAge_T4)

# Bind all AAQ Time Points togeather creating the AAQ_Prep sheet
AAQ_Prep <- rbind(AAQ_T1, AAQ_T2, AAQ_T3, AAQ_T4)

# Clean Global Enviorment 
rm(AAQ_T1, AAQ_T2, AAQ_T3, AAQ_T4)

# Recode the strings of text to numbers
AAQ_Prep[AAQ_Prep == "1 Never True"] <- 1; AAQ_Prep[AAQ_Prep == "2 Very Rarely True"] <- 2;
AAQ_Prep[AAQ_Prep == "3 Seldom True"] <- 3; AAQ_Prep[AAQ_Prep == "4 Sometimes True"] <- 4;
AAQ_Prep[AAQ_Prep == "5 Often True"] <- 5; AAQ_Prep[AAQ_Prep == "6 Almost Always True"] <- 6;
AAQ_Prep[AAQ_Prep == "7 Always True"] <- 7

# Change number to numeric values and Create Calculated Column 
AAQ_Prep[,7:16] <- sapply(AAQ_Prep[,7:16],as.numeric)

AAQ_Prep <- add_column(AAQ_Prep, aaq_total = rowSums(AAQ_Prep[, c("srm_aaq_01", "srm_aaq_02","srm_aaq_03","srm_aaq_04", "srm_aaq_05", "srm_aaq_06", 
                                          "srm_aaq_07", "srm_aaq_08", "srm_aaq_09", "srm_aaq_10")]),.after = "srm_aaq_10")

# Reorder the AAQ_Prep sheet 

NDA_AAQ$subjectkey <- pull(AAQ_Prep$FamID_Mother) 
Test<-pull(NDA_AAQ)

NDA<-AAQ_Prep


df$valueBin <- cut(df$value, c(-Inf, 250, 500, 1000, 2000, Inf), 
                   labels=c('<=250', '250-500', '500-1,000', '1,000-2,000', '>2,000'))

#ders <- "ders"
#number_of_question <- ncol(DERS_PREP %>% select(starts_with("ders")))
#number_list <- seq(1:number_of_question)
#DERS_names <- paste(ders,number_list,sep='')

#create list of new header 
#ders <- "srm_ders"
#number_of_survey <- seq(1:36)
#DERS_names <- paste(ders,number_of_survey,sep='_')
#create list of old header name 
#Q137 <- "Q137"
#old_DERS_name <- paste(Q137, number_of_survey,sep = "_")
#change column names 
#setnames(DERS_PREP, old = old_DERS_name, new = DERS_names)


