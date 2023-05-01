
library(DT)
library(shiny)
library(shinydashboard)
library(leaflet)
library(shiny)
library(leaflet)
library(tidyverse)
library(lubridate)
library(ggpubr)
Sys.setenv(LANG = "en")
getwd()
# Wrangling ##############
#data <- read.table("./Project/PM2.5_daily_city_2000_2021.txt", sep = ",", header = TRUE)
#forcast.txt <- read.table("./Project/all_forcast.txt", sep = ",", header = TRUE)
#write.csv(data, "./Project/PM2.5_2000_2021.csv", row.names = F)
#write.csv(forcast.txt, "./Project/forcast.csv", row.names = F)

# Clean PM2.5 data
pm2.5daily <- read.csv("./Data/Processed/PM2.5_daily_city_2000_2021.csv")
cities <- pm2.5daily %>%
  filter(city_id %in% c("1100","4401","4403","5101","3100","1200","5000")) %>%
  group_by(city_id, year, month) %>%
  summarise(mean = mean(meanpm))
cities$date <- as.Date(paste(cities$year, cities$month, "01", sep = "-"), format = "%Y-%m-%d")

# Clean forcast data 
forcast <- read.csv("./Data/Processed/all_forcast.csv")
forcast$Date <- ymd(forcast$Date)
forcast <- forcast %>%
  mutate(year = year(Date)) %>%
  pivot_longer(cols = starts_with("R_"), names_to = "city", values_to = "pm2.5")
forcast$city <- gsub("R_","",forcast$city)

# TSA Visualization of Each City ################################################
beijing <- cities %>%
  filter(city_id == "1100") %>%
  ggplot(aes(x = date, y = mean)) +
  geom_line() +
  scale_x_date(date_labels = "%Y", date_breaks = "4 year") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(x = "Year", y = "Monthly PM2.5", title = "Monthly PM2.5 of Beijing")

guangzhou <- cities %>%
  filter(city_id == "4401") %>%
  ggplot(aes(x = date, y = mean)) +
  geom_line() +
  scale_x_date(date_labels = "%Y", date_breaks = "4 year") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(x = "Year", y = "Monthly PM2.5", title = "Monthly PM2.5 of Guangzhou")

shenzhen <- cities %>%
  filter(city_id == "4403") %>%
  ggplot(aes(x = date, y = mean)) +
  geom_line() +
  scale_x_date(date_labels = "%Y", date_breaks = "4 year") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(x = "Year", y = "Monthly PM2.5", title = "Monthly PM2.5 of Shenzhen")

chengdu <- cities %>%
  filter(city_id == "5101") %>%
  ggplot(aes(x = date, y = mean)) +
  geom_line() +
  scale_x_date(date_labels = "%Y", date_breaks = "4 year") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(x = "Year", y = "Monthly PM2.5", title = "Monthly PM2.5 of Chengdu")

shanghai <- cities %>%
  filter(city_id == "3100") %>%
  ggplot(aes(x = date, y = mean)) +
  geom_line() +
  scale_x_date(date_labels = "%Y", date_breaks = "4 year") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(x = "Year", y = "Monthly PM2.5", title = "Monthly PM2.5 of Shanghai")

tianjin <- cities %>%
  filter(city_id == "1200") %>%
  ggplot(aes(x = date, y = mean)) +
  geom_line() +
  scale_x_date(date_labels = "%Y", date_breaks = "4 year") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(x = "Year", y = "Monthly PM2.5", title = "Monthly PM2.5 of Tianjin")

chongqing <- cities %>%
  filter(city_id == "5000") %>%
  ggplot(aes(x = date, y = mean)) +
  geom_line() +
  scale_x_date(date_labels = "%Y", date_breaks = "4 year") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(x = "Year", y = "Monthly PM2.5", title = "Monthly PM2.5 of Chongqing")

ggarrange(beijing, chengdu, chongqing, guangzhou, shanghai, shenzhen, tianjin,
          ncol = 3, nrow = 3)

