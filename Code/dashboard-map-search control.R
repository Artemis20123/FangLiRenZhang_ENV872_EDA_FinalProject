# the code is not successful and needs further adjustments

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
  dashboardHeader(title = "PM2.5 Distribution in Chinese Cities"),
  dashboardSidebar(
    selectInput(inputId = "year", 
                label = "Year",
                choices = unique(pm25_sf$year), 
                selected = "2000"),
    selectInput(inputId = "month", 
                label = "Month",
                choices = unique(pm25_sf$month), 
                selected = "1"),
    searchInput(inputId = "city_search",
                label = "Search City",
                placeholder = "Enter a city name",
                source = function(searchString, callback) {
                  res <- pm25_sf %>%
                    filter(str_detect(cityname, searchString)) %>%
                    distinct(cityname, .keep_all = TRUE)
                  callback(list(results = res$cityname))
                },
                searchOn = "click",
                cancelText = "Reset"
    )
  ),
  dashboardBody(
    fluidRow(
      box(
        title = "Map",
        status = "primary",
        solidHeader = TRUE,
        leafletOutput("map")
      )
    )
  )
)

# create server
server <- function(input, output, session) {
  # Reactive object for filtering PM2.5 data
  pm25_filtered <- reactive({
    pm25_sf %>%
      filter(year == input$year) %>%
      filter(month == input$month)
  })
  
  # Search for city and highlight on map
  observeEvent(input$city_search_searchresult, {
    selected_city <- pm25_sf %>%
      filter(cityname == input$city_search_searchresult$label)
    
    if(nrow(selected_city) > 0) {
      leafletProxy("map", session) %>%
        clearSelection() %>%
        setView(lng = selected_city$long, lat = selected_city$lat, zoom = 8) %>%
        selectize(TRUE) %>%
        selectGeoJSON(data = selected_city, 
                      options = pathOptions( color = "black",
                                             weight = 2,
                                             fillColor = "yellow",
                                             fillOpacity = 0.5),
                      layerId = selected_city$city_id) 
    }
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
                opacity = 0.7) %>%
      # Highlight city on search
      eventReactive(input$city_search, {
        if (!is.null(input$city_search_searchresult)) {
          cityname <- input$city_search_searchresult$label
          highlightOptions(
            layerId = pm25_filtered()$cityname[pm25_filtered()$cityname == cityname],
            weight = 5,
            color = "#666",
            dashArray = "",
            fillOpacity = 0.7,
            opacity = 1
          )
        }
      })
  })
}

shinyApp(ui = ui, server = server)