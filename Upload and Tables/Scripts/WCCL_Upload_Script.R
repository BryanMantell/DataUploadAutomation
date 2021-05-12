# Title: WCCL Upload Script

# Setup
Empty environment, loading library, set knitr and scientific notation
```{r setup}

# import data frame

setwd("~/GitHub/DataUploadAutomation/Upload and Tables/Data")
#source("~/GitHub/DataUploadAutomation/Upload and Tables/Data/Upload Preparation.R")

NDA_WCCL <- read.csv("dbt_wccl01_template.csv", skip = 1)
options(digits = 3)

library(lmSupport)
```

# Prep Sheet
Create prep sheet to begin transferring data into NDA format. Rename relevant GUID information to match NDA specifications. Finally, bind all timepoints into single WCCL Prep Sheet.

```{r Prep Sheet}
WCCL_Prep <- select(Qualtrics, c(Fam_ID,mother_sex, interview_date, interview_age_Mom, GroupAssignment, contains("srm_wccl")))
```
# Re-code and 67% Rule
Convert Likert Scale text input into numerical values then create a dataframe to place IDs that do not have 67% of their data present.

```{r Recode}
#Change Numbers to Numeric values

WCCL_Prep[,6:64] <- sapply(WCCL_Prep[,6:64],as.numeric)
```

