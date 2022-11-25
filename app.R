library(shiny)
library(tidyverse)
library(DT)

bcl <- read.csv("https://raw.githubusercontent.com/daattali/shiny-server/master/bcl/data/bcl-data.csv")

ggplot(bcl, aes(Alcohol_Content)) + geom_histogram()

ui <- fluidPage(
  titlePanel("BC Liquor Store Data"),
  h5("Welcome to my shiny app!"),
  br(),
    sidebarPanel(
      sliderInput("priceInput", "Price", 0, 100,
                  value = c(25, 40), pre = "$"),
      radioButtons("typeInput", "Type",
                   choices = c("BEER", "REFRESHMENT",
                               "SPIRITS", "WINE")),
      # selectInput has been added which creates a select box widget allowing the user to select one or more countries to filter by.
      # This is useful because instead of scrolling through the table to find a certain country they can select the country and see only liquor from that country.
      selectInput("countryInput", "Select a country", choices = bcl$Country, selected = "CANADA", multiple = TRUE)
  ),
  # textOutput was used to create text above the histogram that shows how many results have been found based on their selections from the sidebar.
  # This is useful because the user doesn't have to scroll through the table to find the number of options based on their selections.
  textOutput("results"),

  mainPanel(
    plotOutput("alcohol_hist"),
    # The DT package was used to make the table interactive.
    # This is helpful since now the user can search for products in the table and see a selected number of products per page.
    DT::dataTableOutput("data_table")
    ),
  a(href = "https://github.com/daattali/shiny-server/tree/master/bcl", "Link to the original data set")
  )

server <- function(input, output) {

  output$countryOutput <- renderUI({
    selectInput("countryInput", "Country",
                sort(unique(bcl$Country)),
                selected = "CANADA")
  })

  filtered_data <- reactive({
    if (is.null(input$countryInput)) {
      return(NULL)
    }

    bcl %>% filter(Price > input$priceInput[1] &
                     Price < input$priceInput[2] &
                     Type == input$typeInput &
                     Country == input$countryInput)
    })

  observe({
    cat(input$priceInput)
    })

 output$alcohol_hist <-
   renderPlot({
     filtered_data() %>%
   ggplot(aes(Alcohol_Content)) +
       geom_histogram()
     })

 output$data_table <-
   DT::renderDataTable({
   filtered_data()
   })

 output$results <- renderText({
   paste("We found",(nrow(filtered_data())), "options for you.")
 })
}

shinyApp(ui = ui, server = server)
