library(shiny)
library(tidyverse)
library(DT)
library(colourpicker)

bcl <- read.csv("https://raw.githubusercontent.com/daattali/shiny-server/master/bcl/data/bcl-data.csv")

ggplot(bcl, aes(Alcohol_Content)) + geom_histogram()

ui <- fluidPage(
  titlePanel("BC Liquor Store Data"),
  h5("Welcome to my shiny app!"),
  h5("Select your price range, beverage type(s), and one or more countries to see the results appear."),
  br(),
  sidebarPanel(
    sliderInput("priceInput", "Price", 0, 100,
                value = c(25, 40), pre = "$"),
    # The radio buttons were changed to checkboxes.
    # This is useful because it allows the user to select more than one type of beverage at a time.
    checkboxGroupInput("typeInput", "Type",
                 choices = c("BEER", "REFRESHMENT",
                             "SPIRITS", "WINE"),
                 selected = "BEER"),
    # selectInput has been added which creates a select box widget allowing the user to select one or more countries to filter by.
    # This is useful because instead of scrolling through the table to find a certain country they can select the country and see only liquor from that country.
    selectInput("countryInput", "Select a country", choices = bcl$Country, selected = "CANADA", multiple = TRUE),
   # colourInput was used to allow the user to change the colour of the histogram bars
     colourInput("col", "Choose a colour", "blue",
                returnName = TRUE,
                palette = "limited",
                closeOnClick = TRUE),
    # tags$img was used to add a picture of the interior of a BC Liquor store.
    # This is useful because it provides a visual to display what data is being used.
    tags$img(src='BCL-Interior-1282x727.jpg', height=218.1, width=384.6),
  ),
  # textOutput was used to create text above the histogram that shows how many results have been found based on their selections from the sidebar.
  # This is useful because the user doesn't have to scroll through the table to find the number of options based on their selections.
  textOutput("results"),


  mainPanel(
    plotOutput("alcohol_hist"),
    # The DT package was used to make the table interactive.
    # This is helpful since now the user can search for products in the table and see a select number of products per page.
     DT::dataTableOutput("data_table"),
    # downloadButton and downloadHandler were used to allow the user to download the results of their selection as a csv file.
    # This is useful because the user can refer to their options later offline.
    downloadButton('downloadData', label = "Download"),
    h5("Download the results in the table to refer to later.")
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
        geom_histogram(bg = input$col)
    })

  output$data_table <-
    DT::renderDataTable({
      filtered_data()
    })

  output$results <- renderText({
    paste("We found",(nrow(filtered_data())), "options for you.")
  })
  output$downloadData <- downloadHandler(
    filename = function(){
      paste("BCLiquorStore", "csv", sep = ".")
    },
    content = function(file){
      write.csv(filtered_data(), file)
    }
)
}


shinyApp(ui = ui, server = server)
