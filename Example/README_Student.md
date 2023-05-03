# BrysonMurphyEDA872_EDAFinalProject

Created by Rebecca Murphy & Sophia Bryson for Environmental Data Analytics (ENV872) at Duke University's NSOE in Spring 2022. 

## Project Title 

Visualizing USGS Water Use

## Summary

The purpose of this project is to create a dashboard that can assist water resource planners in visualizing types of water use by political or administrative boundaries over time. Based on desired inputs of spatial extent and year, dashboard users are able to produce a Sankey Diagram that highlights relevant surface water and groundwater usage by categories.

This repository contains data for water usage and spatial extents to generate our dashboard as well as associated Sankey Diagrams.  

## Investigators

For additional support, please contact investigators:

Rebecca Murphy: _rebecca.murphy@duke.edu_ 
Nicholas School of the Environment MEM-WRM

Sophia Bryson: _sophia.bryson@duke.edu_ 
Nicholas School of the Environment MEM-WRM

## Database Information 

The primary datasets used to generate the dashboard include:

1. USGS Water Use Data: 

State and county water use by source and use with five year resolution. Data was provided by US Geological Survey (USGS), but cleaned and formatted by the Nicholas Institute for Environmental Policy Solutions (NIEPS). This data is titled "Alluse" in the repository. 

2. EPA Regions: 

Match file of the 12 EPA Regions provided by NIEPS. 

3. US Army Corps of Engineers (USACE) Divisions and Districts:

Match file of USACE Divisions and Districts provided by NIEPS. 


## Folder structure:

All datasets for the project are stored under the "USGSWAterUseSankey" folder with additional subfolders for raw and processed data. Additional "www" folder contains images to insert into the dashboard to highlight administrative regions. 

Processed: spatial (county and state extents) and water use ("Alluse") data

Raw: raw USGS data


## Metadata

We did not create a separate Metadata file for this project. Please see below for specific information regarding the three primary datasets used. 

1. USGS Water Use Data: "All_use.csv"

| Column Name | Description         | Class     | Units |
| ----------- | ------------------- | --------- | ----- |
| County      | US County #         | character | N/A   |
| Name        | US County Name      | character | N/A   |
| State       | US State Name       | character | N/A   |
| District    | USACE District      | character | N/A   |
| Division    | USACE Division      | character | N/A   |
| Year        | Year                | numeric   | N/A   |
| TotalPop    | Total Population    | numeric   | N/A   |
| PublicPop   | Public Population   | numeric   | N/A   |
| Type        | Water Type (gw/sw)  | character | N/A   |
| Category    | Water Usage Type    | character | N/A   |
| MGD         | Million gallons/day | numeric   | mgd   |

2. USACE Districts and Divisions: "USACEuse.csv"

| Column Name | Description         | Class     | Units |
| ----------- | ------------------- | --------- | ----- |
| County      | US County #         | character | N/A   |
| Name        | US County Name      | character | N/A   |
| State       | US State Name       | character | N/A   |
| District.x  | USACE District      | character | N/A   |
| Division.x  | USACE Division      | character | N/A   |
| Year        | Year                | numeric   | N/A   |
| TotalPop    | Total Population    | numeric   | N/A   |
| PublicPop   | Public Population   | numeric   | N/A   |
| Type        | Water Type (gw/sw)  | character | N/A   |
| Category    | Water Usage Type    | character | N/A   |
| MGD         | Million gallons/day | numeric   | mgd   |
| District.x  | USACE District copy | character | N/A   |
| Division.x  | USACE Division copy | character | N/A   |

3. EPA Regions: "EPAuse.csv"

| Column Name | Description         | Class     | Units |
| ----------- | ------------------- | --------- | ----- |
| County      | US County #         | character | N/A   |
| Name        | US County Name      | character | N/A   |
| State       | US State Name       | character | N/A   |
| District    | USACE District      | character | N/A   |
| Division    | USACE Division      | character | N/A   |
| Year        | Year                | numeric   | N/A   |
| TotalPop    | Total Population    | numeric   | N/A   |
| PublicPop   | Public Population   | numeric   | N/A   |
| Type        | Water Type (gw/sw)  | character | N/A   |
| Category    | Water Usage Type    | character | N/A   |
| MGD         | Million gallons/day | numeric   | mgd   |
| Region      | EPA Region          | character | N/A   |

## Scripts and code

1. app.R: contains the script to generate the project's dashboard. 

## Quality assurance/quality control

We went through QA/QC measures in the initial data wrangling process, which primarily included removing incomplete data (rows with N/A's). Data relating to EPA Regions and USACE Divisions and Districts were already QA/QC'ed through NIEPS.   