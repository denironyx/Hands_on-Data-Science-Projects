library(readr)
scores <- read_csv("scripts/scores.csv")

is_it_friday <- function(){
  if(weekdays(Sys.Date()) == 'Friday'){
    print('Yes :D')
  }else{
    print('No :(')
  }
}

bad <- data.frame(cbind(a = 1:2, b = c("a", "b")))
bad
str(bad)
good <- data.frame(a = 1:2, b = c("a", "b"),
                   stringsAsFactors = FALSE)
good
str(good)

good2 <- data.frame(a = 1:2, b = c("a", "b"))
good2
str(good2)
