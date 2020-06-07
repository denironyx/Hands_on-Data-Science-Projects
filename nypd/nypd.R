library(readr)
mvc <- read_csv("nypd/data/nypd_mvc_2018.csv")
na.logical <- is.na(mvc)


######
library(dplyr)
mvc_na <- data.frame(is.na(mvc))
mvc_na_injured <- mvc_na %>% 
  mutate(total_na_injured = rowSums(.[9:11]))
head(mvc_na_injured)

top_n(mvc)
?top_n
df <- data.frame(x = c(10, 1, 3, 1, 15,6, 11, 1))
df %>% 
  top_n(3)





### Summary of NA's in the dataset

na_counts  <-  mvc %>% is.na() %>% colSums()
head(na_counts)
colnames(mvc)


na_counts_pct <- na_counts * 100 / nrow(mvc)
na_df <- data.frame(na_counts = na_counts,
                    na_pct = na_counts_pct)

## Rotate the dataframe so that rows become columns and vice-versa
na_df <- data.frame(t(na_df))





#####################

killed <- mvc %>% select(ends_with("_killed"))
killed_non_eq <- killed %>% 
  mutate(manual_sum = rowSums(.[1:3])) %>% 
  filter(manual_sum != total_killed | is.na(total_killed))

head(killed_non_eq)


## fix the killed values
killed_non_eq <- killed_non_eq %>% 
  mutate(total_killed = if_else(is.na(total_killed), manual_sum, total_killed))
head(killed_non_eq)

killed_non_eq <- killed_non_eq %>%
  mutate(total_killed = if_else(total_killed != manual_sum, NaN, total_killed ))

# Create an injured_non_eq dataframe and manually sum values
injured  <-  mvc %>% select(ends_with("_injured"))

injured_non_eq <- injured %>% 
  mutate(manual_sum = rowSums(.[1:3])) %>%
  filter(manual_sum != total_injured | is.na(total_injured))
injured_non_eq <- injured_non_eq %>%
  mutate(total_injured = if_else(is.na(total_injured), manual_sum, total_injured ))


injured_non_eq <- injured_non_eq %>%
  mutate(total_injured = if_else(total_injured != manual_sum, NaN, total_injured ))

####### Alternative approach
library(purrr)

mvc_na2 <- map_df(mvc, function(x) as.numeric(is.na(x)))
library(tidyr)

mvc_na_heat <- mvc_na2 %>%
  gather(key=x) %>%
  group_by(x) %>%
  mutate(y = row_number())


plot_na_matrix <- function(df) {
  # Preparing the dataframe for heatmaps 
  df_heat <- df %>%
    gather(key=x) %>%
    group_by(x) %>%
    mutate(y = row_number())
  
  # Ensuring the order of columns is kept as it is
  df_heat <- df_heat %>%
    ungroup() %>%
    mutate(x = factor(x,levels = colnames(df)))
  
  # Plotting data
  g <- ggplot(data = df_heat, aes(x=x, y=y, fill=value)) + 
    geom_tile() + 
    theme(legend.position = "none",
          axis.title.y=element_blank(),
          axis.text.y =element_blank(),
          axis.ticks.y=element_blank(),
          axis.title.x=element_blank(),
          axis.text.x = element_text(angle = 90, hjust = 1))
  
  # Returning the plot
  g
}
  
library(ggplot2)

mvc_na_vehicle <- mvc_na2 %>% select(contains("vehicle"))
plot_na_matrix(mvc_na_vehicle)



############

library(readr)

sup_data  <-  read_csv('nypd/data/supplemental_data.csv')
head(sup_data)

location_cols  <-  c('location', 'on_street', 'off_street', 'borough')
na_before  <-  colSums(is.na(mvc[location_cols]))
for (col in location_cols ) {
  mvc[is.na(mvc[col]),col] <- sup_data[is.na(mvc[col]),col]
}

na_after  <-  colSums(is.na(mvc[location_cols]))


























