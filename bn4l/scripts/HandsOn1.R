library(tidyverse)
library(here)
library(stringr)

sms_response <- read_csv("./data/bn4l_sms_responses.csv")
baseline <- read_csv("./data/bn4l_hcw_baseline_characteristics.csv")
head(sms_response)
head(baseline)
colnames(baseline)
nrow(baseline)

joined_df <- merge(baseline, sms_response, all = TRUE,
                   by.y = "Phone Number")
head(joined_df)

dplyr_join <- baseline %>% 
  left_join(sms_response, by = "Phone Number") %>% 
  glimpse()
view(dplyr_join)

dplyr_join %>% 
  select(1:6) %>%
  mutate()
  

dplyr_join %>% 
  select(`Study ID`, `Phone Number`, Age, Sex, Occupation, State, Residence, Ethnicity) %>%
  recode(Sex, "0" = "Male", "1" = "Female", .other = "Wrong Input") %>% 
  glimpse()


response_db <- dplyr_join %>% 
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
response_db$sms3_u5risk <- str_to_title(response_db$sms3_u5risk)
response_db$sms1_malaria <- str_to_title(response_db$sms1_malaria)
response_db$sms2_bednets <- str_to_title(response_db$sms2_bednets)


## Respondents Distribution by Gender
gender <- response_db %>% 
  count(Sex, sort = TRUE)
gender <- as.data.frame(gender)
gender


##Creating charts with highcharter
library(highcharter)

highchart() %>% 
  hc_add_series(gender, "pie", hcaes(name = Sex, y = n),
                name = "Count") %>% 
  hc_title(text = "Resppondent' Distribution by Gender", 
           margin = 20, align = "left", style = list(color = "darkblue", useHTML = TRUE))

## Respondents' Distribution by Age
hchart(response_db$Age, color = "black", name = "Age") %>% 
  hc_title(text = "Respondents' Distribution by Age", 
           margin = 20, align = "left", 
           style = list(color = "darkblue", useHTML = TRUE))


### Respondents' Distribution by Occupation
occupation <- response_db %>% 
  group_by(Occupation) %>% 
  count(Occupation, sort = TRUE)
occupation <- as.data.frame(occupation)

hchart(occupation, "column", hcaes(x = Occupation, y = n), name = "Count",
       colorByPoint = TRUE) %>% 
  hc_xAxis(title = list(text = "Occupation")) %>% 
  hc_yAxis(title = list(text = "Frequency")) %>% 
  hc_title(text = "Respondents' Distribution by Occupation",
           margin = 20, align = "left",
           style = list(color = "darkblue", useHTML = TRUE))


## Respondents' Distribution of Marital Status
marital_status <- response_db %>% 
  group_by(`Marital Status`) %>% 
  count(`Marital Status`, sort = TRUE)
marital_status <- as.data.frame(marital_status)

hchart(marital_status, "column", hcaes(x = `Marital Status`, y = n), name  = "Count",
       colorByPoint = TRUE) %>% 
  hc_xAxis(title = list(text = "Marital Status")) %>% 
  hc_yAxis(title = list(text = "Frequency")) %>% 
  hc_title(text = "Respondents' Distribution by Occupation",
           margin = 20, align = "left",
           style = list(color = "darkblue", useHTML = TRUE))


bednet <- response_db %>% 
  count(`Bednet Ownership`, State, sort = TRUE)
bednet <- as.data.frame(bednet)
names(bednet) <- c("Response", "State", "Frequency")

hchart(bednet, "column", hcaes(x = State, y = Frequency, group = Response)) %>% 
  hc_xAxis(title = list(text = "State")) %>% 
  hc_yAxis(title = list(text = "Frequency")) %>% 
  hc_title(text = "Respondents' Distribution by Bed Net Ownership", 
           margin = 20, align = "left",
           style = list(color = "darkblue", useHTML = TRUE))


## Respondents' Distribution by Number of Children with AGE Less than 5
hchart(response_db$`# of children < 5 in HH`, color = "black", name = "Age") %>% 
  hc_title(text = "Respondents' Distribution by Number of Children With Age Less Than 5", 
           margin = 20, align = "left", 
           style = list(color = "darkblue", useHTML = TRUE))

## Analysis of Key Research Question

sms1QuestionByState <- response_db %>% 
  count(sms1_malaria, State, sort = TRUE)
sms1QuestionByState_df = as.data.frame(sms1QuestionByState)
sms1QuestionByState_df
names(sms1QuestionByState_df) <- c("Response", "State", "Frequency")


hchart(sms1QuestionByState_df, "column", hcaes(x = State, y = Frequency, group = Response)) %>% 
  hc_xAxis(title = list(text = "State")) %>% 
  hc_yAxis(title = list(text = "Frequency"))



### Analysis of Key Research Question 2
sms2QuestionByState <- response_db %>% 
  count(sms2_bednets, State, sort = TRUE)
sms2QuestionByState_df = as.data.frame(sms2QuestionByState)
names(sms2QuestionByState_df) <- c("Response", "State", "Frequency")

hchart(sms2QuestionByState_df, "column", hcaes(x = State, y = Frequency, group = Response)) %>% 
  hc_xAxis(title = list(text = "State")) %>% 
  hc_yAxis(title = list(text = "Frequency"))

### Analysis of Key Research Question 3
sms3QuestionByState <- response_db %>% 
  count(sms3_u5risk, State, sort = TRUE)
sms3QuestionByState_df = as.data.frame(sms3QuestionByState)
names(sms3QuestionByState_df) <- c("Response", "State", "Frequency")

hchart(sms3QuestionByState_df, "column", hcaes(x = State, y = Frequency, group = Response)) %>% 
  hc_xAxis(title = list(text = "State")) %>% 
  hc_yAxis(title = list(text = "Frequeny"))



















