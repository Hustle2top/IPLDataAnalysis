# IPLDataAnalysis

## Project Overview
This repository includes the Data Analysis of IPL stats for batting and bowling from season 1 of the Indian Premier League till season 17. The statistics data has been scraped using python, via a major sports news website exclusively for the game of cricket i.e. espncricinfo. This project aims at analyzing the statistics for batting and bowling records in each season of the IPL from 2008 till 2024. This analysis is aimed at finding the dominance of players & teams in IPL stats and finding the players and teams with most impact over all these years alongwith the cumulative refined stats in all departments of this league.

## Data Source
The dataset used for this analysis has been scraped online from website www.espncricinfo.com using python script. It has been scraped in the csv format file, one each for batting and bowling stats, consisting of 200 rows and 15 columns originally(without cleaning).

## Tools Used
- Python (Data Scraping using Pandas)
- MS Excel (Data Cleaning)
- MySQLWorkbench (Data Exploration/EDA)
- Power BI (Data Modelling & Visualization)
- Power Point (Reporting & summary)

## Data Scraping
To scrape the IPL batting and IPL bowling records from 2008 till 2024 I used Python script(file added in repository) on espncricinfo.com and saved the data in excel format and later converted that to csv format
before starting data cleaning in the MS Excel.

## Data Cleaning & Preparation
In the initial data preparation phase, I did below steps for each file(batting and bowling:
1. Data loading & inspection.
2. Deleted the blank columns having only headers and no data in them.
3. Extracted IPLyear out of the messy data rows in Power Query inside MS Excel and later deleted those messy rows.
4. Converted the original data tyoe of columns to the correct data type for each column based on the data in them.
5. Applied proper formatting for required columns.
6. Converted the MS excel file into csv format and saved for performing EDA in SQL.

## Exploratory Data Analysis (EDA)
In EDA, I performed the below steps:
1. After installing MySQLWorkbench, first I created account and credentials for logging in, new database named "ipl_data" using database creation SQL script.
2. Then I created two different tables(one for batting record i.e. iplbat & other for bowling records i.e. iplbowl) by defining the table schemas as per the csv dataset columns, using SQL scripts FOR DDL(Data Definition Language) & DML(Data Manipulation Language).
3. After Database and table creation, I imported the data saved in CSV format from desktop to the MySQLWorkbench using the "Table Data Import Wizard" option by selecting the specific table for batting and bowling records.
4. Next, I started Exploratory Data Analysis using the basic SQL queries involving use of BASIC SQL COMMANDS, WINDOW FUNCTIONS, AGGREGATION to derive meaningful insights out of the data.

## Data Analysis
1. In Data Analysis I used the intermediate and advanced SQL queries involving use of JOINS, SUBQUERIES, WINDOW RANK FUNCTIONS, CASE STATEMENT, AGGREGATION, UNION etc. to perform deeper analysis on stats data.
2. I also used SQL AGGREGATION commands to get refined playerwise and teamwise statistics to be used for creating visualizations in Power BI.

## Summary & Findings
The analysis results are summarized as below:
1. Majority of runs in IPL have been scored by batters from RCB & CSK.
2. Majority of wickets in IPL have been taken by bowlers from MI & RCB.
3. The top impact player overall(batting+bowling) in the IPL have been AD Russell with Shane Watson being the next best.
4. Most Centuries in IPL have been scored by players from RCB (14), followed by players from RR (8).
5. Most wickets in a single season by any individual player has been taken by Harshal Patel (32) in 2016, tied with Dwayne Bravo (32) in 2013, followed by kagiso Rabada (30) in 2020.
6. Most maidens bowled in IPL by an individual bowler in total has been by Lasith Malinga (8)
7. Most Half-Centuries in IPL have been scored by players from RCB (79), followed by players from SRH (61).
8. Best Overall batting average has been by AB De Villiers (Min. 20 matches)
9. Most Sixes hit by a team overall is by RCB(488 sixes) followed by CSK(285 sixes)
10. Alltime highest individual batting score in a match, has been made by Chris Gayle (175 runs)

## Limitations
1. As the scraped data was mainly for batting and bowling records, there was no data scraped for match results alongwith these stats to perform more deeper and related analysis for these records.
2. The data available in the original dataset did not have a complete date column with Day, Month, Year to perform time series analysis properly and more deeply.

## Data Source Disclaimer
1. Data was collected from [ESPNcricinfo](https://www.espncricinfo.com/) using custom Python scripts for **educational and non-commercial purposes only**.
2. This project is intended for personal portfolio and learning. No raw HTML or commercial redistribution is involved.

## Sample Dashboard Preview
![IPLDataImage1](https://github.com/user-attachments/assets/6c267452-d16f-4500-acd9-098dc1ddae15)



  






















