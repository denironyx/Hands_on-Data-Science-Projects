# List in R

#Delivarable -  a list with the following components 
#Character: Machine Name
#Vector: (min, mean, max) utilization for the month
#Logical: Has utilization ever fallen below 90% ? TRUE / FALSE
#Vector: All hours where utilization is unknown (NA's)
#Dataframe: For this machine
#Plot: for all machines

##loading packages
library(dplyr)

## Import the data
util <- read.csv("machine_utilization/data/P3-Machine-Utilization (1).csv", stringsAsFactors = TRUE)
head(util, 12) # What does the dataset look like
str(util) # Checking the structure of the dataframe
summary(util)


## Derive utilization column
util$Utilization = 1 - util$Percent.Idle
head(util,12)  

## Handling Date Time in R
tail(util)#Considering it's a month data, we can easily find the what data format it is in (EUROPEAN or America)
?POSIXct
util$PosixTime <- as.POSIXct(util$Timestamp, format = "%d/%m/%Y %H:%M")
head(util)
















