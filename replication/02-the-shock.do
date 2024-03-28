*---------------------------------------------*
* The Shock: Regression Analysis              *
*---------------------------------------------*

clear all
set more off 

*---------------------------------------------------*
* Setup and Data Import
*---------------------------------------------------*

* Set local parameter for data trimming
global distance_cutoff = 300

* Setting the working directory
cd "/Users/jonathanjayes/Documents/PhD/paper-3-analysis/"
* cd "C:\Users\User\Documents\Recon\paper-3-analysis"

* Import parish-level power station data from Excel
import excel "data/first-stage/04_firststage-data.xlsx", sheet("Sheet1") firstrow clear

* Define the results directory for storing output
local results_dir "results/first-stage/"

*---------------------------------------------------*
* Variable Labeling and Transformations
*---------------------------------------------------*

* Assign variable labels for clarity in tables and models
label var treated "Treated parishes"
label var area "Parish area in square kilometers"
label var population_1900 "Parish population in 1900"
label var latitude "Latitude"
label var longitude "Longitude"

* Create log-transformed outcomes for power-related variables
gen log_total_power = ln(total_power + 1)
gen log_total_power_transmitted = ln(total_power_transmitted + 1)
gen log_total_power_generated = ln(total_power_generated + 1)

* Create log-transformed outcomes for power-related variables
gen log_total_connections = ln(total_connections + 1)
gen log_num_connections_transmitted = ln(num_connections_transmitted + 1)
gen log_num_connections_generated = ln(num_connections_generated + 1)


*---------------------------------------------------*
* Regression Analyses for Total Power (in logs)
*---------------------------------------------------*

* Regression on log-transformed total power
reg log_total_power treated area population_1900 latitude longitude if distance_to_line < $distance_cutoff , robust

* Regression on log-transformed total power transmitted

reg log_total_power_transmitted treated area population_1900 latitude longitude if distance_to_line < $distance_cutoff, robust

* Regression on log-transformed total power generated
reg log_total_power_generated treated area population_1900 latitude longitude if distance_to_line < $distance_cutoff, robust

*---------------------------------------------------*
* Regression Analyses for Number of Connections
*---------------------------------------------------*

* Regression on total connections
reg log_total_connections treated area population_1900 latitude longitude if distance_to_line < $distance_cutoff, robust


* Regression on number of connections transmitted
reg log_num_connections_transmitted treated area population_1900 latitude longitude if distance_to_line < $distance_cutoff, robust

* Regression on number of connections generated

reg log_num_connections_generated treated area population_1900 latitude longitude if distance_to_line < $distance_cutoff, robust

