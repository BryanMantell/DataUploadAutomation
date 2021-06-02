# title: "AffectPT Upload Script
# author:  Jacob Mulleavey

# Scientific Notation
options(digits = 3)

# Install Package, this only need to be done once.
#install.packages("rlang")
#install.packages("dplyr")
#install.packages(c("tidyverse","data.table","contrib.url","knitr"))
#install.packages('plyr', repos = "http://cran.us.r-project.org")
#install.packages("lmSupport")


# Load packages, this need to be done every time you run this script. 
library(dplyr)
library(tidyverse)
library(data.table)
library(knitr)
library(lmSupport)

# Source data, templates and create NDA dataframe
setwd("/Users/jmulleavey/Documents/GitHub/DataUploadAutomation/Upload and Tables/Data")
getwd()
#setwd("~/Documents/GitHub/DataUploadAutomation/Upload and Tables/Data")
#source("~/GitHub/DataUploadAutomation/Upload and Tables/Data/Upload Preparation.R")

NDA_AffectPT <- read.csv("apt01_template.csv", skip = 1)

# Select the relevant sets of information from RedCap necessary for the AffectPT
AffectPT_Prep <- select(Redcap_Data, c(child_guid, child_famID, interview_date, interview_age_child, child_sex, Timepoint, contains("oc_apt_")))








