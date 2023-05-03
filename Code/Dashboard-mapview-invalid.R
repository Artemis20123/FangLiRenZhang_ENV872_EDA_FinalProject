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

# create spatial object
#pm25_sf <- st_as_sf(merged_data) %>%
#  st_set_crs(st_crs(4326))

# test plot
test <- pm25_sf %>%
  filter(year == 2000, month ==2)
mapview(test, 
        zcol = 'meanPM', 
        col.regions = brewer.pal(9, 'Reds'),
        map.types = "OpenStreetMap")

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
    mapview(pm25_filtered(), zcol = 'meanPM', 
            col.regions = brewer.pal(9, 'Reds'),
            map.types = "OpenStreetMap")
  })
}


shinyApp(ui = ui, server = server)
