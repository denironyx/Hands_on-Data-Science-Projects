library(dplyr)
library(lubridate)
set.seed(2017)
options(digits = 4)

## Say these are your daily expenses for 2016
(expenses <- data_frame(
  date=seq(as.Date("2016-01-01"), as.Date("2016-12-31"), by=1),
  amount=rgamma(length(date), shape = 2, scale = 20)))

## Then you can summarize them by the
expenses %>% 
  group_by(month = floor_date(date, "month")) %>% 
  summarize(amount = sum(amount))

### Floor date lets you round dates to various time period from seconds to years and also multiples of these period
expenses %>% 
  group_by(month = floor_date(date, "14 days")) %>% 
  summarise(amount = sum(amount))
  
expenses %>% 
  group_by(month = round_date(date, "month"))


