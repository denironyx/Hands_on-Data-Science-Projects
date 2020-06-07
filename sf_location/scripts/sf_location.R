#### - https://towardsdatascience.com/plotting-spatial-data-in-r-a38a405a07f1

## load the data in r
library(dplyr)
library(tidyr)
biz <- readr::read_csv("sf_location/data/sf_business_dataset.csv")
str(biz)
View(head(biz, 25))

### Identify data pertaining to San Francisco only
#By zip code logic
sf_biz_zip <- biz %>% 
  filter(grepl(pattern = 
                 "94016|94105|94110|94115|94119|94123|94127|94132|94139|94143|94147|94156|94161|94171|94102|94107|94108|94109|94111|94112|94114|94116|94117|94118|94120|94121|94122|94124|94125|94126|94129|94130|94131|94133|94134|94137|94140|94141|94142|94144|94145|94146|94151|94153|94154|94158|94159|94160|94162|94163|94164|94172|94177|94188", `Business Location`))
View(head(sf_biz_zip, 25))

## By city
sf_biz_city <- biz %>% 
  filter(grepl(".*San Francisco.*|.*SAN    FRANCISCO.*|.*SF.*|.*S SAN FRAN.*|.*Sf.*|.*San+francisco.*|.*S+san+fran.*", City))

## By Business Location
sf_biz_loc <- biz %>% 
  filter(grepl(".*San Francisco.*|.*SAN FRANCISCO.*|.*SF.*|.*S SAN FRAN.*|.*Sf.*|.*San+francisco.*|.*S+san+fran.*", `Business Location`))

## Converting date objects
sf_biz_zip$`Business Start Date` <- as.POSIXct(sf_biz_zip$`Business Start Date`, format = "%m/%d/%Y")

sf_biz_zip$`Business End Date` <- as.POSIXct(sf_biz_zip$`Business End Date`, format = "%m/%d/%Y")

sf_biz_zip$`Location Start Date` <- as.POSIXct(sf_biz_zip$`Location Start Date`, format = "%m/%d/%Y")

sf_biz_zip$`Location End Date` <- as.POSIXct(sf_biz_zip$`Location End Date`, format = "%m/%d/%Y")

## Filter out inactive businesses
# Businesses which seized to exist after December 1, 2018 were eliminated
sf_biz_active_zip <- sf_biz_zip %>% filter(is.na(`Location End Date`))
sf_biz_active_zip <- sf_biz_zip %>% filter(`Location Start Date` < "2018-12-01")


## Stripping out coordinates from the Business Location
# The Business Location column contained addresses along with the coordinates information. 
# So the latitude and longitude information needed to be extracted.

sf_biz_active_zip <- sf_biz_active_zip %>%
  separate(`Business Location`, c('Address', 'Location'), sep = '[(]')

sf_biz_active_zip <- sf_biz_active_zip %>% 
  filter(!(is.na(Location)))

sf_biz_active_zip <- separate(data = sf_biz_active_zip, col = Location, into = c("Latitude", "Longitude"), sep = ",")

## Other characters needed to be cleaned out too
sf_biz_active_zip$Longitude <- gsub(sf_biz_active_zip$Longitude, pattern = "[)]", replacement = "")
  
## Convert latitude and longitude variables from discrete to continous and stored them as numerical variables
sf_biz_active_zip$Latitude <- as.numeric(sf_biz_active_zip$Latitude)
sf_biz_active_zip$Longitude <- as.numeric(sf_biz_active_zip$Longitude)

viz <- sf_biz_active_zip %>% 
  group_by(`Neighborhoods - Analysis Boundaries`) %>% 
  tally() %>% 
  arrange(desc(n))

col.names(viz)[2] <- "Total Businesses"

viz1 = viz
colnames(viz1) <- c("Neighbour", "Total_Businesses")

VIZ2 <- viz1[1:10,]
head(VIZ2)

library(ggplot2)
fin_plot <- ggplot(VIZ2, aes(x = Neighbour, y = Total_Businesses)) + geom_bar(stat = "identity", fill = "#00bc6c")

fin_plot <- fin_plot + geom_text(aes(label = Total_Businesses), vjust = -0.2) + theme(axis.text.x = element_text(angle = 45, size = 9, hjust = 1), plot.title = element_text(hjust = 0.5))

fin_plot <- fin_plot + ggtitle("Top 10 neighborhoods by business count", size = 2)

fin_plot

head(VIZ2)