# Dashboard ############## 
## UI ######################################################################
ui <- fluidPage(
  titlePanel("PM2.5 Distribution in China"),
  fluidRow(
    column(width = 3,
           wellPanel(
             h4("PM2.5 National Distribution"),
             sliderInput("slider1", "Choose Year", 
                         min = 1, max = 100, value = 50)
           ),
           wellPanel(
             h4("Time Series Visualization by City"),
             selectInput("dropdown1", "Choose City", 
                         choices = c("Beijing", "Chongqing",
                                     "Chengdu", "Guangzhou", 
                                     "Shanghai", "Shenzhen", 
                                     "Tianjin"))
           ),
           wellPanel(
             h4("PM2.5 Prediction by City"),
             selectInput("dropdown2", "Choose City", 
                         choices = c("Beijing", "Chongqing", 
                                     "Chengdu","Guangzhou",
                                     "Shanghai","Shenzhen",
                                     "Tianjin")),
             sliderInput("slider2", "Choose Year", 
                         min = 2022, max = 2026, value = c(2022,2024), step = 1)
           )
    ),
    column(width = 9,
           tabsetPanel(
             tabPanel("Map", leafletOutput("map", height = "650px")),
             tabPanel("TSA", plotOutput("city_plot")),
             tabPanel("Prediction", plotOutput("prediction_plot"))
           )
    )
  )
)

## Server #####################################################################
server <- function(input, output) {
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      setView(lng = -118.5, lat = 38.5, zoom = 7)
  })
  output$city_plot <- renderPlot({
    if (input$dropdown1 == "Beijing") {
      cities %>%
        filter(city_id == "1100") %>%
        ggplot(aes(x = date, y = mean)) +
        geom_line() +
        scale_x_date(date_labels = "%Y", date_breaks = "1 year") +
        theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
        labs(x = "Year", y = "Monthly PM2.5", title = "Monthly PM2.5 of Beijing")
    } else if (input$dropdown1 == "Chongqing") {
      cities %>%
        filter(city_id == "5000") %>%
        ggplot(aes(x = date, y = mean)) +
        geom_line() +
        scale_x_date(date_labels = "%Y", date_breaks = "1 year") +
        theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
        labs(x = "Year", y = "Monthly PM2.5", title = "Monthly PM2.5 of Chongqing")
    } else if (input$dropdown1 == "Chengdu") {
      cities %>%
        filter(city_id == "5101") %>%
        ggplot(aes(x = date, y = mean)) +
        geom_line() +
        scale_x_date(date_labels = "%Y", date_breaks = "1 year") +
        theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
        labs(x = "Year", y = "Monthly PM2.5", title = "Monthly PM2.5 of Chengdu")
    } else if (input$dropdown1 == "Guangzhou") {
      cities %>%
        filter(city_id == "4401") %>%
        ggplot(aes(x = date, y = mean)) +
        geom_line() +
        scale_x_date(date_labels = "%Y", date_breaks = "1 year") +
        theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
        labs(x = "Year", y = "Monthly PM2.5", title = "Monthly PM2.5 of Guangzhou")
    } else if (input$dropdown1 == "Shanghai") {
      cities %>%
        filter(city_id == "3100") %>%
        ggplot(aes(x = date, y = mean)) +
        geom_line() +
        scale_x_date(date_labels = "%Y", date_breaks = "1 year") +
        theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
        labs(x = "Year", y = "Monthly PM2.5", title = "Monthly PM2.5 of Shanghai")
    } else if (input$dropdown1 == "Shenzhen") {
      cities %>%
        filter(city_id == "4403") %>%
        ggplot(aes(x = date, y = mean)) +
        geom_line() +
        scale_x_date(date_labels = "%Y", date_breaks = "1 year") +
        theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
        labs(x = "Year", y = "Monthly PM2.5", title = "Monthly PM2.5 of Shenzhen")
    } else if (input$dropdown1 == "Tianjin") {
      cities %>%
        filter(city_id == "1200") %>%
        ggplot(aes(x = date, y = mean)) +
        geom_line() +
        scale_x_date(date_labels = "%Y", date_breaks = "1 year") +
        theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
        labs(x = "Year", y = "Monthly PM2.5", title = "Monthly PM2.5 of Tianjin")
    }
  })
  filtered_data <- reactive({
    forcast %>%
      filter(city == input$dropdown2,
             year >= input$slider2[1],
             year <= input$slider2[2])
  })
  output$prediction_plot <- renderPlot({
    ggplot(filtered_data(), aes(x = Date, y = pm2.5)) +
      geom_line() +
      geom_smooth(method = "lm", se = F) +
      scale_x_date(date_labels = "%Y - %m", date_breaks = "3 month") +
      theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
      labs(x = "Year", y = "Monthly PM2.5", title = "Predicted PM2.5")
  })
}

shinyApp(ui = ui, server = server)








