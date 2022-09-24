##https://cran.r-project.org/web/packages/httr/vignettes/api-packages.html
#https://rpubs.com/plantagenet/481658
##

## Send a simple request
library(httr)
github_api <- function(path){
  url <- modify_url("https://api.github.com", path = path)
  GET(url)
}

resp <-  github_api("/repos/hadley/httr") 
resp
## Alternative 
GET("https://api.github.com/repos/hadley/httr")

## Parse the response
http_type(resp)

##Checking the type is as you expect in the helper function. Which will ensure that we get a clear error message if the API changes
github_api <- function(path){
  url <- modify_url("https://api.github.com", path = path)
  resp <- GET(url)
  if(http_type(resp) != "application/json"){
    stop("API did not return json", call. = FALSE)
  }else{
    print("Good")
  }
    resp
  }
github_api("/repos/hadley/httr")


## Some poorly written APIs will say the content is type A, but it will actually be type B.
#To parse json, use jsonlite package
#To parse xml, use the xml2 package
github_api <- function(path) {
  url <- modify_url("https://api.github.com", path = path)
  
  resp <- GET(url)
  if(http_type(resp) != "application/json"){
    stop("API did not return json", call. = FALSE)
  }
  jsonlite::fromJSON(content(resp, "text"), simplifyVector = FALSE)
}

github_api <- function(path){
  ## Creating API url
  url <- modify_url("https://api.github.com", path = path)
  #Sending and getting response with the API
  resp <- GET(url)
  #Develop a helper function to check the type of format the data is parse (json or xml)
  if(http_type(resp) != "application/json"){
    stop("API did not return json", call. = FALSE)
  }
  ## Some poorly written APIs will say the content is type A, but it will actually be type B.
  parsed <- jsonlite::fromJSON(content(resp, "text"), simplifyVector = FALSE)
  
  ## Creating a simple S3 object
  structure(
    list(
      content = parsed,
      path = path,
      response = resp
    ),
    class = "github_api"
  )
}
print.github_api <- function(x, ...){
  cat("Github ", x$path, ">\n", sep = "")
  str(x$content)
  invisible(x)
}
github_api("/users/hadley")
github_api("/repos/hadley/httr")

## The API might return invalid data, but this should be rare,so you can just rely on the parser to provide a useful error message
## Point of failure 
# - Client-side exceptions
# - Network / communication exceptions
# - Server-side exceptions

github_api <- function(path){
  url <- modify_url("https://api.github.com", path = path)
  resp <- GET(url)
  if(http_type(resp) != "application/json"){
    stop("API did not return json", call. = FALSE)
  }
  parsed <- jsonlite::fromJSON(content(resp, "text"), simplifyVector = TRUE)
  
  if(http_error(resp)){
    stop(
      sprintf(
        "Github API request failed [%s]\n%s\n<%s>",
        status_code(resp),
        parsed$message,
        parsed$documentation_url
      ),
      call. = FALSE
    )
  }
  structure(
    list(
      content = parsed,
      path = path, 
      response = resp
    ),
    class = "github_api"
  )
}
github_api("/user/hadley")

ua <- user_agent("http://github.com/hadley/httr")
ua
#> <request>
#> Options:
#> * useragent: http://github.com/hadley/httr

github_api <- function(path) {
  url <- modify_url("https://api.github.com", path = path)
  
  resp <- GET(url, ua)
  if (http_type(resp) != "application/json") {
    stop("API did not return json", call. = FALSE)
  }
  
  parsed <- jsonlite::fromJSON(content(resp, "text"), simplifyVector = FALSE)
  
  if (status_code(resp) != 200) {
    stop(
      sprintf(
        "GitHub API request failed [%s]\n%s\n<%s>", 
        status_code(resp),
        parsed$message,
        parsed$documentation_url
      ),
      call. = FALSE
    )
  }
  
  structure(
    list(
      content = parsed,
      path = path,
      response = resp
    ),
    class = "github_api"
  )
}







































