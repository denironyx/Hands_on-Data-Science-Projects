#https://www.guru99.com/r-aggregate-function.html#1

library(dplyr)

# Step one: Import the data, select the relevant variables and sort the data
data <- read.csv("https://raw.githubusercontent.com/guru99-edu/R-Programming/master/lahman-batting.csv")
data <- data %>% 
  select(playerID, yearID, AB, teamID, lgID, G, R, HR, SH) %>% 
  arrange(playerID, teamID, yearID)
nrow(data)

## Structure of the data
glimpse(data)

## Summarise
summarise(data, mean_run = mean(R),
          mean_games = mean(G),
          mean_SH = mean(SH, na.rm = T))

data %>% 
  group_by(lgID) %>% 
  summarise(mean_run = mean(HR))

##Select the data frame
##Group data
## Summarize the data
library(ggplot2)
data %>% 
  group_by(lgID) %>% 
  summarise(mean_home_run = mean(HR)) %>% 
  arrange(desc(mean_home_run)) %>% 
  ggplot(aes(x = lgID, y = mean_home_run, fill = lgID)) + 
    geom_bar(stat = "identity") + 
    theme_classic() + 
    labs(
      x = "baseball league",
      y = "Average home run",
      title = paste(
        "Example group_by() with summarise"
      )
    )


## Subsetting  +  median
data %>% 
  group_by(lgID) %>% 
  summarise(median_at_bat_league = median(AB), 
           median_at_bat_league_no_zero = median(AB[AB > 0]) )

# sUM
data %>% 
  group_by(lgID) %>% 
  summarise(sum_homerun_league = sum(HR)) %>% 
  arrange(desc(sum_homerun_league))

## Minimum and Maximum
data %>% 
  group_by(playerID) %>% 
  summarise(min_G = min(G),
            max_G = max(G))

## Count observation
data %>% 
  group_by(playerID) %>% 
  summarise(number_year = n()) %>% 
  arrange(desc(number_year))

## first and 
# You can select the first, last or nth position of a group
# for instance, you can find the first and last year of each player
data %>% 
  group_by(playerID) %>% 
  summarise(first_appearance = first(yearID),
            last_appearance = last(yearID))


## Nth observation
data %>% 
  group_by(teamID) %>% 
  summarise(second_game = nth(yearID, 3)) %>% 
  arrange(second_game)

## Distinct number of observation
data %>% 
  group_by(teamID) %>% 
  summarise(number_player = n_distinct(playerID)) %>% 
  arrange(desc(number_player))

#### Multiple groups
data %>% 
  group_by(yearID, teamID) %>% 
  summarise(mean_games = mean(G)) %>% 
  arrange(desc(teamID, yearID))

##Filter 
data %>% 
  filter(yearID > 1980) %>% 
  group_by(yearID) %>% 
  summarise(mean_game_year = mean(G))


## Ungroup
data %>% 
  filter(HR > 0) %>% 
  group_by(playerID) %>% 
  summarise(average_HR_game = sum(HR) / sum(G)) %>% 
  ungroup() %>% 
  summarise(total_average_homerun = mean(average_HR_game))


























