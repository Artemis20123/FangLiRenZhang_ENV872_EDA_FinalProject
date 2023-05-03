
# Install and load packages ######################
pacman::p_load(DT,shiny,shinydashboard,leaflet,tidyverse,lubridate,ggpubr,sf,RColorBrewer)

getwd()

# Data preparation: Panel 1: Map ##############
## load data
pm25_data <- read.csv("Data/Processed/PM2.5_monthly_city_2000_2021.csv")
city_boundaries <- st_read('Data/Raw/2000china_city_map/map/city_dingel_2000.shp') %>% 
  filter(!city_id %in% c('469037','469038','469039'))

## merge datasets
pm25_sf <- merge(city_boundaries,pm25_data, by = "city_id")


# Data preparation: Panel 2-3: TSA & Prediction ##############
## Wrangling ##############
## Clean PM2.5 data
cities <- pm25_data %>%
  filter(city_id %in% c("1100","4401","4403","5101","3100","1200","5000")) %>%
  group_by(city_id, year, month) %>%
  summarise(mean = mean(meanPM))
cities$date <- as.Date(paste(cities$year, cities$month, "01", sep = "-"), format = "%Y-%m-%d")

## Clean forcast data 
forcast <- read.csv("./Data/Processed/all_forcast.csv")
forcast$Date <- ymd(forcast$Date)
forcast <- forcast %>%
  mutate(year = year(Date)) %>%
  pivot_longer(cols = starts_with("R_"), names_to = "city", values_to = "pm2.5")
forcast$city <- gsub("R_","",forcast$city)


# Dashboard ############## 
## UI ######################################################################
ui <- dashboardPage(
  dashboardHeader(
    title = "PM2.5 Distribution in China",
    titleWidth = 300,
    # display the author names
    dropdownMenu(type = "messages", badgeStatus = NULL,
                 headerText = "Authors",
                 messageItem("Yixin Fang",
                             "yixin.fang@duke.edu",
                             time = "iMEP Duke"
                 ),
                 messageItem("Jiahuan Li",
                             "jiahuan.li@duke.edu",
                             time = "iMEP Duke"
                 ),
                 messageItem("Yuxiang Ren",
                             "yuxiang.ren@duke.edu",
                             time = "iMEP Duke"
                 ),
                 messageItem("Jinglin Zhang",
                             "jinglin.zhang@duke.edu",
                             time = "iMEP Duke"
                 )
    )
  ),
  # display the inputs for 3 panels in different sections
  dashboardSidebar(
     width = 300,
     wellPanel(
       h4("PM2.5 National Distribution"),
       selectInput(inputId = "year", 
                   label = "Year",
                   choices = unique(pm25_sf$year), 
                   selected = "2000"),
       selectInput(inputId = "month", 
                   label = "Month",
                   choices = unique(pm25_sf$month), 
                   selected = "1"),
       style = "background-color: #2C3E50;"
     ),
     wellPanel(
       h4("Time Series Visualization by City"),
       selectInput("dropdown1", "Choose City", 
                   choices = c("Beijing", "Chongqing",
                               "Chengdu", "Guangzhou", 
                               "Shanghai", "Shenzhen", 
                               "Tianjin")),
       style = "background-color: #2C3E50;"
     ),
     wellPanel(
       h4("PM2.5 Prediction by City"),
       selectInput("dropdown2", "Choose City", 
                   choices = c("Beijing", "Chongqing", 
                               "Chengdu","Guangzhou",
                               "Shanghai","Shenzhen",
                               "Tianjin")),
       sliderInput("slider2", "Choose Year", 
                   min = 2022, max = 2026, value = c(2022,2024), step = 1),
       style = "background-color: #2C3E50;"
     )
  ),
  # display 3 panels and the dashboard explanation
  dashboardBody(
    fluidRow(
      box(
        title = "PM2.5 Dashboard",
        footer = HTML(paste0("Primary dataset: ", 
                             "<a href='https://zenodo.org/record/6398971#.Y_w6H3ZBy3A'>",
                             "https://zenodo.org/record/6398971#.Y_w6H3ZBy3A",
                             "</a>")),
        width = 10,
        status = "primary",
        solidHeader = TRUE,
        tabsetPanel(
         tabPanel("Map", leafletOutput("map", height = "650px")),
         tabPanel("TSA", plotOutput("city_plot")),
         tabPanel("Prediction", plotOutput("prediction_plot"))
        )
      )
    ),
   tabItem(
     tabName = "Notifications",
     h2("Dashboard Notifications", style = "font-size: 20px;"),
     p("This dashboard displays the distribution and changes of PM2.5 in Chinese cities from 2000 to 2021 and predicts PM2.5 from 2022 to 2026."),
     p("To see the national distribution map, select a year and month using the dropdown menus in the PM2.5 National Distribution sidebar. The map will display the monthly PM2.5 concentration under the Map tab."),
     p("To see the PM2.5 time series visualization of the selected cities, select a city using the dropdown menu in the Time Series Visualization by City sidebar. The plot will be displayed in the TSA tab."),
     p("To see the PM2.5 prediction of the selected cities, select a city using the dropdown menu and select a time range using the slider in the PM2.5 Prediction by City sidebar. The plot will be displayed in the Prediction tab."),
     p("For more information, please see the following resources:"),
     p(a("GitHub repository", href = "https://github.com/Artemis20123/FangLiRenZhang_ENV872_EDA_FinalProject")),
     p(a("Wrangling code", href = "https://github.com/Artemis20123/FangLiRenZhang_ENV872_EDA_FinalProject/blob/main/Code/data%20wrangling.Rmd"))
   )
  )
)

## Server #####################################################################
server <- function(input, output) {
  # Map visualization
  ## Reactive object for filtering PM2.5 data
  pm25_filtered <- reactive({
    pm25_sf %>%
      filter(year == input$year) %>%
      filter(month == input$month)
  })
  ## Render leaflet map
  output$map <- renderLeaflet({
    pal <- colorNumeric(palette = "Reds", domain = pm25_filtered()$meanPM)
    leaflet(options = leafletOptions(opacity = 0.5)) %>%
      addTiles() %>%
      setView(lng = 104.1954, lat = 35.8617, zoom = 4)%>% ## set the proper initial view for the whole China
      addPolygons(data = pm25_filtered(), 
                  fillColor = ~pal(meanPM), 
                  fillOpacity = 0.7,
                  color = "black",
                  weight = 0.5,
                  popup = paste("<b>City Code:</b> ", pm25_filtered()$city_id, "<br>",
                                "<b>市:</b> ", pm25_filtered()$`地级单位名称`, "<br>",
                                "<b>City:</b> ", pm25_filtered()$cityname, "<br>",
                                "<b>Mean PM2.5 concentration:</b> ", round(pm25_filtered()$meanPM, 2), " µg/m3<br>",
                                "<b>Rank:</b> ", rank(pm25_filtered()$meanPM))) %>% ## add popup information for click
      addLegend("bottomright",
                pal = pal,
                values = pm25_filtered()$meanPM,
                title = "PM2.5 (µg/m3)",
                opacity = 0.7)
  })

  # TSA visualization
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
  
  # Prediction visualization
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
