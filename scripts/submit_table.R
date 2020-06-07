library(data.table)
library(tidyverse)
library(lubridate)


submit_table <- function(.input_df, .model_df) {
  .input_df %>% 
    mutate(row = row_number()) %>% ## Initiate rows number and assigned it to the row column 
    pivot_longer(cols = -matches('^Modified$|^Product$|^row$'), names_to = c('date', '.value'), names_sep = '\n')  %>% ### Convert the wide data format into long format. i.e convert the 30+ columns to the eight
    left_join(.model_df, by = 'Product') %>% ## 9 wide columns with the ninth column being model_weight function of the product
    mutate(Weight = pmap_dbl(
      list(model_weight = model_weight, waste = Waste, punnets = Punnets), 
      function(model_weight, waste, punnets) {
        if (purrr::every(list(model_weight, waste, punnets), function(x)
          ! is.null(x))) {
          model_weight(punnets = punnets, waste = waste / 100) %>% round(digits = 1)
        } else {
          NA_real_
        }
      }), 
      Time = (Weight * 1000) %>% hms::as_hms() %>% hms::round_hms(60) %>% str_remove(':\\d{2}$')
    ) %>% ## Populate the values of Weight and Time
    arrange(row) %>% 
    select(-model_weight) %>% ## Remove the model_weight column
    pivot_wider(names_from = date, values_from = c(Punnets, Waste, Weight, Time), names_sep = '-') %>% ## Convert the long table of 9 columns to wider table of 31 columns 
    rename_all(function(x) str_replace(x, '(^.*)-(.*$)', '\\2\n\\1')) %>% ## Rename the column
    select(colnames(.input_df)) ## WE have 30 columns now. After removing row column
}



submit_table(df_input_dummy_value, df_models) %>% 
  View()

# SETUP INITIAL DATA ====

# setup mock vector of product names
vector_product_names <- c('Product1', 'Product2', 'Product3', 'Product4')


# initialize vector of dates
date_range <- seq.Date(from = Sys.Date(), length.out = 7, by = 'day')
date_cols <- date_range %>% format('%a') %>% as.character() %>% paste0('(', ., ')')

#initialize df to be used to initaily populate
df_measures_dummy_value <- purrr::map(date_cols, function(x) {
  tibble(
    Punnets = 100,
    Waste =  5,
    Weight = NA_real_, 
    Time = NA_character_
  ) %>% 
    purrr::set_names(function(y) paste0(x, '\n', y))
}) %>% 
  reduce(bind_cols)

# initialize df to be used to initially populate the rhandsontable
df_input_dummy_value <- tibble(
  Modified = Sys.time(),
  Product = 'Product1'
) %>% 
  bind_cols(
    df_measures_dummy_value
  ) %>% 
  slice(rep(1,5))



#> Setup model df ----

# create a tibble containing fake models for each products
df_models <- tibble(
  Product = c('Product1', 'Product2', 'Product3', 'Product4'),
  model_weight = c(
    function(punnets, waste) (1 / (1 - waste)) * (0.5*punnets),
    function(punnets, waste) (1 / (1 - waste)) * (0.3*punnets),
    function(punnets, waste) (1 / (1 - waste)) * (0.75*punnets),
    function(punnets, waste) (1 / (1 - waste)) * (1*punnets)
  )
)


submit_table(df_input_dummy_value, df_models) %>% 
 View()
df_input_init


