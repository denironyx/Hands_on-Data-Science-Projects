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
summary(util)

## Rearrange the columns in a df
util$Timestamp <- NULL
head(util)
util <- util[, c(4,1,2,3)]

## Working with a list
summary(util)
RL1 <- util[util$Machine == "RL1",]
summary(RL1)
RL1$Machine <- factor(RL1$Machine)

## Construct list
util_stats_rl1 <- c(min(RL1$Utilization, na.rm = TRUE),
                    mean(RL1$Utilization, na.rm = TRUE),
                    max(RL1$Utilization, na.rm = TRUE))
util_stats_rl1

## Performance of machine below 90%
util_under_90_flag <- length(which(RL1$Utilization < 0.90)) > 0
list_rl1 <- list("RL1", util_stats_rl1, util_under_90_flag)
list_rl1

## Naming components of a list
names(list_rl1)
names(list_rl1) <- c("Machine", "Stats", "lowThreshold")

## Extracting components of a list
#[] -  will always return a list
#[[]] - will return the actual object
list_rl1
list_rl1[1]
list_rl1[[1]]

typeof(list_rl1[2])
list_rl1[[2]][2]

## The 3rd element of the vector (max utilization)
list_rl1[[2]][3]

 



































