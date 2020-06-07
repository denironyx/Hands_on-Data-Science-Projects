library(tidyverse)
library(here)
library(stringr)

## reading the data into R
sms_response <- read_csv("bn4l/data/bn4l_sms_responses.csv")
baseline <- read_csv("bn4l/data/bn4l_hcw_baseline_characteristics.csv")


## summary
head(sms_response)
head(baseline)
str(sms_response)

### Join the baseline and sms_response dataset together
joined_df<- baseline %>%
  left_join(sms_response, by = "Phone Number") %>% 
  glimpse()

head(joined_df)
str(joined_df)


response_db <- joined_df %>% 
  mutate(Sex = recode(Sex, `0` = "Male", `1` = "Female", .other = "Wrong Input")) %>% 
  mutate(Residence = recode(Residence, `1` = "Urban", `2` = "Rural", .other = "Wrong Input")) %>% 
  mutate(Ethnicity = recode(Ethnicity, `1` = "Hausa", `2` = "Kano",`3` = "Bauchi", `4` = "Kaduna", .other = "Wrong Input")) %>% 
  mutate(`Marital Status` = recode(`Marital Status`, `1` = "Never Married", `2` = "Married",
                                   `3` = "Living Together", `4` = "Divorced", `5` = "Widowed", .other = "Wrong Input")) %>% 
  mutate(`Bednet Ownership` = recode(`Bednet Ownership`, `1` = "Yes", `2` = "No", .other = "Wrong Input")) %>% 
  mutate(Occupation = recode(Occupation, `1` = "Doctor", `2` = "Nurse",
                             `3` = "Midwife", `4` = "Lab Technician", `5` = "Community Health Worker", 
                             `6` = "Other", .other = "Wrong Input"))
str(response_db)
response_db %>% select(starts_with("sms")) %>% 
  str_to_title()



