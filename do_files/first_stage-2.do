
clear all
set more off 
cd "C:\Users\User\Documents\Recon\paper-3-analysis"

* read in data from "data/first-stage/parish-level-power-station-data.xlsx"
import excel "data/first-stage/parish-level-power-station-data.xlsx", sheet("Sheet1") firstrow clear

reg total_power treated if distance_to_line < 300, robust

reg total_stations treated if distance_to_line < 300, robust

reg number_of_stations_transmitted treated if distance_to_line < 300, robust

*** change threshold

reg total_power treated if distance_to_line < 100, robust

reg total_stations treated if distance_to_line < 100, robust

reg number_of_stations_water treated if distance_to_line < 100, robust

*** change threshold

reg total_power treated area if distance_to_line < 100, robust

reg total_stations treated area if distance_to_line < 100, robust

reg number_of_stations_water area treated if distance_to_line < 100, robust

*** change threshold

reg total_power treated area if distance_to_line < 100, robust

reg total_stations treated area if distance_to_line < 100, robust

reg number_of_stations_water area treated if distance_to_line < 100, robust
