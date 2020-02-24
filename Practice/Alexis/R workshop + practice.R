## -------------- Header --------------
## title: "START LAB R Workshop"
## author: "Min Zhang"
## date: "2/14/2020"
## output: html_document
##
## -------------- Note --------------
##
##
## To run code, you can press conttrol + return 
## All tthe line start with # are comment, not actually the code you run
##
## Some useful Resources:
## [Cookbook for R](http://www.cookbook-r.com/)
## [DataCamp](https://www.datacamp.com/)
## --------------------------------------


## -------------- Empty Global Environment -------------- 
# This code is remove all the item in Global Environment
# I have habit put this code on top of all my script, just incase I switch from script to script. 
rm(list = ls())


## -- ------------ Basic R --------------
## arithmetic
2+3
2*4

## Creatte variable and assigned value
# Google's R Style Guide suggests the usage of <- rather than = even though the equal sign is also allowed in R to do exactly the same thing when we assign a value to a variabl
x <- 8 
x = 3

# Check x value
x
# What about y
y

# Need to assign something to y
y <- 3
y+x

# Create range of values 
x <- 1:5 #x now is a vector 

x <- c(2,3,4,6,7)


# Good time talk about global environment / values 
# Each time we assign x a value, x's value updated

## -- ------------ Function --------------
# Create a vector
x<-1:4

sqrt(x)
mean(x)
sd(x)
sum(x)

# Data with NA
q<-c(2, 8, 6, NA, 4, 8)

# what do you expect about this 
mean(q)

# Need hit?
?mean
help("mean")

# Additional argument is needed here to tell the fumction to ignore NA
# Read help page for more info
mean(q, na.rm = TRUE)

## --------------- DATA FRAME --------------
# I recently know about this
# There are built in datasets!!!
# speed vs. brake distense 
cars 

#euro vs. other currency 
euro 

#yellowstone faithful time 
faithful 

#15 women's weight and hight 
women 

#plot
boxplot(women$height)


## -------------- Set uo working directtory --------------
# This will set up your working directory
# This usually at the top of your script
# Change according where you save the csv file
setwd("/Users/vinsanyon/Documents/MIn/Start/Testing/Measures/DERS")

# This help you know where is your working directory, you don't heve to have this in your sriptt. 
getwd()

## -------------- Read file --------------
# now let's read in data
# if you have the "Fake_Pedigree.csv" in the current working directory, you can do following code to read the file. Otherwise use the alternitive
Pedigree <- read.csv(file = "Fake_Pedigree.csv")

# alternitive:
# Change the working directory (path), in " ", to correct one on your computer
# Pedigree <- read.csv(file = "/Users/Testing/Measures/DERS/Fake_Pedigree.csv")


## -------------- Look at file --------------
# look at the data, note the capital "V"
# You don't have to include this code in your script
View(Pedigree)

# look at the first few rows of data 
head(Pedigree)

# look at final few rows of data 
tail(Pedigree)

# look at stracture of data 
# form this you know what you vraiable are and what type of data are they
str(Pedigree)

## -------------- indexing and modifying a data frame --------------
# This will more revenlt to our project

# get condition column 
# data["number before comma indicte row number","number before comma indicte row number"]
# data[,"condition"]
Pedigree[,5]

# get value in row 1 column 5
Pedigree[1,5]

# get row 3 of the intake_dat colum
Pedigree[3,"intake_date"]
# be careful about doing this, you are changing the value of row 3 in intake_dat colume
Pedigree[3,"intake_date"] <- "Feb,2,2020"

# Select first two row of Pedigree and save as new_Pedigree
new_Pedigree <- Pedigree[c(1,2),]

# Remove first two row of Pedigree and save as second_Pedigree
second_Pedigree <- Pedigree[-c(1,2),]


# $ refer column: this code indcate child_gender column in Pedigree frame
Pedigree$child_gender


Pedigree$sex # if you run this you will see in console return NULL, because we don't have value in this colume
# Create new column 
Pedigree$sex <- "Female" #Now we I assign everry row in the sex column as Female

# We can also assign new column by the column
Pedigree$sex <- Pedigree$child_gender
Pedigree$ID <- Pedigree$mom_id + Pedigree$intake_date

# Now we are bring mom_id, mom_gender in to a new pedigree data set
Pedigree_new <- select(Pedigree, c(mom_id,mom_gender))


# Or create a new data set with column in exist data set 
New_Set <- select(Pedigree, c(mom_id,mom_gender))
head(Pedigree)

#It's doesn't make sense add id and date together, let's delete taht column 
Pedigree$ID<- NULL

# Rename the column, 
# Rename(dataset, new name = old name)
rename(Pedigree, mom_sex = mom_gender)
#View Pedigree, what do you expect the name of mom_gender column?
View(Pedigree)
# It didn't change, because we didn save the data set with renamed column

# Raname and save it 
Pedigree <- rename(Pedigree, mom_sex=mom_gender)
# Now look at Pedigree
View(Pedigree)

# Let't look at mom_sex column
# We want recode this column: we want code F as 1 and M as 0 
Pedigree$mom_sex[Pedigree$mom_sex=='F']<-1
Pedigree$mom_sex[Pedigree$mom_sex=='M']<-0


## -------------- Package  --------------
# Install package, you only need to do this once on your compurter
# if you have this package, you don't need to run the following line, you can comment out this by add # at the beginning of next line. 
install.packages("dplyr")

# Load the package (tell R that you want to use those functions )
# You need to do this every time
library("dpylr")
# You can also do this by click on the "Packages" tab on top of the left bottom box, and check whicheverr package you will need. (Appologize for very unhelpful direction for the botton)


## -------------- Practices  --------------
# Read Fake_Pedigree.csv and save as Pedigree 

  
# Read UO_T1_Qualtrics.csv as UO_DERS_T1
  

  
# Select mom_guid,mom_id,mom_gender,child_gender from Pedigree, and put them in a new data frame and name it to Data_PREP

  
# Rename mom_gender and child_gender to mom_sex and child_sex


# Select Q137_1, Q137_2 from UO_DERS_T1 and save as UO_DERS_T1
# Some of you who will work with a large dataset can try to use startwith function 



#Recode 'Almost Never (0-10%)' as 1 in UO_DERS_T1



# Add column Q137_1 and Q137_2 and save to new column name as SUM_Q

