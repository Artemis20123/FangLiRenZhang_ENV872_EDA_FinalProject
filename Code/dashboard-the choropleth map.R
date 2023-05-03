library(shinydashboard)
library(mapview)
library(sf)
library(RColorBrewer)
library(tidyverse)

# load data
pm25_data <- read.csv("Data/Processed/PM2.5_monthly_city_2000_2021.csv")
city_boundaries <- st_read('Data/Raw/2000china_city_map/map/city_dingel_2000.shp') %>% 
  filter(!city_id %in% c('469037','469038','469039'))

# merge datasets
pm25_sf <- merge(city_boundaries,pm25_data, by = "city_id")


# create UI
ui <- dashboardPage(
  dashboardHeader(
    title = "PM2.5 Distribution in Chinese Cities",
    dropdownMenu(type = "messages", badgeStatus = "success",
                 messageItem("Support Team",
                             "This is the content of a message.",
                             time = "5 mins"
                 ),
                 messageItem("Support Team",
                             "This is the content of another message.",
                             time = "2 hours"
                 ),
                 messageItem("New User",
                             "Can I get some help?",
                             time = "Today"
                 )
    ),
    
    # Dropdown menu for notifications
    dropdownMenu(type = "notifications", badgeStatus = "warning",
                 notificationItem(icon = icon("users"), status = "info",
                                  "5 new members joined today"
                 ),
                 notificationItem(icon = icon("warning"), status = "danger",
                                  "Resource usage near limit."
                 ),
                 notificationItem(icon = icon("shopping-cart", lib = "glyphicon"),
                                  status = "success", "25 sales made"
                 ),
                 notificationItem(icon = icon("user", lib = "glyphicon"),
                                  status = "danger", "You changed your username"
                 )
    ),
    
    # Dropdown menu for tasks, with progress bar
    dropdownMenu(type = "tasks", badgeStatus = "danger",
                 taskItem(value = 20, color = "aqua",
                          "Refactor code"
                 ),
                 taskItem(value = 40, color = "green",
                          "Design new layout"
                 ),
                 taskItem(value = 60, color = "yellow",
                          "Another task"
                 ),
                 taskItem(value = 80, color = "red",
                          "Write documentation"
                 )
    )
  ),
  dashboardSidebar(
    selectInput(inputId = "year", 
                label = "Year",
                choices = unique(pm25_sf$year), 
                selected = "2000"),
    selectInput(inputId = "month", 
                label = "Month",
                choices = unique(pm25_sf$month), 
                selected = "1")
  ),
  dashboardBody(
    fluidRow(
      box(
        title = "Map",
        status = "primary",
        solidHeader = TRUE,
        leafletOutput("map")
      )
    ),
    tabItem(
      tabName = "documentation",
      h2("Dashboard Documentation"),
      p("This dashboard displays the distribution of PM2.5 in Chinese cities from 2000 to 2021."),
      p("To use the dashboard, select a year and month using the dropdown menus in the sidebar. The map will display the mean PM2.5 concentration for each city in the selected year and month."),
      p("For more information, please see the following resources:"),
      p(a("GitHub repository", href = "https://github.com/yourusername/yourrepository")),
      p(a("Knit PDF of wrangling code", href = "https://yourdomain.com/yourfile.pdf"))
    )
  )
)


# create server
server <- function(input, output) {
  # Reactive object for filtering PM2.5 data
  pm25_filtered <- reactive({
    pm25_sf %>%
      filter(year == input$year) %>%
      filter(month == input$month)
  })
  
  
  # Render leaflet map
  output$map <- renderLeaflet({
    pal <- colorNumeric(palette = "Reds", domain = pm25_filtered()$meanPM)
    leaflet(options = leafletOptions(opacity = 0.5)) %>%
      addTiles() %>%
      addPolygons(data = pm25_filtered(), 
                  fillColor = ~pal(meanPM), 
                  fillOpacity = 0.7,
                  color = "black",
                  weight = 0.5,
                  popup = paste("<b>City Code:</b> ", pm25_filtered()$city_id, "<br>",
                                "<b>市:</b> ", pm25_filtered()$`地级单位名称`, "<br>",
                                "<b>City:</b> ", pm25_filtered()$cityname, "<br>",
                                "<b>Mean PM2.5 concentration:</b> ", round(pm25_filtered()$meanPM, 2), " µg/m3<br>",
                                "<b>Rank:</b> ", rank(pm25_filtered()$meanPM))) %>%
      addLegend("bottomright",
                pal = pal,
                values = pm25_filtered()$meanPM,
                title = "PM2.5 (µg/m3)",
                opacity = 0.7)
  })
}

shinyApp(ui = ui, server = server)