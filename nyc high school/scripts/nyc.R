library(dplyr)
library(stringr)
library(readr)

sat_results <- read_csv("nyc high school/data/sat_results.csv")
ap_2010 <- read_csv("nyc high school/data/ap_2010.csv")
class_size <- read_csv("nyc high school/data/class_size.csv")
demographies <- read_csv("nyc high school/data/demographics.csv")
graduation <- read_csv("nyc high school/data/graduation.csv")
hs_directory <- read_csv("nyc high school/data/hs_directory.csv")

## Do we need to create any new variables
sat_results <- sat_results %>% 
  mutate(`Num of SAT Test Takers` = as.numeric(`Num of SAT Test Takers`),
         `SAT Critical Reading Avg. Score` = as.numeric(`SAT Critical Reading Avg. Score`),
         `SAT Math Avg. Score` = as.numeric(`SAT Math Avg. Score`),
         `SAT Writing Avg. Score` = as.numeric(`SAT Writing Avg. Score`)) %>% 
  mutate(avg_sat_score = `SAT Critical Reading Avg. Score` + `SAT Math Avg. Score` + `SAT Writing Avg. Score`)

## Data cleaning for the ap_2010 data frame
head(ap_2010)
str(ap_2010)

ap_2010 <- ap_2010 %>% 
  mutate_at(3:5, as.numeric) %>% 
  mutate(exams_per_student = `Total Exams Taken` / `AP Test Takers`) %>% 
  mutate(high_score_persent = (`Number of Exams with scores 3 4 or 5` / `Total Exams Taken`) * 100)
glimpse(ap_2010)


## Class size
class_size <- class_size %>% 
  filter(GRADE == "09-12", `PROGRAM TYPE` == "GEN ED")

class_size <- class_size %>%
  group_by(CSD, `SCHOOL CODE`, `SCHOOL NAME`) %>%
  summarize(avg_class_size = mean(`AVERAGE CLASS SIZE`), 
            avg_largest_class = mean(`SIZE OF LARGEST CLASS`),
            avg_smallest_class = mean(`SIZE OF SMALLEST CLASS`))


class_size <- class_size %>%
  mutate(DBN = str_c(CSD, `SCHOOL CODE`, sep = "")) %>%
  mutate(DBN = str_pad(DBN, width = 6, side = 'left', pad = "0"))



graduation <- graduation %>%
  filter(Cohort == "2006" & Demographic == "Total Cohort") %>%
  select(DBN, `School Name`, `Total Grads - % of cohort`, `Dropped Out - % of cohort`)

demographics <- demographies %>%
  filter(schoolyear == "20112012" & grade9 != "NA") %>%
  select(DBN, Name, frl_percent, total_enrollment, ell_percent, 
         sped_percent, asian_per, black_per, 
         hispanic_per, white_per, male_per, female_per)

hs_directory <- hs_directory %>%
  rename(DBN = dbn) %>%
  select(DBN, school_name, `Location 1`)


ny_schools <- list(sat_results, ap_2010, class_size, demographics, graduation, hs_directory)
names(ny_schools) <- c("sat_results", "ap_2010", "class_size", "demographics", "graduation", "hs_directory")

duplicate_DBN <- ny_schools %>%
  map(mutate, is_dup = duplicated(DBN))  %>%
  map(filter, is_dup == "TRUE")

ap_2010 %>% 
  mutate(is_dup = duplicated(DBN)) %>% 
  filter(is_dup == "TRUE")


## Filter the ap_2010 dataframe
ap_2010 <- ap_2010 %>%
  filter(SchoolName != "YOUNG WOMEN'S LEADERSHIP SCH")


















