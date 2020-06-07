        ## Getting started with APIs in R - https://www.dataquest.io/blog/r-api-tutorial/
library(httr)
library(jsonlite)

## Requesting using the GET() function and specifying the API's URL:
res = GET("http://api.open-notify.org/astros.json")
res


## The data in it's current state in the res variable is not usable. The actual data is contained as raw Unicode in the res list. 
## To convert the raw Unicode into a character vector that resembles the JSON format shown above: The rawToChar() function.

rawToChar(res$content)

## While the resulting string looks messy, it's truly the JSON structure in character format

data <- fromJSON(rawToChar(res$content))
names(data)

## In our data variable, the data set that we're interested in looking at is contained in the people data frame. 
data$people


## Finding out when the ISS will be passing over the Brooklyn Bridge (lat = 40.7, lon = -74)
res <- GET("http://api.open-notify.org/iss-pass.json", 
           query = list(lat = 40.7, lon = -74))
data =  fromJSON(rawToChar(res$content))
data$response


### Accessin Rest Api (JSON data) using httr and jsonlite - https://rpubs.com/ankc/480665


library(rlist)
library(dplyr)
library(data.table)


jsonResponse <- GET("http://api.worldbank.org/country?per_page=10&region=OED&lendingtype=LNX&format=json")


res <- GET("http://api.worldbank.org/country",
           query = list(per_page = "32", region = "OED", lendingtype = "LNX", format = "json")) 



head(data_wdi$content)

http_type(res)
http_error(res)

resText <- content(res, as = "text") # JSON response structured into raw data
resText


resParsed <- content(res, as = "parsed")
resParsed

## Package jsonlite provides method fromJSON that facilitates the conversion of text into the data frame
data_wdi <- fromJSON(rawToChar(res$content))

## Verify if the obtained object is list or not
is.list(resParsed[[2]][[1]])

## Convert the parsed json response list to data table
df <- lapply(resParsed[[2]], as.data.table)

## Using rbindlist to convert the parsed json list into one data table
dt <- rbindlist(df, fill = TRUE)

## Using dplyr and base R to retrieve the data frame with selected columns
dt %>% 
  bind_rows %>% 
  select(id, iso2Code, name, region, incomeLevel, lendingType, capitalCity, longitude, latitude)

## rlist package proviodes list.select and list.stack method to filter columns and create tibble from the structured data frame
list.select(df, id, iso2Code, name)

##List.stack
list.stack(df)


## UK police data - https://medium.com/@traffordDataLab/querying-apis-in-r-39029b73d5f1
path <- "https://data.police.uk/api/crimes-street/burglary?"
request <- GET(url = path, 
               query = list(
                 lat = 53.421813,
                 lng = -2.330251,
                 date = "2018-05")
)
request$status_code
request$url

## Now we can parse the content returned from the server as text using the content function
response <- content(request, as = "text", encoding = "UTF-8")
response

## Then we'll parse the JSON content and convert it to a data frame
uk_police_df <- fromJSON(response, flatten = TRUE) %>% 
  data.frame()

colnames(uk_police_df)
head(uk_police_df)
str(uk_police_df)





















