# FangLiRenZhang_ENV872_EDA_FinalProject

## Project Title

A Time Series Analysis and Visualization of PM2.5 Distribution in China

## Summary

<<<<<<< HEAD
\<describe the purpose of this repository, the information it contains,
and any relevant analysis goals. What, why, where, when, how?\>

=======
Welcome to the repository for the China PM2.5 pollution data analysis project. This repository contains code, data, and metadata related to the project.

This project visualized the monthly average concentration of PM2.5 in Chinese cities from 2000 to 2021 and analyzed the historical trends and predicted the concentration changes for the next 5 years in megacities. we created a dashboard to provide the monthly average pm2.5 concentration for each city in China from 2000 to 2021, and applied time series analysis on seven megacities in China to reveal their historical trends of pm2.5 and predicted the possible future monthly concentration in next 5 years.

The analysis goals include identifying the temporal and spatial patterns of PM2.5 pollution in China and developing a dashboard for better visualization. Specifically, the purposes of this project include:

-   Visualize the spatial distribution of PM2.5 in China from 2000-2021 through an interactive dashboard;
-   Visualize and analyze the temporal trends of PM2.5 concentration in important Chinese cities from 2000-2021;
-   Visualize and predict future PM2.5 concentrations for important Chinese cities from 2022-2026.

The data used in this project is derived from the ChinaHighPM2.5 dataset, which provides a seamless 1 km ground-level resolution of PM2.5 distribution for China, and the shapefile of city boundaries. The repository contains code written in R and Python used to transform, prepare, analyze, and visualize the PM2.5 pollution data.

If you are interested in reproducing or building upon this analysis, please refer to the instructions in the README.md file for guidance on how to use this repository.

>>>>>>> 9495f5cbc0e9280d5b10949ea3d1cb4d3daeea4b
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

All the raw and processed data are stored in the Data folder, including shapefiles, NetCDF files, and CSV files. The metadata folder contains detailed information about the data used in this project.

## Folder structure, file formats, and naming conventions

\<describe the folders contained in the repository, including what type of files they contain\>
----Code folder-----
Reference: apa-6th-edition.csl(format)
           reference.bib(reference)
Dashboard: dashboard-final.R(combined final dashboard)
           dashboard-map-search control.R(code for display time series)
           dashboard-the choropleth map.R(code for display distribution)
           dashboard-TSA & Prediction.R(code to display prediction)
<describe the formats of files for the various purposes contained in the repository>

<describe your file naming conventions>

## Metadata

\<For each data file in the repository, describe the data contained in each column. Include the column name, a description of the information, the class of data, and any units associated with the data. Create a list or table for each data file.\>

2.  Final forecast result: "./Data/Processed/all_forcast.csv"

| Column Name | Description               | Class     |
|-------------|---------------------------|-----------|
| Date        | Date                      | character |
| R_Beijing   | Beijing forecast result.  | numeric   |
| R_Shanghai  | Shanghai forecast result  | numeric   |
| R_Guangzhou | Guangzhou forecast result | numeric   |
| R_Shenzhen  | Shenzhen forecast result  | numeric   |
| R_Tianjin   | Tianjin forecast result   | numeric   |
| R_Chongqing | Chongqing forecast result | numeric   |
| R_Chengdu   | Chengdu forecast result   | numeric   |

3.  Accuracy table for 6 models: "./Data/Processed/Beijing_scores.csv"

| Column Name | Description                    | Class   |
|-------------|--------------------------------|---------|
| ME          | Mean Error                     | numeric |
| RMSE        | Root Mean Squared Error        | numeric |
| MAE         | Mean Absolute Error            | numeric |
| MPE         | Mean Percentage Error          | numeric |
| MAPE        | Mean Absolute Percentage Error | numeric |

4.  Accuracy table for 4 models: "./Data/Processed/Beijing_scores0.csv"

5.  Seasonal component of 7 cities by STL: "./Data/Processed/seasonal_data.csv"

| Column Name | Description              | Class     |
|-------------|--------------------------|-----------|
| city        | City name                | character |
| month       | month                    | character |
| seasonal    | PM2.5 seasonal component | numeric   |

6.  Trend component of 7 cities by STL: "./Data/Processed/trend_data.csv"

| Column Name | Description            | Class     |
|-------------|------------------------|-----------|
| city        | City name              | character |
| month       | month                  | character |
| trend.      | PM2.5 trend. component | numeric   |

## Scripts and code

\<list any software scripts/code contained in the repository and a description of their purpose.\>

## Quality assurance/quality control

\<describe any relevant QA/QC procedures taken with your data. Some ideas can be found here:\> <https://www.dataone.org/best-practices/develop-quality-assurance-and-quality-control-plan> <https://www.dataone.org/best-practices/ensure-basic-quality-control> <https://www.dataone.org/best-practices/communicate-data-quality> <https://www.dataone.org/best-practices/identify-outliers> <https://www.dataone.org/best-practices/identify-values-are-estimated>

## Future development

animation

search control
