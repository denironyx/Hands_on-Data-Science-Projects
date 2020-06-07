####### 
##############################

## Set the working directory
setwd("E:\\learnRstarter\\future500")

## Reading the future500 data into R
fin <- read.csv("dataset/future500.csv", na.strings=c(""))

## head of the data
head(fin)

## the last five rows of the future500 dataset
tail(fin)

## Exploring the structure of the datasets
str(fin)

## summary of the future dataset
summary(fin)

## Changing from non-factor to factor
fin$ID <- as.factor(fin$ID)
str(fin)
fin$Inception <- factor(fin$Inception)

## Factor Variable Trap
## Converting a column from factor to non factor (numeric)

a <- c("12", "13", "15", "16", "17", "18")
a
typeof(a)

b <- as.numeric(a)
b

z <- factor(c("12", "13", "15", "16", "17", "18"))
y <- as.numeric(z)
typeof(y)
#--------------
as.numeric(as.character(z))


## Factor Variable Trap
## Converting a column from factor to non factor (numeric)
head(fin)
str(fin)

fin$Profit <- factor(fin$Profit)

##Changing the names of the column
fin$Name <- as.character(fin$Name)
str(fin)

## Changing the profit column from factor to numeric
fin$Profit <- as.numeric(as.character(fin$Profit))
fin$Profit <- as.integer(fin$Profit)

## gsub and sub: gsub replaces all instances, sub replaces first instances
head(fin)

### Removing "Dollars" and commas and converting the Expenses column to integer
fin$Expenses <- gsub(" Dollars", "", fin$Expenses)
fin$Expenses <- gsub(",", "", fin$Expenses)
fin$Expenses <- as.integer(fin$Expenses)
str(fin)

## Removing the Dollar signs and converting the revenue colown to integer
head(fin)
fin$Revenue <- gsub("\\$", "", fin$Revenue)
fin$Revenue <- gsub(",", "", fin$Revenue)
fin$Revenue <- as.integer(fin$Revenue)
str(fin)

## Removing character symbols and converting the Growth column to integer
fin$Growth <- gsub("%", "", fin$Growth)
fin$Growth <- as.integer(fin$Growth)
str(fin)

###
summary(fin)

################\
### Dealing with missing data
#Predict with 100% accuracy
#Leave record as is
#Remmove the record entirely
#Replace with mean or median
#Fill in by exploring correlations and similarities
#Introduce dummy variable

## Na is a third type of logical variable
head(fin, 24)

## locating missing data, there is a different between NAs and empty characters
fin[!complete.cases(fin),]

##Filtering: Using which() for non-missing data
head(fin)
fin[fin$Revenue == 9746272,]
fin[which(fin$Revenue == 9746272),]

####
fin[fin$Employees == 45,]
fin[which(fin$Employees == 45),]


## Filtering: Using is.na() for missing data
fin[is.na(fin$Expenses),]
fin[is.na(fin$State),]

##Removing records with missing data
fin_backup <- fin
fin <- fin_backup

## All the column that have empty values
fin[!complete.cases(fin),]

## row that have missing value of the industry
fin[is.na(fin$Industry),]
fin <- fin[!is.na(fin$Industry),] #opposite
fin

## Reseting the row indexes
fin
rownames(fin) <- 1:nrow(fin)
fin
rownames(fin) <- NULL
fin

## replacing missing data: factual analysis
fin[!complete.cases(fin),]
fin[is.na(fin$State),]
fin[is.na(fin$State) & fin$City == "New York",]
fin[is.na(fin$State) & fin$City == "New York", "State"] <- "NY"

## Check
fin[c(11,377),]

## Replacing missing data CA: factual analysis
fin[!complete.cases(fin),]
fin[is.na(fin$State) & fin$City == "San Francisco", "State"] <- "CA"
fin[c(82,265),]

## Replacing missing data: Median Imputation Method 
fin[!complete.cases(fin),]

med_empl_retail <- median(fin[fin$Industry == "Retail","Employees"], na.rm = TRUE)
med_empl_retail
fin[is.na(fin$Employees) & fin$Industry == "Retail", "Employees"] <- med_empl_retail
fin[3,]

####

fin[!complete.cases(fin),]
med_empl_financial <- median(fin[fin$Industry == "Financial Services","Employees"], na.rm = TRUE)
fin[is.na(fin$Employees) & fin$Industry == "Financial Services", "Employees"] <- med_empl_financial
fin[330,]


### Replacing missing Data: Median Imputation Method (Part 2)
fin[!complete.cases(fin),]
med_constr_growth <- median(fin[fin$Industry == "Construction", "Growth"], na.rm = TRUE)
fin[is.na(fin$Growth) & fin$Industry == "Construction", "Growth"] <- med_constr_growth
fin[8,]

###
fin[!complete.cases(fin),]
med_rev_constr <- median(fin[fin$Industry == "Construction", "Revenue"], na.rm = TRUE)
fin[is.na(fin$Revenue) & fin$Industry == "Construction","Revenue"] <- med_rev_constr
##check
fin[c(8,42),]

### 
fin[!complete.cases(fin), ]
med_constr_exp <- median(fin[fin$Industry == "Construction", "Expenses"], na.rm = TRUE)
fin[is.na(fin$Expenses) & fin$Industry == "Construction", "Expenses"] <- med_constr_exp

##check
fin[c(8,15,42),]

####Replacing Missing Data: Deriving values
#Revenue - Expenses = Profit
#Expenses= Revenue - Profit
fin[is.na(fin$Profit) & fin$Industry == "Construction", "Profit"] <- fin[is.na(fin$Profit) & fin$Industry == "Construction", "Revenue"] - fin[is.na(fin$Profit) & fin$Industry == "Construction", "Expenses"]
#check
fin[c(8,42),]

## FINDING Expenses
fin[is.na(fin$Expenses), "Expenses"] <- fin[is.na(fin$Expenses), "Revenue"] - fin[is.na(fin$Expenses), "Profit"]
#check
fin[15,]

####
fin[!complete.cases(fin),]































