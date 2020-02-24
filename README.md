---

---

# ![](Images/Logo.PNG) 

# **Automating the Data Upload**

The [National Data Archive](#Help-Section) (NDA) needs the following [measures](#Help-Section) to be uploaded every 6 months, due July 15th and January 15th. This is a project aimed at automating the process in [R](#Help-Section) through manipulating excel files. We'll be [mapping](#Help-Section) certain columns in one excel sheet to a column in a different excel sheet. This is needed because question 1 of one of our measures may not be question 1 in the NDA provided [structure](#Help-Section). Each person will be responsible for writing a [function](#Help-Section) in R that meets the requirements of their measure. I have already written you a [skeleton function](#Help-Section) which will need to be filled in. Each measure will have specific detailed instructions and an [Item matching chart](#Help-Section) that will serve as your guide. Read through the [Getting Starting](#Getting-Started) section below to make sure you have everything you need. After that, you can use the table of contents below to click on your assigned measure and get started. For more information and an explanation for highlighted words see the [Help Section](#Help-Section) at the bottom of the page.

## Table of Contents

| Measures               | Assigned To... | Status      |
| ------------------------- | ------ | ----------- |
| [Pedigree](#Research-Subject-Pedigree) | Bryan | In Progress |
| [SCID](#Structured-Clinical-Interview-for-DSM-V---SCID) |Arianna|In Progress |
| [SID-P](#Structured-Interview-for-DSM-IV-Personality---SID-P) | Arianna | In Progress |
| [PPVT](#Peabody-Picture-Vocabulary-Test---PPVT) | Bryan | In Progress |
| [DERS](#Difficulties-in-Emotion-Regulation-Scale---DERS) | Bryan | In Progress |
| [CBCL](#Child-Behavior-Checklist---CBCL) | Kyle | In Progress |
| [CCNES](#Coping-with-Children's-Negative-Emotions-Scale---CCNES) | Min | In Progress |
| [AAQ](#Acceptance-and-Action-Questionnaire---AAQ) | Austin | In Progress |
| [WCCL](#Ways-of-Coping-Checklist---WCCL) | TBD | In Progress |
| [PKBS](#Preschool-and-Kindergarten-Behavior-Scale---PKBS) | TBD | In Progress |
| [Bear Dragon](#Bear-Dragon)             | Amanda | In Progress |
| [Affect Perspective Taking](Affect-Perspective-Taking) | Bryan | In Progress |
| [Dimensional Card Sort](#Dimensional-Card-Sort) | Jake | In Progress |
| [Emotion Labeling](#Emotion-Labeling) | Deonna | In Progress |
| [Emotion Strategies](#Emotion-Strategies) | Alexis | In Progress |

---

# **Getting Started**

***Things You'll Need And How To Get It:*** 

- **R** is a programming language. Download it [here](https://cloud.r-project.org/).
- **Rstudio** is the software we'll use to code in R. You download it [here](http://bit.ly/DownloadRstudio).
- **GitHub Desktop** is how we will download and upload our code in a centralized place. Download it [here](https://desktop.github.com/).
- **Google.com** is your best friend while coding. Try to work through errors and find simpler ways to do things!

---

# **Research Subject Pedigree**

The Pedigree is a collection of identifiable information that needs to be appended to every measure. 

## SCID instructions:

[Back to Table of Contents](#Table-of-Contents)

---

# **Structured Clinical Interview for DSM-V - SCID**

The Structured Clinical Interview for DSM‐5(SCID‐5) is a semi-structured interview guide for making the major DSM‐5 diagnoses.

## SCID instructions:



[Back to Table of Contents](#Table-of-Contents)

---

# **Structured Interview for DSM IV Personality - SID-P**

The Structured Clinical Interview for DSM-4 is a guide for making personality disorder diagnoses. 

## SID-P instructions:



[Back to Table of Contents](#Table-of-Contents)

---

# **Peabody Picture Vocabulary Test - PPVT**

The Peabody Picture Vocabulary Test is an untimed test of receptive vocabulary for Standard American English and is intended to provide a quick estimate of the examinee's receptive vocabulary ability.

## PPVT instructions:



[Back to Table of Contents](#Table-of-Contents)

---

# **Difficulties in Emotion Regulation Scale - DERS**

The DERS is a classroom observation tool that measures environmental and behavioral qualities proven to support those outcomes— for any developmental educational model, not just Montessori.

## DERS instructions: 

### 1) Importing

Install all the [packages](#Help-Section) required for the project. You can find what's needed in the [Help Section](#Help-Section). 

Read in all the CSVs needed. The files you'll need are located in your measure's folder. Check the [Help Section](#Help-Section) for example code.


### 2) Editing and Renaming

Edit and rename the Pedigree so that it only has the information needed for the NDA structure. Name it MeasureName_prep because this will be used to prepare everything before you do the final move to the NDA structure. The measure will need the following from the pedigree:

mom guid, mom famID, interview age, interview date, sex.

Next, we need to take all UO and UPMC data from all time points and add it to the MeasureName_prep data frame. Before merging you'll need to rename the column headers, meaning you'll need to rename the UO and UPMC Qualtrics questions to look like this: "ders001". See the item matching chart for an example of what the questions will looks like for this measure.

Once that's complete add a column named "visit"  and append it to the end. Populate the visit column with 1s representing that the row is from time point 1. Repeat this step for time 2, time 3, and time 4, changing the visit number respectively. 

Lastly, append "_mother" to the end of every mom_famID. 

### 3) Recoding Text to Numbers and Reverse Scoring:

Take the following text strings and turn them into integers using the key below.

| Text String         | Integer |
| :------------------ | :------ |
| almost never        | 1       |
| sometimes           | 2       |
| about half the time | 3       |
| most of the time    | 4       |
| almost always       | 5       |

Take the following question items and reverse score them as the chart indicates.

| Question Number |        New Value        |
| :-------------: | :---------------------: |
|     ders001     | 1=5, 2=4, 3=3, 4=2. 5=1 |
|     ders002     | 1=5, 2=4, 3=3, 4=2. 5=1 |
|     ders006     | 1=5, 2=4, 3=3, 4=2. 5=1 |
|     ders007     | 1=5, 2=4, 3=3, 4=2. 5=1 |
|     ders008     | 1=5, 2=4, 3=3, 4=2. 5=1 |
|     ders010     | 1=5, 2=4, 3=3, 4=2. 5=1 |
|     ders017     | 1=5, 2=4, 3=3, 4=2. 5=1 |
|     ders020     | 1=5, 2=4, 3=3, 4=2. 5=1 |
|     ders022     | 1=5, 2=4, 3=3, 4=2. 5=1 |
|     ders024     | 1=5, 2=4, 3=3, 4=2. 5=1 |
|     ders034     | 1=5, 2=4, 3=3, 4=2. 5=1 |

### 4) Create calculated Columns

Insert the following columns at the end of your MeasureName_Prep sheet:

1. Column **ders_awareness:** The scoring for ders_awareness is the **SUM** of these items: 

   ```
   ders002, ders006, ders008, ders010, ders017, ders034 
   ```

2. Column **ders_clarity:** The scoring for ders_clarity is the **SUM** of these items:

   ```
   ders001, ders004, ders005, ders007, ders009
   ```

3. Column **ders_goals**: The scoring for ders_goals is the **SUM** of these items:

   ```
   ders013, ders018, ders020, ders026, ders033
   ```

4. Column **ders_impulse**: The scoring for ders_impulse is the **SUM** of these items:

   ```
   ders003, ders014, ders019, ders024, ders027, ders032
   ```

5. Column **ders_nonacceptance**: The scoring for ders_nonacceptance is the **SUM** of these items:

   ```
   ders011, ders012, ders021, ders023, ders025, ders029
   ```

6. Column **ders_strategies**: The scoring for ders_strategies is the **SUM** of these items:

   ```
   ders015, ders016, ders022, ders028, ders030, ders031, ders035, ders036
   ```

7. Column **ders_total:** The scoring for ders_total is the **SUM** of these items:

   ```
   ders001, ders002, ders003, ders004, ders005, ders006, ders007, ders008, ders009, ders010, ders011, ders012, ders013, ders014, ders015, ders016, ders017, ders018, ders019, ders020, ders021, ders022, ders023, ders024, ders025, ders026, ders027, ders028, ders029, ders030, ders031, ders032, ders033, ders034, ders035, ders036  
   ```

### 5) Add to the NDA Structure 

Now that your prep sheet is complete and contain all the columns as indicated in the Item matching chart move the columns into the NDA structure. 

## DERS Item Matching Chart:

| *UPMC* **Qualtrics Question Number:** | *UO* **Qualtrics Question Number:** | DERS Prep Sheet:   | ***NDA* Data Structure:** |
| ------------------------------------- | ----------------------------------- | ------------------ | ------------------------- |
| N/A                                   | N/A                                 | mom_guid           | subjectkey                |
| Q1.2                                  | famID                               | mom_famID          | src_subject_id            |
| N/A                                   | N/A                                 | interview_age      | interview_age             |
| N/A                                   | N/A                                 | interview_date     | interview_date            |
| N/A                                   | N/A                                 | sex                | sex                       |
| N/A                                   | N/A                                 | timepoint          | visit                     |
| Q6.1_1                                | Q137_1                              | ders001            | ders1                     |
| Q6.1_2                                | Q137_2                              | ders002            | ders2                     |
| Q6.1_3                                | Q137_3                              | ders003            | ders3                     |
| Q6.1_4                                | Q137_4                              | ders004            | ders4                     |
| Q6.1_5                                | Q137_5                              | ders005            | ders5                     |
| Q6.1_6                                | Q137_6                              | ders006            | ders6                     |
| Q6.1_7                                | Q137_7                              | ders007            | ders7                     |
| Q6.1_8                                | Q137_8                              | ders008            | ders8                     |
| Q6.1_9                                | Q137_9                              | ders009            | ders9                     |
| Q6.1_10                               | Q137_10                             | ders010            | ders10                    |
| Q6.1_11                               | Q137_11                             | ders011            | ders11                    |
| Q6.1_12                               | Q137_12                             | ders012            | ders12                    |
| Q6.1_13                               | Q137_13                             | ders013            | ders13                    |
| Q6.1_14                               | Q137_14                             | ders014            | ders14                    |
| Q6.1_15                               | Q137_15                             | ders015            | ders15                    |
| Q6.1_16                               | Q137_16                             | ders016            | ders16                    |
| Q6.1_17                               | Q137_17                             | ders017            | ders17                    |
| Q6.1_18                               | Q137_18                             | ders018            | ders18                    |
| Q6.1_19                               | Q137_19                             | ders019            | ders19                    |
| Q6.1_20                               | Q137_20                             | ders020            | ders20                    |
| Q6.1_21                               | Q137_21                             | ders021            | ders21                    |
| Q6.1_22                               | Q137_22                             | ders022            | ders22                    |
| Q6.1_23                               | Q137_23                             | ders023            | ders23                    |
| Q6.1_24                               | Q137_24                             | ders024            | ders24                    |
| Q6.1_25                               | Q137_25                             | ders025            | ders25                    |
| Q6.1_26                               | Q137_26                             | ders026            | ders26                    |
| Q6.1_27                               | Q137_27                             | ders027            | ders27                    |
| Q6.1_28                               | Q137_28                             | ders028            | ders28                    |
| Q6.1_29                               | Q137_29                             | ders029            | ders29                    |
| Q6.1_30                               | Q137_30                             | ders030            | ders30                    |
| Q6.1_31                               | Q137_31                             | ders031            | ders31                    |
| Q6.1_32                               | Q137_32                             | ders032            | ders32                    |
| Q6.1_33                               | Q137_33                             | ders033            | ders33                    |
| Q6.1_34                               | Q137_34                             | ders034            | ders34                    |
| Q6.1_35                               | Q137_35                             | ders035            | ders35                    |
| Q6.1_36                               | Q137_36                             | ders036            | ders36                    |
| N/A                                   | N/A                                 | ders_awareness     | ders_awareness            |
| N/A                                   | N/A                                 | ders_clarity       | ders_clarity              |
| N/A                                   | N/A                                 | ders_goals         | ders_goals                |
| N/A                                   | N/A                                 | ders_impulse       | ders_impulse              |
| N/A                                   | N/A                                 | ders_nonacceptance | ders_nonacceptance        |
| N/A                                   | N/A                                 | ders_strategies    | ders_strategies           |
| N/A                                   | N/A                                 | ders_total         | ders_total                |

[Back to Table of Contents](#Table-of-Contents)

---

# **Child Behavior Checklist - CBCL**

The Child Behavior Checklist (CBCL) is a checklist parents complete to detect emotional and behavioral problems in children and adolescents.

## CBCL instructions: 

### 1) Importing

Install all the [packages](#Help-Section) required for the project. You can find what's needed in the [Help Section](#Help-Section). 

Read in all the CSVs needed. The files you'll need are located in your measure's folder. Check the [Help Section](#Help-Section) for example code.


### 2) Editing and Renaming

Edit and rename the Pedigree so that it only has the information needed for the NDA structure. Name it MeasureName_prep because this will be used to prepare everything before you do the final move to the NDA structure. The measure will need the following from the pedigree:

child guid, child famID, interview age, interview date, sex.

Next, we need to take all UO and UPMC data from all time points and add it to the MeasureName_prep data frame. Before merging you'll need to rename the column headers, meaning you'll need to rename the UO and UPMC Qualtrics questions to look like this: "cbcl001". See the item matching chart for an example of what the questions will looks like for this measure.

Once that's complete add a column named "visit"  and append it to the end. Populate the visit column with 1s representing that the row is from time point 1. Repeat this step for time 2, time 3, and time 4, changing the visit number respectively. 

Lastly, append "_child" to the end of every mom_famID. 

### 3) Recoding Text to Numbers and Reverse Scoring:

Take the following text strings and turn them into integers using the key below.

| Text String                | Integer |
| :------------------------- | :------ |
| Not True                   | 0       |
| Somewhat or sometimes true | 1       |
| Very true or often true    | 2       |

### 4) Create calculated Columns

Insert the following columns at the end of your MeasureName_Prep sheet:

1. Column **cbcl_ER:** The scoring for cbcl_ER is the **SUM** of these items: 

   ```R
   CBCL021, CBCL046, CBCL051, CBCL079, CBCL082, CBCL083, CBCL092, CBCL097, CBCL099
   ```

2. Column **cbcl_AD:** The scoring for cbcl_AD is the **SUM** of these items:

   ```R
   CBCL010, CBCL033, CBCL037, CBCL043, CBCL047, CBCL068, CBCL087, CBCL090
   ```

3. Column **cbcl_SC:** The scoring for cbcl_SC is the **SUM** of these items:

   ```R
   CBCL001, CBCL007, CBCL012, CBCL019, CBCL024, CBCL039, CBCL045, CBCL052, CBCL078, CBCL086, CBCL093
   ```

4. Column **cbcl_W:** The scoring for cbcl_W is the **SUM** of these items:

   ```R
   CBCL002, CBCL004, CBCL023, CBCL062, CBCL067, CBCL070, CBCL071, CBCL098
   ```

5. Column **cbcl_SP:** The scoring for cbcl_SP is the **SUM** of these items:

   ```R
   CBCL022, CBCL038, CBCL048, CBCL064, CBCL074, CBCL084
   ```

6. Column **cbcl_AP:** The scoring for cbcl_AP is the **SUM** of these items:

   ```R
   CBCL005, CBCL006, CBCL056, CBCL059, CBCL095
   ```

7. Column **cbcl_AB:** The scoring for cbcl_AB is the **SUM** of these items:

   ```R
   CBCL008, CBCL015, CBCL016, CBCL018, CBCL020, CBCL027, CBCL029, CBCL035, CBCL040, CBCL042, CBCL044, CBCL053, CBCL058, CBCL066, CBCL069, CBCL081, CBCL085, CBCL088, CBCL096
   ```

8. Column **cbcl_OP:** The scoring for cbcl_OP is the **SUM** of these items:

   ```R
   CBCL003, CBCL009, CBCL011, CBCL013, CBCL014, CBCL017, CBCL025, CBCL026, CBCL028, CBCL030, CBCL031, CBCL032, CBCL034, CBCL036, CBCL041, CBCL049, CBCL050, CBCL054, CBCL055, CBCL057, CBCL060, CBCL061, CBCL063, CBCL065, CBCL072, CBCL073, CBCL075, CBCL076, CBCL077, CBCL080, CBCL089, CBCL091, CBCL094
   ```

9. Column **cbcl_INT:** The scoring for cbcl_INT is the **SUM** of these items:

   ```R
   CBCL021, CBCL046, CBCL051, CBCL079, CBCL082, CBCL083, CBCL092, CBCL097, CBCL099, CBCL010, CBCL033, CBCL037, CBCL043, CBCL047, CBCL068, CBCL087, CBCL090, CBCL001, CBCL007, CBCL012, CBCL019, CBCL024, CBCL039, CBCL045, CBCL052, CBCL078, CBCL086, CBCL093, CBCL002, CBCL004, CBCL023, CBCL062, CBCL067, CBCL070, CBCL071, CBCL098
   ```

10. Column **cbcl_EXT:** The scoring for cbcl_EXT is the **SUM** of these items:

    ```R
    CBCL005, CBCL006, CBCL056, CBCL059, CBCL095, CBCL008, CBCL015, CBCL016, CBCL018, CBCL020, CBCL027, CBCL029, CBCL035, CBCL040, CBCL042, CBCL044, CBCL053, CBCL058, CBCL066, CBCL069, CBCL081, CBCL085, CBCL088, CBCL096
    ```

11. Column **cbcl_total:** The scoring for cbcl_total is the **SUM** of these items:

    ```R
    CBCL001, CBCL002, CBCL003, CBCL004, CBCL005, CBCL006, CBCL007, CBCL008, CBCL009, CBCL010, CBCL011, CBCL012, CBCL013, CBCL014, CBCL015, CBCL016, CBCL017, CBCL018, CBCL019, CBCL020, CBCL021, CBCL022, CBCL023, CBCL024, CBCL025, CBCL026, CBCL027, CBCL028, CBCL029, CBCL030, CBCL031, CBCL032, CBCL033, CBCL034, CBCL035, CBCL036, CBCL037, CBCL038, CBCL039, CBCL040, CBCL041, CBCL042, CBCL043, CBCL044, CBCL045, CBCL046, CBCL047, CBCL048, CBCL049, CBCL050, CBCL051, CBCL052, CBCL053, CBCL054, CBCL055, CBCL056, CBCL057, CBCL058, CBCL059, CBCL060, CBCL061, CBCL062, CBCL063, CBCL064, CBCL065, CBCL066, CBCL067, CBCL068, CBCL069, CBCL070, CBCL071, CBCL072, CBCL073, CBCL074, CBCL075, CBCL076, CBCL077, CBCL078, CBCL079, CBCL080, CBCL081, CBCL082, CBCL083, CBCL084, CBCL085, CBCL086, CBCL087, CBCL088, CBCL089, CBCL090, CBCL091, CBCL092, CBCL093, CBCL094, CBCL095, CBCL096, CBCL097, CBCL098, CBCL099
    ```


### 5) Add to the NDA Structure 

Now that your prep sheet is complete and contains all the columns as indicated in the Item matching chart, move the columns into the NDA structure. 

## CBCL Item Matching Chart:

| *UPMC* **Qualtrics Question Number:** | *UO* **Qualtrics Question Number:** | CBCL Prep Sheet | ***NDA* Data Structure:** |
| ------------------------------------- | ----------------------------------- | ----------------------- | ----------------------- |
| N/A | N/A | child_guid | subjectkey |
| Q1.2 | famID | child_FamID | src_subject_id |
| N/A | N/A | sex | sex |
| N/A | N/A | interview_age | interview_age |
| N/A | N/A | interview_date | interview_date |
| N/A | N/A | relationship | relationship |
| N/A | N/A | timepoint | visit |
| Q15.1_1                                | Q264_1                            | cbcl001         | cbcl56a                 |
| Q15.1_2                                | Q264_2                             | cbcl002           | cbcl1                   |
| Q15.1_3                                | Q264_3                             | cbcl003         | cbcl_nt                 |
| Q15.1_4                                | Q264_4                             | cbcl004        | cbcl_eye                |
| Q15.1_5                                | Q264_5                             | cbcl005           | cbcl8                   |
| Q15.1_6                                | Q264_6                             | cbcl006          | cbcl10                  |
| Q15.1_7                                | Q264_7                             | cbcl007        | cbcl_out                |
| Q15.1_8                                | Q264_8                            | cbcl008       | cbcl_wait               |
| Q15.1_9                                | Q264_9                             | cbcl009       | cbcl_chew               |
| Q15.1_10                                | Q264_10                            | cbcl010         | cbcl11                  |
| Q15.1_11                                | Q264_11                            | cbcl011      | cbcl_help               |
| Q15.1_12                                | Q264_12                            | cbcl012         | cbcl49                  |
| Q15.1_13                                | Q264_13                            | cbcl013       | cbcl14                  |
| Q15.1_14                                | Q264_14                            | cbcl014         | cbcl15                  |
| Q15.1_15                                | Q264_15                            | cbcl015   | cbcl_defiant            |
| Q15.1_16                                | Q264_16                            | cbcl016       | cbcl_dem                |
| Q15.1_17                                | Q264_17                            | cbcl017         | cbcl20                  |
| Q15.1_18                                | Q264_18                            | cbcl018         | cbcl21                  |
| Q15.1_19                                | Q264_19                            | cbcl019      | cbcl_diar               |
| Q15.1_20                                | Q264_20                            | cbcl020     | cbcl_disob              |
| Q15.1_21                                | Q264_21                            | cbcl021      | cbcl_dist               |
| Q15.1_22                                | Q264_22                            | cbcl022 | cbcl_alonsleep          |
| Q15.1_23                                | Q264_23                            | cbcl023    | cbcl_answer             |
| Q15.1_24                                | Q264_24                            | cbcl024         | cbcl24                  |
| Q15.1_25                                | Q264_25                            | cbcl025         | cbcl25                  |
| Q15.1_26                                | Q264_26                            | cbcl026       | cbcl_fun                |
| Q15.1_27                                | Q264_27                            | cbcl027         | cbcl26                  |
| Q15.1_28                                | Q264_28                            | cbcl028      | cbcl_home               |
| Q15.1_29                                | Q264_29                            | cbcl029     | cbcl_frust              |
| Q15.1_30                                | Q264_30                            | cbcl030         | cbcl27                  |
| Q15.1_31                                | Q264_31                            | cbcl031       | cbcl_eat                |
| Q15.1_32                                | Q264_32                            | cbcl032         | cbcl29                  |
| Q15.1_33                                | Q264_33                            | cbcl033      | cbcl_feel               |
| Q15.1_34                                | Q264_34                            | cbcl034         | cbcl36                  |
| Q15.1_35                                | Q264_35                            | cbcl035         | cbcl37                  |
| Q15.1_36                                | Q264_36                            | cbcl036     | cbcl_every              |
| Q15.1_37                                | Q264_37                            | cbcl037    | cbcl_upset              |
| Q15.1_38                                | Q264_38                            | cbcl038 | cbcl_troubsleep         |
| Q15.1_39                                | Q264_39                            | cbcl039        | cbcl56b                 |
| Q15.1_40                                | Q264_40                            | cbcl040       | cbcl_hit                |
| Q15.1_41                                | Q264_41                            | cbcl042    | cbcl_breath             |
| Q15.1_42                                | Q264_42                            | cbcl042    | cbcl_hurt               |
| Q15.1_43                               | Q264_43                            | cbcl043     | cbcl_unhap              |
| Q15.1_44                                | Q264_44                            | cbcl044     | cbcl_angry              |
| Q15.1_45                                | Q264_45                            | cbcl045        | cbcl56c                 |
| Q15.1_46                                | Q264_46                            | cbcl046         | cbcl46                  |
| Q15.1_47                                | Q264_47                            | cbcl047         | cbcl45                  |
| Q15.1_48                               | Q264_48                           | cbcl048         | cbcl47                  |
| Q15.1_49                                | Q264_49                            | cbcl049         | cbcl53                  |
| Q15.1_50                                | Q264_50                            | cbcl050         | cbcl54                  |
| Q15.1_51                                | Q264_51                            | cbcl051     | cbcl_panic              |
| Q15.1_52                                | Q264_52                            | cbcl052       | cbcl_bow                |
| Q15.1_53                                | Q264_53                            | cbcl053         | cbcl57                  |
| Q15.1_54                                | Q264_54                            | cbcl054         | cbcl58                  |
| Q15.1_55                                | Q264_55                            | cbcl055         | cbcl60                  |
| Q15.1_56                                | Q264_56                            | cbcl056         | cbcl62                  |
| Q15.1_57                                | Q264_57                            | cbcl057        | cbcl56d                 |
| Q15.1_58                                | Q264_58                            | cbcl058    | cbcl_punish             |
| Q15.1_59                                | Q264_59                            | cbcl059     | cbcl_shift              |
| Q15.1_60                                | Q264_60                            | cbcl060        | cbcl56e                 |
| Q15.1_61                                | Q264_61                            | cbcl061   | cbcl_reat               |
| Q15.1_62                                | Q264_62                            | cbcl062     | cbcl_play               |
| Q15.1_63                                | Q264_63                            | cbcl063     | cbcl_rock               |
| Q15.1_64                                | Q264_64                            | cbcl064       | cbcl_bed                |
| Q15.1_65                                | Q264_65                            | cbcl065   | cbcl_toil               |
| Q15.1_66                                | Q264_66                            | cbcl066         | cbcl68                  |
| Q15.1_67                                | Q264_67                            | cbcl067       | cbcl_aff                |
| Q15.1_68                                | Q264_68                            | cbcl068         | cbcl71                  |
| Q15.1_69                                | Q264_69                            | cbcl069   | cbcl_selfish            |
| Q15.1_70                                | Q264_70                            | cbcl070  | cbcl_littleaf           |
| Q15.1_71                                | Q264_71                            | cbcl071    | cbcl_inter              |
| Q15.1_72                                | Q264_72                            | cbcl072      | cbcl_fear               |
| Q15.1_73                                | Q264_73                            | cbcl073         | cbcl75                  |
| Q15.1_74                                | Q264_74                            | cbcl074         | cbcl76                  |
| Q15.1_75                                | Q264_75                            | cbcl075     | cbcl_smear              |
| Q15.1_76                                | Q264_76                            | cbcl076         | cbcl79                  |
| Q15.1_77                                | Q264_77                            | cbcl077    | cbcl_stares             |
| Q15.1_78                                | Q264_78                            | cbcl078        | cbcl56f                 |
| Q15.1_79                                | Q264_79                            | cbcl079       | cbcl_sad                |
| Q15.1_80                                | Q264_80                            | cbcl080         | cbcl84                  |
| Q15.1_81                                | Q264_81                            | cbcl081          | cbcl86                  |
| Q15.1_82                                | Q264_82                            | cbcl082         | cbcl87                  |
| Q15.1_83                                | Q264_83                            | cbcl083         | cbcl88                  |
| Q15.1_84                                | Q264_84                            | cbcl084      | cbcl_crie               |
| Q15.1_85                                | Q264_85                            | cbcl085       | cbcl95                  |
| Q15.1_86                                | Q264_86                            | cbcl086     | cbcl_clean              |
| Q15.1_87                                | Q264_87                           | cbcl087         | cbcl50                  |
| Q15.1_88                                | Q264_88                            | cbcl088    | cbcl_uncoop             |
| Q15.1_89                                | Q264_89                       | cbcl089        | cbcl102                 |
| Q15.1_90                                | Q264_90                       | cbcl090        | cbcl103                 |
| Q15.1_91                                | Q264_91                       | cbcl091        | cbcl104                 |
| Q15.1_92                                | Q264_92                       | cbcl092    | cbcl_people             |
| Q15.1_93                                | Q264_93                       | cbcl093        | cbcl56g                 |
| Q15.1_94                                | Q264_94                       | cbcl094      | cbcl_wake               |
| Q15.1_95                                | Q264_95                       | cbcl095      | cbcl_wand               |
| Q15.1_96                                | Q264_96                       | cbcl096         | cbcl19                  |
| Q15.1_97                                | Q264_97                       | cbcl097        | cbcl109                 |
| Q15.1_98                                | Q264_98                       | cbcl098    | cbcl_withdr             |
| Q15.1_99                                | Q264_99                       | cbcl099        | cbcl112                 |
| Q15.1_100                                | Q264_100                      | cbcl100   | cbcl113a                |
|                                       |                                     |                         |                         |

[Back to Table of Contents](#Table-of-Contents)

---

# **Coping with Children's Negative Emotions Scale - CCNES**

The CCNES presents hypothetical scenarios in which a child or adolescent gets upset or angry. Parents or their children are asked to indicate the degree to which the parent responds to each scenario in 6 theoretically meaning ways of coping with children's negative emotions.

## CCNES instructions:

### 1) Importing:

### 2) Editing and Renaming:



The measure will need the following from the pedigree:

mom guid, mom famID, interview age, interview date, sex.

### 3) Recoding:

### 4) Calculated Columns

### 5) Transfer to NDA Structure 

Now that your prep sheet is complete and contains all the columns as indicated in the Item matching chart, move the columns into the NDA structure.

## CCNES Item Matching Chart:



[Back to Table of Contents](#Table-of-Contents)

---

# **Acceptance and Action Questionnaire - AAQ**

The AAQ-II was developed in order to establish an internally consistent measure of ACT’s model of mental health and behavioral effectiveness.

## AAQ instructions:

### 1) Importing:

### 2) Editing and Renaming:



The measure will need the following from the pedigree:

mom guid, mom famID, interview age, interview date, sex.

### 3) Recoding:

### 4) Calculated Columns

### 5) Transfer to NDA Structure 

Now that your prep sheet is complete and contains all the columns as indicated in the Item matching chart, move the columns into the NDA structure.

## AAQ Item Matching Chart:

| *UPMC* **AAQ Question Number** | *UO* **AAQ Question Number** | AAQ Prep Sheet: | ***NDA* Data Structure:** |
| ------------------------------ | ---------------------------- | --------------- | ------------------------- |
| N/A                            | N/A                          | mom_guid        | subjectkey                |
| N/A                            | N/A                          | mom_famID       | src_subject_id            |
| N/A                            | N/A                          | interview_date  | interview_date            |
| N/A                            | N/A                          | interview_age   | interview_age             |
| N/A                            | N/A                          | sex             | sex                       |
| N/A                            | N/A                          | version         | version_form              |
| N/A                            | N/A                          | timepiont       | visit                     |
| Q4.1_1                         | Q154_1                       | aaq001          | aaq2_1                    |
| Q4.1_2                         | Q154_2                       | aaq002          | aaq_1_16                  |
| Q4.1_3                         | Q154_3                       | aaq003          | aaq2_3                    |
| Q4.1_4                         | Q154_4                       | aaq004          | aaq2_4                    |
| Q4.1_5                         | Q154_5                       | aaq005          | aaq2_5                    |
| Q4.1_6                         | Q154_6                       | aaq006          | aaq32                     |
| Q4.1_7                         | Q154_7                       | aaq007          | aaq2_6                    |
| Q4.1_8                         | Q154_8                       | aaq008          | aaq24                     |
| Q4.1_9                         | Q154_9                       | aaq009          | aaq2_8                    |
| Q4.1_10                        | Q154_10                      | aaq010          | aaq2_9                    |
| N/A                            | N/A                          | aaqTotal        | aaq_score                 |

[Back to Table of Contents](#Table-of-Contents)

---

# **Ways of Coping Checklist - WCCL**

The Ways of Coping Checklist (WCCL) is a measure of coping based on Lazarus and Folkman's (1984) stress and coping theory.

## WCCL instructions:

### 1) Importing

Install all the [packages](#Help-Section) required for the project. You can find what's needed in the [Help Section](#Help-Section). 

Read in all the CSVs needed. The files you'll need are located in your measure's folder. Check the [Help Section](#Help-Section) for example code.


### 2) Editing and Renaming

Edit and rename the Pedigree so that it only has the information needed for the NDA structure. Name it MeasureName_prep because this will be used to prepare everything before you do the final move to the NDA structure. The measure will need the following from the pedigree:

mom guid, mom famID, interview age, interview date, sex.

Next, take UO and UPMC time 1 data and add it to the MeasureName_prep data frame. Then add a column called "visit"  and append it to the end. Repeat this step for time 2, time 3, and time 4, changing the visit number respectively. 

### 3) Recoding



### 4) Calculated Columns

Insert the following columns at the end of your MeasureName_Prep sheet:

1. Column **wcclSU** which stands for *skills use scale*. The scoring for the skills use scale is the **AVERAGE** of these items: 

   ```R
   wccl001, wccl002, wccl004, wccl006, wccl009, wccl010, wccl011, wccl013, wccl016, wccl018, wccl019, wccl021, wccl022, wccl023, wccl026, wccl027, wccl029, wccl031, wccl033, wccl034, wccl035, wccl036, wccl038, wccl039, wccl040, wccl042, wccl043, wccl044, wccl047, wccl049, wccl050, wccl051, wccl053, wccl054, wccl056, wccl057, wccl058, wccl059
   ```

2. Column **wcclGSC** which stands for *general dysfunctional coping*. The scoring for the general dysfunctional coping factor is the **AVERAGE** of the following items: 

   ```R
   wccl003, wccl005, wccl008, wccl012, wccl014, wccl017, wccl020, wccl025, wccl032, wccl037, wccl041, wccl045, wccl046, wccl052, wccl055
   ```

3. Column **wcclBO** which stands for *blaming others*. The scoring for the blaming others factor is the **AVERAGE** of the following items: 

   ```R
   wccl007, wccl015, wccl024, wccl028, wccl030, wccl048
   ```

### 5) Transfer to NDA Structure 

Now that your prep sheet is complete and contains all the columns as indicated in the Item matching chart, move the columns into the NDA structure.

## WCCL Item Matching Chart:

| *UPMC* **WCCL Question Number** | *UO* **WCCL Question Number** | WCCL Prep Sheet: | *NDA* Data Structure |
| ------------------------------- | ----------------------------- | ---------------- | -------------------- |
| N/A                             | N/A                           | mom_guid         | subjectkey           |
| N/A                             | N/A                           | mom_famID        | src_subject_id       |
| N/A                             | N/A                           | interview_date   | interview_date       |
| N/A                             | N/A                           | interview_age    | interview_age        |
| N/A                             | N/A                           | sex              | sex                  |
| N/A                             | N/A                           | version          | version_form         |
| N/A                             | N/A                           | timepoint        | visit                |
| Q5.1_1                          | Q155_1                        | wccl001          | dbt_wccl1            |
| Q5.1_2                          | Q155_2                        | wccl002          | dbt_wccl2            |
| Q5.1_3                          | Q155_3                        | wccl003          | dbt_wccl3            |
| Q5.1_4                          | Q155_4                        | wccl004          | dbt_wccl4            |
| Q5.1_5                          | Q155_5                        | wccl005          | dbt_wccl5            |
| Q5.1_6                          | Q155_6                        | wccl006          | dbt_wccl6            |
| Q5.1_7                          | Q155_7                        | wccl007          | dbt_wccl7            |
| Q5.1_8                          | Q155_8                        | wccl008          | dbt_wccl8            |
| Q5.1_9                          | Q155_9                        | wccl009          | dbt_wccl9            |
| Q5.1_10                         | Q155_10                       | wccl010          | dbt_wccl10           |
| Q5.1_11                         | Q155_11                       | wccl011          | dbt_wccl11           |
| Q5.1_12                         | Q155_12                       | wccl012          | dbt_wccl12           |
| Q5.1_13                         | Q155_13                       | wccl013          | dbt_wccl13           |
| Q5.1_14                         | Q155_14                       | wccl014          | dbt_wccl14           |
| Q5.1_15                         | Q155_15                       | wccl015          | dbt_wccl15           |
| Q5.1_16                         | Q155_16                       | wccl016          | dbt_wccl16           |
| Q5.1_17                         | Q155_17                       | wccl017          | dbt_wccl17           |
| Q5.1_18                         | Q155_18                       | wccl018          | dbt_wccl18           |
| Q5.1_19                         | Q155_19                       | wccl019          | dbt_wccl19           |
| Q5.1_20                         | Q155_20                       | wccl020          | dbt_wccl20           |
| Q5.1_21                         | Q155_21                       | wccl021          | dbt_wccl21           |
| Q5.1_22                         | Q155_22                       | wccl022          | dbt_wccl22           |
| Q5.1_23                         | Q155_23                       | wccl023          | dbt_wccl23           |
| Q5.1_24                         | Q155_24                       | wccl024          | dbt_wccl24           |
| Q5.1_25                         | Q155_25                       | wccl025          | dbt_wccl25           |
| Q5.1_26                         | Q155_26                       | wccl026          | dbt_wccl26           |
| Q5.1_27                         | Q155_27                       | wccl027          | dbt_wccl27           |
| Q5.1_28                         | Q155_28                       | wccl028          | dbt_wccl28           |
| Q5.1_29                         | Q155_29                       | wccl029          | dbt_wccl29           |
| Q5.1_30                         | Q155_30                       | wccl030          | dbt_wccl30           |
| Q5.1_31                         | Q155_31                       | wccl031          | dbt_wccl31           |
| Q5.1_32                         | Q155_32                       | wccl032          | dbt_wccl32           |
| Q5.1_33                         | Q155_33                       | wccl033          | dbt_wccl33           |
| Q5.1_34                         | Q155_34                       | wccl034          | dbt_wccl34           |
| Q5.1_35                         | Q155_35                       | wccl035          | dbt_wccl35           |
| Q5.1_36                         | Q155_36                       | wccl036          | dbt_wccl36           |
| Q5.1_37                         | Q155_37                       | wccl037          | dbt_wccl37           |
| Q5.1_38                         | Q155_38                       | wccl038          | dbt_wccl38           |
| Q5.1_39                         | Q155_39                       | wccl039          | dbt_wccl39           |
| Q5.1_40                         | Q155_40                       | wccl040          | dbt_wccl40           |
| Q5.1_41                         | Q155_41                       | wccl041          | dbt_wccl41           |
| Q5.1_42                         | Q155_42                       | wccl042          | dbt_wccl42           |
| Q5.1_43                         | Q155_43                       | wccl043          | dbt_wccl43           |
| Q5.1_44                         | Q155_44                       | wccl044          | dbt_wccl44           |
| Q5.1_45                         | Q155_45                       | wccl045          | dbt_wccl45           |
| Q5.1_46                         | Q155_46                       | wccl046          | dbt_wccl46           |
| Q5.1_47                         | Q155_47                       | wccl047          | dbt_wccl47           |
| Q5.1_48                         | Q155_48                       | wccl048          | dbt_wccl48           |
| Q5.1_49                         | Q155_49                       | wccl049          | dbt_wccl49           |
| Q5.1_50                         | Q155_50                       | wccl050          | dbt_wccl50           |
| Q5.1_51                         | Q155_51                       | wccl051          | dbt_wccl51           |
| Q5.1_52                         | Q155_52                       | wccl052          | dbt_wccl52           |
| Q5.1_53                         | Q155_53                       | wccl053          | dbt_wccl53           |
| Q5.1_54                         | Q155_54                       | wccl054          | dbt_wccl54           |
| Q5.1_55                         | Q155_55                       | wccl055          | dbt_wccl55           |
| Q5.1_56                         | Q155_56                       | wccl056          | dbt_wccl56           |
| Q5.1_57                         | Q155_57                       | wccl057          | dbt_wccl57           |
| Q5.1_58                         | Q155_58                       | wccl058          | dbt_wccl58           |
| Q5.1_59                         | Q155_59                       | wccl059          | dbt_wccl59           |
| N/A                             | N/A                           | wccl_SU          | dbt_wccl_su          |
| N/A                             | N/A                           | wccl_GDC         | dbt_wccl_gdc         |
| N/A                             | N/A                           | wccl_BO          | dbt_wccl_bo          |

[Back to Table of Contents](#Table-of-Contents)

---

# **Preschool and Kindergarten Behavior Scales - PKBS**

The *Preschool and Kindergarten Behavior Scales*-Second Edition (*PKBS*-2) is a *behavior* rating *scale* designed for use with children ages 3 through 6 years.

## PKBS instructions:

### 1) Importing

Install all the [packages](#Help-Section) required for the project. You can find what's needed in the [Help Section](#Help-Section). 

Read in all the CSVs needed. The files you'll need are located in your measure's folder. Check the [Help Section](#Help-Section) for example code.

### 2) Editing and Renaming

### 3) Recoding

### 4) Calculated Columns

### 5) Transfer to NDA Structure 

Now that your prep sheet is complete and contains all the columns as indicated in the Item matching chart, move the columns into the NDA structure.

## PKBS Item Matching Chart:

| **UPMC PKBS Question Number** | **UO PKBS Question Number** | PKBS Prep Sheet: | ***NDA* Structure** |
| ----------------------------- | --------------------------- | ---------------- | ------------------- |
| N/A                           | N/A                         | mom_guid         | subjectkey          |
| N/A                           | N/A                         | mom_famID        | src_subject_id      |
| N/A                           | N/A                         | interview_date   | interview_date      |
| N/A                           | N/A                         | interview_age    | interview_age       |
| N/A                           | N/A                         | sex              | sex                 |
| N/A                           | N/A                         | version          | version_form        |
| N/A                           | N/A                         | visit            | visit               |
| Q16.1_1                       | Q407_1                      | pkbs001          | Social2             |
| Q16.1_2                       | Q407_2                      | pkbs002          | Social7             |
| Q16.1_3                       | Q407_3                      | pkbs003          | Social10            |
| Q16.1_4                       | Q407_4                      | pkbs004          | Social12            |
| Q16.1_5                       | Q407_5                      | pkbs005          | Social16            |
| Q16.1_6                       | Q407_6                      | pkbs006          | Social22            |
| Q16.1_7                       | Q407_7                      | pkbs007          | Social23            |
| Q16.1_8                       | Q407_8                      | pkbs008          | Social25            |
| Q16.1_9                       | Q407_9                      | pkbs009          | Social28            |
| Q16.1_10                      | Q407_10                     | pkbs010          | Social29            |
| Q16.1_11                      | Q407_11                     | pkbs011          | Social30            |
| Q16.1_12                      | Q407_12                     | pkbs012          | Social32            |
| Q16.1_13                      | Q407_13                     | pkbs013          | Social5             |
| Q16.1_14                      | Q407_14                     | pkbs014          | Social14            |
| Q16.1_15                      | Q407_15                     | pkbs015          | Social15            |
| Q16.1_16                      | Q407_16                     | pkbs016          | Social17            |
| Q16.1_17                      | Q407_17                     | pkbs017          | Social19            |
| Q16.1_18                      | Q407_18                     | pkbs018          | Social20            |
| Q16.1_19                      | Q407_19                     | pkbs019          | Social21            |
| Q16.1_20                      | Q407_20                     | pkbs020          | Social24            |
| Q16.1_21                      | Q407_21                     | pkbs021          | Social27            |
| Q16.1_22                      | Q407_22                     | pkbs022          | Social33            |
| Q16.1_23                      | Q407_23                     | pkbs023          | Social34            |
| Q16.1_24                      | Q407_24                     | pkbs024          | Social1             |
| Q16.1_25                      | Q407_25                     | pkbs025          | Social3             |
| Q16.1_26                      | Q407_26                     | pkbs026          | Social6             |
| Q16.1_27                      | Q407_27                     | pkbs027          | Social8             |
| Q16.1_28                      | Q407_28                     | pkbs028          | P_soc_23_ft         |
| Q16.1_29                      | Q407_29                     | pkbs029          | Social11            |
| Q16.1_30                      | Q407_30                     | pkbs030          | Social13            |
| Q16.1_31                      | Q407_31                     | pkbs031          | Social18            |
| Q16.1_32                      | Q407_32                     | pkbs032          | Social26            |
| Q16.1_33                      | Q407_33                     | pkbs033          | Social31            |

[Back to Table of Contents](#Table-of-Contents)

---

# **Bear Dragon**

## Bear Dragon instructions:

### 1) Importing

Install all the [packages](#Help-Section) required for the project. You can find what's needed in the [Help Section](#Help-Section). 

Read in all the CSVs needed. The files you'll need are located in your measure's folder. Check the [Help Section](#Help-Section) for example code.


### 2) Editing and Renaming

Edit and rename the Pedigree so that it only has the information needed for the NDA structure. Name it MeasureName_prep because this will be used to prepare everything before you do the final move to the NDA structure. The measure will need the following from the pedigree:

child guid, child famID, interview age, interview date, sex.

Next, we need to take all Redcap data and add it to the MeasureName_prep data frame.

### 3) Transfer to NDA Structure  

Now that your prep sheet is complete and contains all the columns as indicated in the Item matching chart, move the columns into the NDA structure.

## Bear Dragon Item Matching Chart:

| Redcap Data      | Bear Dragon Prep Sheet | ***NDA* Structure** |
| ---------------- | ---------------------- | ------------------- |
| N/A              | child_guid             | subjectkey          |
| N/A              | child_famID            | src_subject_id      |
| N/A              | interview_date         | interview_date      |
| N/A              | Interview_age          | interview_age       |
| N/A              | sex                    | sex                 |
| N/A              | timepoint              | visit               |
| oc_bd_01         | bd_001                 | beardragon1         |
| oc_bd_02         | bd_002                 | beardragon2         |
| oc_bd_03         | bd_003                 | beardragon3         |
| oc_bd_04         | bd_004                 | beardragon4         |
| oc_bd_05         | bd_005                 | beardragon5         |
| oc_bd_06         | bd_006                 | beardragon6         |
| oc_bd_07         | bd_007                 | beardragon7         |
| oc_bd_08         | bd_008                 | beardragon8         |
| oc_bd_09         | bd_009                 | beardragon9         |
| oc_bd_10         | bd_010                 | beardragon10        |
| bear_score       | total_bear_score       | bear_score          |
| dragon_score     | total_dragon_score     | dragon_score        |
| beardragon_total | total_correct_bd       | beardragon_total    |

[Back to Table of Contents](#Table-of-Contents)

---

# **Affect Perspective Taking**

## Affect Perspective Taking instructions:

### 1) Importing

### 2) Editing and Renaming

### 3) Recoding

### 4) Calculated Columns

### 5) Transfer to NDA Structure 

Now that your prep sheet is complete and contains all the columns as indicated in the Item matching chart, move the columns into the NDA structure.

## Affect Perspective Taking Item Matching Chart:

| RedCap Data | Bear Dragon Prep Sheet | ***NDA* Structure** |
| ----------- | ---------------------- | ------------------- |
| N/A         | child_guid             | subjectkey          |
| N/A         | child_famID            | src_subject_id      |
| N/A         | interview_date         | interview_date      |
| N/A         | interview_age          | interview_age       |
| N/A         | sex                    | gender              |
| N/A         | timepoint              | visit               |
| apt1        | apt001                 | apt1                |
| apt2        | apt002                 | apt2                |
| apt3        | apt003                 | apt3                |
| apt4        | apt004                 | apt4                |
| apt5        | apt005                 | apt5                |
| apt6        | apt006                 | apt6                |
| apt7        | apt007                 | apt7                |
| apt8        | apt008                 | apt8                |
| apt9        | apt009                 | apt9                |
| apt10       | apt010                 | apt10               |
| apt11       | apt011                 | apt11               |
| apt12       | apt012                 | atp12               |
| apt13       | apt013                 | apt13               |
| apt14       | apt014                 | apt14               |
| apt15       | apt015                 | apt15               |
| apt16       | apt016                 | apt16               |

[Back to Table of Contents](#Table-of-Contents)

---

# **Dimensional Card Sort**

## Dimensional Card Sort instructions:

### 1) Importing

### 2) Editing and Renaming

### 3) Recoding

### 4) Calculated Columns

### 5) Transfer to NDA Structure 

Now that your prep sheet is complete and contains all the columns as indicated in the Item matching chart, move the columns into the NDA structure.

## Dimensional Card Sort Item Matching Chart:



[Back to Table of Contents](#Table-of-Contents)

---

# **Emotion Labeling**

## Emotion Labeling instructions:

### 1) Importing

### 2) Editing and Renaming

### 3) Recoding

### 4) Calculated Columns

### 5) Transfer to NDA Structure 

Now that your prep sheet is complete and contains all the columns as indicated in the Item matching chart, move the columns into the NDA structure.

## Emotion Labeling Item Matching Chart:



[Back to Table of Contents](#Table-of-Contents)

---

# **Emotion Strategies**  

## Emotion Strategies instructions:

### 1) Importing

### 2) Editing and Renaming

### 3) Recoding

### 4) Calculated Columns

### 5) Transfer to NDA Structure 

Now that your prep sheet is complete and contains all the columns as indicated in the Item matching chart, move the columns into the NDA structure.

## Emotion Strategies Item Matching Chart:



[Back to Table of Contents](#Table-of-Contents)

---

# **Help Section** 

- **NDA:** The National Institute of Mental Health Data Archive (NDA) makes available human subjects data collected from hundreds of research projects across many scientific domains. NDA provides infrastructure for sharing research data, tools, methods, and analyses enabling collaborative science and discovery. De-identified human subjects data, harmonized to a common standard, are available to qualified researchers. Summary data are available to all.

- **Measures:** The measures we're working with come from different places. As shown below every Qualtrics measure is a self reported survey completed by our mother participants. Every Redcap measure is a scored child task. And measure in the "*Other*" category are collected mostly during the clinical intake and stored in various forms. Click one of the measures below to go it's respective instructions. 

  | Qualtrics                                                    | Redcap                                                  | Other                                                        |
  | ------------------------------------------------------------ | ------------------------------------------------------- | :----------------------------------------------------------- |
  | [DERS](#Difficulties-in-Emotion-Regulation-Scale---DERS)     | [Bear Dragon](#Bear-Dragon)                             | [Pedigree](#Research-Subject-Pedigree)                       |
  | [CBCL](#Child-Behavior-Checklist---CBCL)                     | [Affect Perspective Taking](#Affect-Perspective-Taking) | [SCID](#Structured-Clinical-Interview-for-DSM-V---SCID)      |
  | [CCNES](#Coping-with-Children's-Negative-Emotions-Scale---CCNES) | [Dimensional Card Sort](#Dimensional-Card-Sort)         | [SID-P](#Structured-Interview-for-DSM-IV-Personality---SID-P) |
  | [AAQ](#Acceptance-and-Action-Questionnaire---AAQ)            | [Emotion Labeling](Emotion-Labeling)                    | [PPVT](#Peabody-Picture-Vocabulary-Test---PPVT)              |
  | [WCCL](#Ways-of-Coping-Checklist---WCCL)                     | [Emotion Strategies](#Emotion-Strategies)               |                                                              |
  | [PKBS](#Preschool-and-Kindergarten-Behavior-Scale---PKBS)    |                                                         |                                                              |

- **R/Rstudio:** A programming language and free software environment for statistical computing and graphics. We'll be using it to import excel files, move columns, and calculate averages and sums. [Read More](https://www.r-project.org/about.html)

- **Mapping:** Mapping in this context relates to connecting the content of a column in one excel sheet to the column in a different excel sheet.

- **Structure:** By structure we are referring to the NDA provided excel sheets they request all data to be submitted in. Essentially it is a template that we need to populate.  

- **Function:** A function is a set of statements organized together to perform a specific task. For example:

  ```R
  function_name <- function(arg_1, arg_2, ...) {
     Function body 
  }
  ```

- **Skeleton Function:** A skeleton function is a function that contains no body. lol.

- **Item Matching Chart:** Each measure contains a chart that matches the columns in the measure's excel sheet to a column in the NDA provided structure. It acts as a road map so you know where each question goes. 

- **Packages:** Packages are tools that you can download to help your code that are not native to the R language. For example, we download a package in R called "dyplr" because that enables the select() function along with many others.

- **Example of Importing CSVs into Rstudio:** Below we are creating a data frame variable named Site_MeasureName_TimePoint and are assigning the contents of the 'FILEPATH' to it. This will need to be done to every time point from both sites. Also, the fake pedigree and the NDA structure needs to be imported as well. 

   ```R
    UO_MeasureName_T1 <- read.csv(file = 'FILEPATH to Measure')
    UO_MeasureName_T2 <- read.csv(file = 'FILEPATH to Measure')
    UO_MeasureName_T3 <- read.csv(file = 'FILEPATH to Measure')
    UO_MeasureName_T4 <- read.csv(file = 'FILEPATH to Measure')
    UPMC_MeasureName_T1 <- read.csv(file = 'FILEPATH to Measure')
    UPMC_MeasureName_T2 <- read.csv(file = 'FILEPATH to Measure')
    UPMC_MeasureName_T3 <- read.csv(file = 'FILEPATH to Measure')
    UPMC_MeasureName_T4 <- read.csv(file = 'FILEPATH to Measure')
    Pedigree <- read.csv(file = 'FILEPATH to Fake Pedigree')
    MeasureName_NDA <- read.csv(file = 'FILEPATH to NDA Structure')
   ```

---

![](https://media.giphy.com/media/3o7btSQvfKibGpkk9i/giphy.gif)
