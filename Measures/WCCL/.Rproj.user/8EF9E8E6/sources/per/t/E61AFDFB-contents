# creating new variable names 
wccl <- "srm_wccl"
> num_items <- seq(1:59)
> new_WCCL_names <- paste(wccl, num_items, sep = "_")
> UO_Q155 <- "Q155"
> old_UO_WCCL_names <- paste(UO_Q155, num_items, sep = "_")
> setnames(UO_T1_Qualtrics, old_UO_WCCL_names, new_WCCL_names)
> 
  setnames(UO_T2_Qualtrics, old_UO_WCCL_names, new_WCCL_names)
setnames(UO_T3_Qualtrics, old_UO_WCCL_names, new_WCCL_names)
> setnames(UO_T4_Qualtrics, old_UO_WCCL_names, new_WCCL_names)









UPMC_Q5 <- "Q5.1"
> old_UPMC_WCCL_names <- paste(UPMC_Q5, num_items, sep = "_")
> setnames(UPMC_T1_WCCL, old_UPMC_WCCL_names, new_WCCL_names)

> setnames(UPMC_T2_WCCL, old_UPMC_WCCL_names, new_WCCL_names)
> setnames(UPMC_T3_WCCL, old_UPMC_WCCL_names, new_WCCL_names)
> setnames(UPMC_T4_WCCL, old_UPMC_WCCL_names, new_WCCL_names)
> View(UPMC_T4_WCCL)

> #edit UO WCCL time 1-4 to have only WCCL questions and fam ID 
  
  > UO_T1_WCCL <- select(UO_T1_Qualtrics, c(FamID=Q221, contains(wccl)))

> UO_T2_WCCL <- select(UO_T2_Qualtrics, c(FamID=Q116, contains(wccl)))
> UO_T3_WCCL <- select(UO_T3_Qualtrics, c(FamID=Q174, contains(wccl)))
> UO_T4_WCCL <- select(UO_T4_Qualtrics, c(FamID=Q203, contains(wccl)))

> #Edit UPMC T1-4 so only WCCL and FamID are left
  
  > UPMC_T1_WCCL <- select(UPMC_T1_WCCL, c(FamID=Q1.2, contains(wccl)))
> UPMC_T2_WCCL <- select(UPMC_T2_WCCL, c(FamID=Q1.2, contains(wccl)))
> UPMC_T3_WCCL <- select(UPMC_T3_WCCL, c(FamID=Q1.2, contains(wccl)))
> UPMC_T4_WCCL <- select(UPMC_T4_WCCL, c(FamID=Q1.2, contains(wccl)))

> #tidy workspace
  > rm(UO_T1_Qualtrics)
> rm(UO_T2_Qualtrics, UO_T3_Qualtrics, UO_T4_Qualtrics)

> #Binding UPMC And UO by time point
  > WCCL_T1 <- rbind(UO_T1_WCCL, UPMC_T1_WCCL)
> WCCL_T2 <- rbind(UO_T2_WCCL, UPMC_T2_WCCL)
> WCCL_T3 <- rbind(UO_T3_WCCL, UPMC_T3_WCCL)
> WCCL_T4 <- rbind(UO_T4_WCCL, UPMC_T4_WCCL)

#setup Pedigree data by time point
> Pedigree_T1 <- select(Pedigree, FamID, FamID_Mother, mom_guid, MomGender, Time1Date, MomAge_T1)
> Pedigree_T2 <- select(Pedigree, FamID, FamID_Mother, mom_guid, MomGender, Time2Date, MomAge_T2)
> Pedigree_T3 <- select(Pedigree, FamID, FamID_Mother, mom_guid, MomGender, Time3Date, MomAge_T3)
> Pedigree_T4 <- select(Pedigree, FamID, FamID_Mother, mom_guid, MomGender, Time4Date, MomAge_T4)

#merge Pedigree and WCCL by time point

WCCL_T1 <- merge(Pedigree_T1, WCCL_T1, by = 'FamID')
> WCCL_T2 <- merge(Pedigree_T2, WCCL_T2, by = 'FamID')
> WCCL_T3 <- merge(Pedigree_T3, WCCL_T3, by = 'FamID')
> WCCL_T4 <- merge(Pedigree_T4, WCCL_T4, by = 'FamID')

#add time point column/populate with corresponding time point 
WCCL_T1$timepoint <- "Time 1"
> WCCL_T2$timepoint <- "Time 2"
> WCCL_T3$timepoint <- "Time 3"
> WCCL_T4$timepoint <- "Time 4"
#rename columns so they match across datasets
> WCCL_T1 <- WCCL_T1 %>% rename( interview_date = Time1Date, interview_age = MomAge_T1)
> WCCL_T2 <- WCCL_T2 %>% rename( interview_date = Time2Date, interview_age = MomAge_T2)
> WCCL_T3 <- WCCL_T3 %>% rename( interview_date = Time3Date, interview_age = MomAge_T3)
> WCCL_T4 <- WCCL_T4 %>% rename( interview_date = Time4Date, interview_age = MomAge_T4)

#Create WCCL_prep and merge datasets 

WCCL_PREP <- rbind(WCCL_T1, WCCL_T2, WCCL_T3, WCCL_T4)
