#Deliverable - a list with the following components:
#Character: Machine name
#Vector: (min, mean, max) Utilization for the month (excluding unknow hours)
#logical: Has utilization ever fallen below 90% ? TRUE / FALSE
#Vector: All hours where utilization is unknown (Na's)
#Dataframe: For this machine
#Plot: for all machines

getwd()
#MAC
setwd("Data science project/Data Analysis/superdatascience")
getwd()
util <- read.csv("P3-Machine-Utilization (1).csv")
head(util, 12)
str(util)
summary(util)

### Derive utilization column
util$Utilization = 1 - util$Percent.Idle
head(util,12)
tail(util)

### Handling Date-Times in R
?POSIXct
util$PosixTime <- as.POSIXct(util$Timestamp, format = "%d/%m/%Y %H:%M")
head(util,12)
summary(util)

#TIP: How to rearrange columns in a df:
util$Timestamp <- NULL
head(util, 12)
util <- util[,c(4,1,2,3)]
head(util, 12)

##What is a list?
summary(util)
RL1 <- util[util$Machine == "RL1",]
summary(RL1)
RL1$Machine <- factor(RL1$Machine)
summary(RL1)

#Construct list:
#Character: Machine name
#Vector: (min, mean, max) Utilization for the month (excluding unknown hours)
#Logical: Has utilization ever fallen below 90% ? TRUE / FALSE
util_stats_rl1 <- c(min(RL1$Utilization, na.rm = T),
                    mean(RL1$Utilization, na.rm = T),
                    max(RL1$Utilization, na.rm = T))
util_stats_rl1
util_under_90_flag <- length(which(RL1$Utilization < 0.90)) > 0

list_rl1 <- list("RL1", util_stats_rl1, util_under_90_flag)
list_rl1

## Naming components of a list
list_rl1
names(list_rl1) <- c("Machine", "Stats", "LowThreshold")
rm(list_rl1)

##alternative
list_rl1 <- list("Machine" = "RL1", "Stats" = util_stats_rl1, "LowThreshold" = util_under_90_flag)
list_rl1[2][1]
list_rl1[[2]][3]

## Adding and deleting list components
list_rl1
list_rl1[4] <- "New Information"

# Another way to add a comemment - via the $
#We will add:
#Vector: All hours where utilization is unknown (NA's)
list_rl1$UnknowHours <- RL1[is.na(RL1$Utilization), "PosixTime"]
list_rl1

## Remove a component. Use the Null method
list_rl1[[4]] <- NULL
list_rl1[[4]]

##Dataframe for this machine
list_rl1$Data <- RL1
list_rl1


## Time series plot
library(ggplot2)
p <- ggplot(data = util)
myplot <- p + geom_line(aes(x = PosixTime, y = Utilization,
                            color = Machine), size = 1.2) + 
  facet_grid(Machine ~.)+
  geom_hline(yintercept = 0.90,
             colour = "Gray", size = 1.2,
             linetype = 3)

list_rl1$Plot <- myplot 

list_rl1































