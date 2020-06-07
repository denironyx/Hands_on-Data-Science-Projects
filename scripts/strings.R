
## Data cleaning
clean.names <- function(x){
  x %>% 
    str_remove_all('[:punct:]') %>% 
    str_to_lower() %>% 
    str_squish() %>% 
    str_trim()
}
clean.names(X)

X <- tibble( Cities = c("  New York City, NY", "Denver, CO;;") )

clean.names2 <- function( .df, .var ) {
  f <- compose( partial(str_remove_all, pattern='[:punct:]'), 
                str_to_lower, str_squish, str_trim )
  .df %>% mutate_at( vars(!!ensym(.var)), f )
}
clean.names2(X, "Cities")

##The first line creates a composite function by stringing together str_remove_all, str_to_lower, str_squish, str_trim and using partial() 
#to assign a prespecified value to the pattern parameter of str_remove_all. The resulting function f is identical to your original clean.names. 
#(I just tried to make clean.names2 self-contained.)
library(W)

#The second line applies the new composite function f (or equivalently, your original clean.names) to a single column in .df using mutate_at. 
#The column is specified using two tidyverse mechanisms. The first is vars(), which allows users to specify column names with and without quotes.
#For example, the following two lines are equivalent:

#The second mechanism belongs to the class of functions that deal with quasiquoatation, allowing programmers to work directly with unevaluated expressions,
#including those provided by the function users. In particular, we use ensym to capture a symbol provided to the function by the calling environment and pass that symbol to vars. 
#The !! is important, because it tells vars to go ahead and evaluate the expression ensym(.var) and use the result as the column name. Without !!, vars would be trying to find a column with the name "ensym(.var)" instead.