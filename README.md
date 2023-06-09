# FangLiRenZhang_ENV872_EDA_FinalProject

## Project Title

A Time Series Analysis and Visualization of PM2.5 Distribution in China

## Summary

Welcome to the repository for the China PM2.5 pollution data analysis project. This repository contains code, data, and metadata related to the project.

This project visualized the monthly average concentration of PM2.5 in Chinese cities from 2000 to 2021 and analyzed the historical trends and predicted the concentration changes for the next 5 years in megacities. we created a dashboard to provide the monthly average pm2.5 concentration for each city in China from 2000 to 2021, and applied time series analysis on seven megacities in China to reveal their historical trends of pm2.5 and predicted the possible future monthly concentration in next 5 years.

The analysis goals include identifying the temporal and spatial patterns of PM2.5 pollution in China and developing a dashboard for better visualization. Specifically, the purposes of this project include:

-   Visualize the spatial distribution of PM2.5 in China from 2000-2021 through an interactive dashboard;
-   Visualize and analyze the temporal trends of PM2.5 concentration in important Chinese cities from 2000-2021;
-   Visualize and predict future PM2.5 concentrations for important Chinese cities from 2022-2026.

The data used in this project is derived from the ChinaHighPM2.5 dataset, which provides a seamless 1 km ground-level resolution of PM2.5 distribution for China, and the shapefile of city boundaries. The repository contains code written in R and Python used to transform, prepare, analyze, and visualize the PM2.5 pollution data.

If you are interested in reproducing or building upon this analysis, please refer to the instructions in the README.md file for guidance on how to use this repository.

## Investigators

For additional support, please contact investigators:

Jiahuan Li: [*jiahuan.li\@duke.edu*](mailto:jiahuan.li@duke.edu){.email} Nicholas School of the Environment iMEP

Jinglin Zhang: [*jinglin.zhang\@duke.edu*](mailto:jinglin.zhang@duke.edu){.email} Nicholas School of the Environment iMEP

Yixin Fang: [*yixin.fang\@duke.edu*](mailto:yixin.fang@duke.edu){.email} Nicholas School of the Environment iMEP

Yuxiang Ren: [*yuxiang.ren\@duke.edu*](mailto:yuxiang.ren@duke.edu){.email} Nicholas School of the Environment iMEP

## Keywords

China, PM2.5, forecast, time series analysis

## Database Information

The data used in this repository is derived from 2 sources:

1.  PM2.5 pollution data
    -   ChinaHighPM2.5 dataset: a seamless 1 km ground-level resolution of PM2.5 distribution for China
    -   Source: <https://zenodo.org/record/6398971#.ZFK0CXZBy3A>
    -   Measured by satellite sensors and presented as raster images
2.  City boundary
    -   Geometry information for Chinese cities with the city names and unique identifiers
    -   Source: the statistical bureau of the Chinese national government
    -   A shapefile of Chinese cities boundaries

All the raw and processed data are stored in the Data folder. More detailed metadata information for each dataset can be found in the `Metadata.Rmd` file located in the `Data` folder and `Raw` subfolder.

## Folder structure, file formats, and naming conventions

The repository contains the following main folders:

-   **Data**: contains all the data used and generated in the project, including raw data, processed data, and metadata files

-   **Code**: include codes for data wrangling, dashboard creation, time series analysis, and report generation

-   **Example**: include the reference documents of the project such as the course materials, project rubric, and previous student work examples

-   **Output**: include snaps (PNG files) of the dashboard

The file formats used in the project are:

-   **CSV**: zonal statistics results and the intermediate aggregated data are saved in the CSV format

-   **Shapefile**: the city boundaries are stored as the shapefile format

-   **R script & Rmarkdown:** projectcodes are written in R script and .rmd files

-   **PDF**: project documents are stored in PDF format

-   **Others**: the repository contains various other files in addition to the ones mentioned above. These include markdown (.md) files, image (.png) files, and citation style language (.csl) files

The naming convention for the files in the repository follows a descriptive and consistent approach. For example, the raw data files are named using a combination of the variable name and the year, while the processed data files are named using a combination of the variable name, city name, and date range. All file names include underscores between words to improve readability.

## Metadata

1.  City boundaries: "./Data/Raw/2000china_city_map/map/city_dingel_2000.shp"

|  Variables   |      Class       |     Units      |          Ranges          |
|:------------:|:----------------:|:--------------:|:------------------------:|
|   OBJECTID   |     numeric      |      N/A       |         [1,365]          |
|   city_id    |     numeric      |      N/A       |      1100 \~ 659001      |
| shape_Length |     numeric      |    degrees     |  [0.3270022,46.942166]   |
|  shape_Area  |     numeric      | square degrees | [0.001671796, 49.457278] |
|   geometry   | sfc_MULTIPOLYGON |    degrees     |           N/A            |

2.  Daily level PM2.5 concentration data: "./Data/Processed/PM2.5_daily_city_2000_2021.csv"