```{r Calculated Columns}
# Items for SU
SU <- colnames(select(WCCL_Prep, c("srm_wccl_1", "srm_wccl_2", "srm_wccl_4", "srm_wccl_6", "srm_wccl_9", "srm_wccl_10", "srm_wccl_11", "srm_wccl_13", "srm_wccl_16", "srm_wccl_18", "srm_wccl_19", "srm_wccl_21", "srm_wccl_22", "srm_wccl_23", "srm_wccl_26", "srm_wccl_27", "srm_wccl_29", "srm_wccl_31", "srm_wccl_33", "srm_wccl_34", "srm_wccl_35", "srm_wccl_36", "srm_wccl_38", "srm_wccl_39", "srm_wccl_40", "srm_wccl_42", "srm_wccl_43", "srm_wccl_44", "srm_wccl_47", "srm_wccl_49", "srm_wccl_50", "srm_wccl_51", "srm_wccl_53", "srm_wccl_54", "srm_wccl_56", "srm_wccl_57", "srm_wccl_58", "srm_wccl_59")))

# Items for GSC
GSC <- colnames(select(WCCL_Prep, c("srm_wccl_3", "srm_wccl_5", "srm_wccl_8", "srm_wccl_12", "srm_wccl_14", "srm_wccl_17", "srm_wccl_20", "srm_wccl_25", "srm_wccl_32", "srm_wccl_37", "srm_wccl_41", "srm_wccl_45", "srm_wccl_46", "srm_wccl_52", "srm_wccl_55")))

# Items for BO
BO <- colnames(select(WCCL_Prep, c("srm_wccl_7", "srm_wccl_15", "srm_wccl_24", "srm_wccl_28", "srm_wccl_30", "srm_wccl_48")))

# Calculated Columns 
WCCL_Prep$wccl_SU_raw <- rowMeans(WCCL_Prep[,SU], na.rm = TRUE)

WCCL_Prep$wccl_GSC_raw <- rowMeans(WCCL_Prep[,GSC], na.rm = TRUE)

WCCL_Prep$wccl_BO_raw <- rowMeans(WCCL_Prep[,BO], na.rm = TRUE)

# Mean with 67% Rule#### 

# Check NA Percentage
WCCL_Prep$NACheck <- rowSums(is.na(select(WCCL_Prep, starts_with("srm"))))/ncol(dplyr::select(WCCL_Prep, starts_with("srm")))

# New Mean with 67% Rule 
WCCL_Prep$wccl_SU_cor <- ifelse(WCCL_Prep$NACheck < 0.67, rowMeans(WCCL_Prep[,SU], na.rm = TRUE), "NA")

WCCL_Prep$wccl_GSC_cor <- ifelse(WCCL_Prep$NACheck < 0.67, rowMeans(WCCL_Prep[,GSC], na.rm = TRUE), "NA")

WCCL_Prep$wccl_BO_cor <- ifelse(WCCL_Prep$NACheck < 0.67, rowMeans(WCCL_Prep[,BO], na.rm = TRUE), "NA")

#VarScore columns 
WCCL_Prep <- add_column(WCCL_Prep, WCCL_SU_imputation = varScore(WCCL_Prep, Forward = c("srm_wccl_1", "srm_wccl_2", "srm_wccl_4", "srm_wccl_6", "srm_wccl_9", "srm_wccl_10", "srm_wccl_11", "srm_wccl_13", "srm_wccl_16", "srm_wccl_18", "srm_wccl_19", "srm_wccl_21", "srm_wccl_22", "srm_wccl_23", "srm_wccl_26", "srm_wccl_27", "srm_wccl_29", "srm_wccl_31", "srm_wccl_33", "srm_wccl_34", "srm_wccl_35", "srm_wccl_36", "srm_wccl_38", "srm_wccl_39", "srm_wccl_40", "srm_wccl_42", "srm_wccl_43", "srm_wccl_44", "srm_wccl_47", "srm_wccl_49", "srm_wccl_50", "srm_wccl_51", "srm_wccl_53", "srm_wccl_54", "srm_wccl_56", "srm_wccl_57", "srm_wccl_58", "srm_wccl_59"), MaxMiss = .20),.after = "wccl_BO_cor")

WCCL_Prep <- add_column(WCCL_Prep, WCCL_GSC_imputation = varScore(WCCL_Prep, Forward = c("srm_wccl_3", "srm_wccl_5", "srm_wccl_8", "srm_wccl_12", "srm_wccl_14", "srm_wccl_17", "srm_wccl_20", "srm_wccl_25", "srm_wccl_32", "srm_wccl_37", "srm_wccl_41", "srm_wccl_45", "srm_wccl_46", "srm_wccl_52", "srm_wccl_55"), MaxMiss = .20),.after = "wccl_BO_cor")

WCCL_Prep <- add_column(WCCL_Prep, WCCL_BO_imputation = varScore(WCCL_Prep, Forward = c("srm_wccl_7", "srm_wccl_15", "srm_wccl_24", "srm_wccl_28", "srm_wccl_30", "srm_wccl_48"), MaxMiss = .20),.after = "wccl_BO_cor")
```
```{r NDA Sheet}
# Create NDA structure column names
dbt_wccl <- paste("dbt_wccl", 1:59, sep = "")
NDA_Names <- c(dbt_wccl)

# Create NDA Prep structure 
NDA_WCCL_Prep <- select(WCCL_Prep, c(subjectkey, src_subject_id, interview_date, interview_age_Mom, sex = mother_sex , visit = Timepoint, starts_with("srm")))
setnames(NDA_WCCL_Prep, new_WCCL_names, NDA_Names)

# bind NDA_WCCL_Prep and NDA structure  
NDA_WCCL <- bind_rows(NDA_WCCL, NDA_WCCL_Prep)

# recreate first row of NDA structure
first_line <- matrix("", nrow = 1, ncol = ncol(NDA_WCCL))

NDA_WCCL <- bind_rows(NDA_WCCL, NDA_WCCL_Prep)
first_line <- matrix("", nrow = 1, ncol = ncol(NDA_WCCL))

first_line[,1] <- "dbt_wccl"
first_line[,2] <- "1"
write.table(first_line, file = "dbt_wccl.csv", sep = ",", append = FALSE, quote = FALSE, na = "", col.names = TRUE, row.names = FALSE)
write.table(NDA_WCCL, file = "dbt_wccl.csv", sep = ",", append = FALSE, quote = FALSE, na = "", col.names = TRUE, row.names = FALSE)
```
