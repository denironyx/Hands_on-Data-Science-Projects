library(DT)
library(shiny)
library(shinydashboard)
library(data.table)
library(formattable)


ui <- dashboardPage(
  dashboardHeader(),
  dashboardSidebar(),
  dashboardBody(
    tabsetPanel(box(formattableOutput("dat"))
    )
  )
)

server <- function(input, output) {
  
  data <- head(mtcars)
  
  output$dat <- renderFormattable({
    formattable(data, list(
      disp = formatter("span", 
                       style = x ~ style(color = ifelse(x < 200, "green", "gray")))
    ))
  })
  
}


shinyApp(ui, server)