| Variables |  Class  | Units |        Ranges        |
|:---------:|:-------:|:-----:|:--------------------:|
|   year    | numeric |   T   |     [2000,2021]      |
|   month   | numeric |   T   |        [1,12]        |
|    day    | numeric |   T   |        [1,31]        |
|  city_id  | numeric |  N/A  |    1100 \~ 659001    |
|  meanpm   | numeric | ug/m3 | [3.364316, 585.4695] |

3.  Monthly level PM2.5 concentration data: "./Data/Processed/PM2.5_monthly_city_2000_2021.csv"

|  Variables   |   Class   | Units |        Ranges        |
|:------------:|:---------:|:-----:|:--------------------:|
|     year     |  numeric  |   T   |     [2000,2021]      |
|    month     |  numeric  |   T   |        [1,12]        |
|   city_id    |  numeric  |  N/A  |    1100 \~ 659001    |
| 地级单位名称 | character |  N/A  |         N/A          |
|   cityname   | character |  N/A  |         N/A          |
|    meanPM    |  numeric  | ug/m3 | [6.437489, 200.2201] |

4.  Final forecast result: "./Data/Processed/all_forcast.csv"

| Column Name | Description               | Class     | Unit  |
|-------------|---------------------------|-----------|-------|
| Date        | Date                      | character |       |
| R_Beijing   | Beijing forecast result   | numeric   | ug/m3 |
| R_Shanghai  | Shanghai forecast result  | numeric   | ug/m3 |
| R_Guangzhou | Guangzhou forecast result | numeric   | ug/m3 |
| R_Shenzhen  | Shenzhen forecast result  | numeric   | ug/m3 |
| R_Tianjin   | Tianjin forecast result   | numeric   | ug/m3 |
| R_Chongqing | Chongqing forecast result | numeric   | ug/m3 |
| R_Chengdu   | Chengdu forecast result   | numeric   | ug/m3 |

5.  Accuracy table for 6 models: "./Data/Processed/Beijing_scores.csv"

    Accuracy table for 4 models: "./Data/Processed/Beijing_scores0.csv"

| Column Name | Description                    | Class   |
|-------------|--------------------------------|---------|
| ME          | Mean Error                     | numeric |
| RMSE        | Root Mean Squared Error        | numeric |
| MAE         | Mean Absolute Error            | numeric |
| MPE         | Mean Percentage Error          | numeric |
| MAPE        | Mean Absolute Percentage Error | numeric |

6.  Seasonal component of 7 cities by STL: "./Data/Processed/seasonal_data.csv"

| Column Name | Description              | Class     |
|-------------|--------------------------|-----------|
| city        | City name                | character |
| month       | month                    | character |
| seasonal    | PM2.5 seasonal component | numeric   |

7.  Trend component of 7 cities by STL: "./Data/Processed/trend_data.csv"

| Column Name | Description           | Class     |
|-------------|-----------------------|-----------|
| city        | City name             | character |
| month       | month                 | character |
| trend       | PM2.5 trend component | numeric   |

## Scripts and code

-   **data wrangling.Rmd**: summarize all the data preparation steps

-   **dashbord-the choropleth map.R**: implements the functionality of the first panel of the dashboard (with extra dropdown menu examples)

-   **dashbord-TSA & Prediction.R**: implements the functionality of the second and third panels of the dashboard

-   **dashbord-final.R**: contains the script to generate the project's dashboard

-   **TSA2.Rmd**: time series analysis including these steps:

    1.  By utilizing daily PM2.5 data for seven cities, we generated time series for each city.

    2.  Using the STL function, we decomposed the seasonal and trend components for each city.

    3.  We employed multiple time series models (Mean, SNAIVE, SARIMA, SSES, SNAIVE+SARIMA, SSES+SARIMA) to forecast PM2.5 levels in the seven cities for the years 2022-2026.

-   **LiFangRenZhang_ENV872_Project.Rmd**: contains the content of the report

## Quality assurance/quality control

-   **Data validation**: we have checked for missing values or outliers in the PM2.5 concentration and city boundary data and ensured they are complete and accurate after modification.

-   **Data cleaning**: we have cleaned the PM2.5 concentration data by removing regions (islands) missing PM2.5 values.

-   **Quality control checks**: we have compared satellite PM2.5 concentration data to other data sources (the meteorological station data) and ensured the accuracy and consistency of the raw data.

## Future development

-   **Animations**

    For future development of our map, we have explored the possibility of incorporating animations to enhance the user experience. Specifically, we were interested in adding the functionality to zoom in to cities when clicking on them or visually highlighting them when hovered over with a mouse (example: [https://leafletjs.com/examples/choropleth/](https://leafletjs.com/examples/choropleth/){style="font-size: 11pt;"}). However, we encountered difficulties in implementing these features and were unable to validate them.

-   **Search control**

    In addition, we also considered incorporating a search function into our map, allowing users to input city names and receive a highlighted region with popups. However, we faced even greater challenges in implementing this feature and were unable to do so. These potential additions could improve the functionality and user-friendliness of our map, and we will continue to explore ways to incorporate them in future development.
