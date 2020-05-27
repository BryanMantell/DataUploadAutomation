---
  title:"Automating the Data Upload -DimensionalCardSort"
  Author:"Min Zhang" 
---
  
  
  # Load Library -----------------------------------------------------------------
#empty Global Environment
rm(list=ls())
library(dplyr)
library(data.table)
library(gtools)


# set the working directory 
setwd("~/Documents/Min/Coding/DataUploadAutomation/Measures/DimensionalCardSort")

Pedigree <- read.csv("Reference_Pedigree.csv")
Redcap_Data <- read.csv("Redcap_Data.csv")
NDA_DCCS <- read.csv("dccs01_template.csv", skip=1)


# Create NDA column names
NDA_names <-c()
# for each item in UO paste number 1 to 6
# sprintf used to formate str
for (i in 1:2){
  Name <- paste("dccs_shape_instr",i, sep = "")
  NDA_names <- c(NDA_names, Name)
}


