---
  title:"Automating the Data Upload - CCNES"
---
  

# Load Library -----------------------------------------------------------------
#empty Global Environment
rm(list=ls())
library(dplyr)
library(data.table)

# set the working directory 
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
NDA_CCNES <- read.csv("pabq01_template.csv", skip=1, stringsAsFactors = TRUE)


# Prep --------------------------------------------------------------------
# Edit UO CCNES Time 1 - 4 to have only CCNES quesions and the FamID.
UO_CCNES_T1 <- select(UO_CCNES_T1, c(FamID = Q221, Timepoint = Q146, Q140_1:Q151_6))    #TODO: double check with Bryan 151 or 150
UO_CCNES_T2 <- select(UO_CCNES_T2, c(FamID = Q116, Timepoint = Q117, Q140_1:Q151_6))
UO_CCNES_T3 <- select(UO_CCNES_T3, c(FamID = Q174, Timepoint = Q176, Q140_1:Q151_6))
UO_CCNES_T4 <- select(UO_CCNES_T4, c(FamID = Q203, Timepoint = Q206, Q140_1:Q151_6))

# Edit UPMC CCNES Time 1 - 4 to have only CCNES quesions and the FamID.
UPMC_CCNES_T1 <- select(UPMC_CCNES_T1, c(FamID = Q1.2, Q10.2_1:Q10.13_6))
UPMC_CCNES_T2 <- select(UPMC_CCNES_T2, c(FamID = Q1.2, Q8.2_1:Q8.13_6))  #TODO: double check with Bryan
UPMC_CCNES_T3 <- select(UPMC_CCNES_T3, c(FamID = Q1.2, Q8.2_1:Q8.13_6))  #TODO: double check with Bryan
UPMC_CCNES_T4 <- select(UPMC_CCNES_T4, c(FamID = Q1.2, Q10.2_1:Q10.13_6))

# Create Time Point coloumn in each UPMC Sheet
UPMC_CCNES_T1$Timepoint <- 1
UPMC_CCNES_T2$Timepoint <- 2
UPMC_CCNES_T3$Timepoint <- 3
UPMC_CCNES_T4$Timepoint <- 4

# Select revelent pedigree information 
Pedigree <- select(Pedigree, FamID, FamID_Mother, mom_guid, MomGender, interview_date = Time1Date, interview_age = MomAge_T1)

# Create list of new variable names 
new_CCNES_names <- sprintf("srm_ccnes_%02d",1:72)
# Adding r at end of variable which needed to be reversed
new_CCNES_names[c(7,39,45,55)]<-paste(new_CCNES_names[c(7,39,45,55)],"r", sep = "")


# Create list of old variable names so we can replace them with the new ones 

# Create an empty list
odd_UO_CCNES_names <-c()
# for each item in UO paste number 1 to 6
# sprintf used to formate str
for (i in sprintf("Q%03d",140:151)){
  name <- paste(i, 1:6, sep = "_")
  odd_UO_CCNES_names <- c(odd_UO_CCNES_names, name)
}

# Create list of UPMC bariable names 
odd_UPMC_CCNES_names <-c()
for (i in sprintf("Q10.%d",2:13)) {
  Name <- paste (i, 1:6, sep = "_")
  odd_UPMC_CCNES_names <- c(odd_UPMC_CCNES_names, Name)
}

# Create second list of UPMC variable names 
odd_UPMC_CCNES_names2 <-c()
for (i in sprintf("Q8.%d",2:13)) {
  Name <- paste (i, 1:6, sep = "_")
  odd_UPMC_CCNES_names2 <- c(odd_UPMC_CCNES_names2, Name)
}



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

# # Bind UO and UPMC AAQ Data By Time Point
# CCNES_T1 <- rbind(UO_CCNES_T1, UPMC_CCNES_T1)
# CCNES_T2 <- rbind(UO_CCNES_T2, UPMC_CCNES_T2)
# CCNES_T3 <- rbind(UO_CCNES_T3, UPMC_CCNES_T3)
# CCNES_T4 <- rbind(UO_CCNES_T4, UPMC_CCNES_T4)
# 
# # Clean Global Enviorment 
# rm(UO_CCNES_T1, UO_CCNES_T2, UO_CCNES_T3, UO_CCNES_T4, UPMC_CCNES_T1, UPMC_CCNES_T2, UPMC_CCNES_T3, UPMC_CCNES_T4)

# Bind UO and UPMC data
CCNES_PREP <- rbind(UO_CCNES_T1,UO_CCNES_T2,UO_CCNES_T3,UO_CCNES_T4)


# Merge Predigree and CCNES_PREP
CCNES_PREP <- merge(Pedigree, CCNES_PREP, by = "FamID")

# Clean Flobal Enviorment
rm(UO_CCNES_T1, UO_CCNES_T2, UO_CCNES_T3, UO_CCNES_T4, UPMC_CCNES_T1, UPMC_CCNES_T2, UPMC_CCNES_T3, UPMC_CCNES_T4)


# Recode the strings of text to numbers
#TODO: Prefer not to answer now as NA?
CCNES_PREP <- CCNES_PREP %>% 
  mutate_at(new_CCNES_names,
            funs(recode(., "1 - Very Unlikely" = 1, 
                        '2' = 2,
                        '3' = 3,
                        '4 - Medium Liklihood' = 4,
                        '5' = 5,
                        '6' = 6,
                        '7 - Very Likely'= 7,.default = NaN)))

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



# Calculated Columns
CCNES_PREP$ccnes_DR <- rowMeans(CCNES_PREP[,c("srm_ccnes_02", "srm_ccnes_07r", "srm_ccnes_13", 
                                              "srm_ccnes_22", "srm_ccnes_29", "srm_ccnes_33", 
                                              "srm_ccnes_39r", "srm_ccnes_45r", "srm_ccnes_50", 
                                              "srm_ccnes_55r", "srm_ccnes_62", "srm_ccnes_70")], na.rm = TRUE)

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





#still working on .. 
# NDA column names
pabq<-paste("pabq",1:12, sep = "")

NDA_Names <-c()
for (i in pabq) {
  Name <- paste (i, letters[seq(1:6)], sep = "")
  NDA_Names <- c(NDA_Names, Name)
}

NDA_Names_Org<-names(NDA_CCNES)
# Rename to NDA name
setnames(CCNES_PREP, new_CCNES_names, NDA_Names)

NDA_CCNES<-NDA_CCNES%>%
  mutate_at(NDA_Names,NDA_CCNES<-CCNES_PREP)

NDA_CCNES <- 
  rbind(CCNES_PREP,NDA_CCNES)
nes<-right_join(CCNES_PREP,NDA_CCNES,by=NULL,copy=FALSE, suffix=c("x","y"))

a <- c(1,2,3,4,NaN)
b <- c(1,2,3,4)
sum(a)
mean(a)
