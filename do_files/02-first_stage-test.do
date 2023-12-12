*---------------------------------------------*
* First-Stage Regression Analysis             *
*---------------------------------------------*

clear all
set more off 

*---------------------------------------------------*
* Setup and Data Import
*---------------------------------------------------*

* Set local parameter for data trimming
local distance_cutoff = 300

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
* Regression Analyses for Total Power (in levels)
*---------------------------------------------------*

* Regression on total power
quietly summarize total_power if distance_to_line < `distance_cutoff'
local mean1 = round(r(mean), 0.01)
reg total_power treated area population_1900 latitude longitude if distance_to_line < `distance_cutoff'
eststo Model1
estadd scalar mean_depvar = `mean1'

* Regression on total power transmitted
quietly summarize total_power_transmitted if distance_to_line < `distance_cutoff'
local mean2 = round(r(mean), 0.01)
reg total_power_transmitted treated area population_1900 latitude longitude if distance_to_line < `distance_cutoff'
eststo Model2
estadd scalar mean_depvar = `mean2'

* Regression on total power generated
quietly summarize total_power_generated if distance_to_line < `distance_cutoff'
local mean3 = round(r(mean), 0.01)
reg total_power_generated treated area population_1900 latitude longitude if distance_to_line < `distance_cutoff'
eststo Model3
estadd scalar mean_depvar = `mean3'

* Tabulate results for power in levels
esttab Model1 Model2 Model3 using `results_dir'/021-first_stage_power.tex, label replace ///
  stats(r2 N F mean_depvar, fmt(2 0 3 2) labels("R-squared" "Observations" "F-stat" "Mean Dependent Var")) ///
  mlabels("Total Power" "Total Power Transmitted" "Total Power Generated") ///
  cells(b(star fmt(3)) se(par fmt(2))) ///
  addnotes("Robust standard errors in parentheses")

*---------------------------------------------------*
* Regression Analyses for Total Power (in logs)
*---------------------------------------------------*

* Clear stored estimates
eststo clear

* Regression on log-transformed total power
quietly summarize log_total_power if distance_to_line < `distance_cutoff'
local mean1 = round(r(mean), 0.01)
reg log_total_power treated area population_1900 latitude longitude if distance_to_line < `distance_cutoff'
eststo Model1
estadd scalar mean_depvar = `mean1'

* Regression on log-transformed total power transmitted
quietly summarize log_total_power_transmitted if distance_to_line < `distance_cutoff'
local mean2 = round(r(mean), 0.01)
reg log_total_power_transmitted treated area population_1900 latitude longitude if distance_to_line < `distance_cutoff'
eststo Model2
estadd scalar mean_depvar = `mean2'

* Regression on log-transformed total power generated
quietly summarize log_total_power_generated if distance_to_line < `distance_cutoff'
local mean3 = round(r(mean), 0.01)
reg log_total_power_generated treated area population_1900 latitude longitude if distance_to_line < `distance_cutoff'
eststo Model3
estadd scalar mean_depvar = `mean3'

* Tabulate results for log-transformed power variables
esttab Model1 Model2 Model3 using `results_dir'/022-first_stage_power_log.tex, label replace ///
  stats(r2 N F mean_depvar, fmt(2 0 3 2) labels("R-squared" "Observations" "F-stat" "Mean Dependent Var")) ///
  mlabels("log(Total Power)" "log(Total Power Transmitted)" "log(Total Power Generated)") ///
  cells(b(star fmt(3)) se(par fmt(2))) ///
  addnotes("Robust standard errors in parentheses")

*---------------------------------------------------*
* Regression Analyses for Number of Connections
*---------------------------------------------------*

* Regression on total connections
quietly summarize log_total_connections if distance_to_line < `distance_cutoff'
local mean1 = round(r(mean), 0.01)
reg log_total_connections treated area population_1900 latitude longitude if distance_to_line < `distance_cutoff'
eststo Model1
estadd scalar mean_depvar = `mean1'

* Regression on number of connections transmitted
quietly summarize log_num_connections_transmitted if distance_to_line < `distance_cutoff'
local mean2 = round(r(mean), 0.01)
reg log_num_connections_transmitted treated area population_1900 latitude longitude if distance_to_line < `distance_cutoff'
eststo Model2
estadd scalar mean_depvar = `mean2'

* Regression on number of connections generated
quietly summarize log_num_connections_generated if distance_to_line < `distance_cutoff'
local mean3 = round(r(mean), 0.01)
reg log_num_connections_generated treated area population_1900 latitude longitude if distance_to_line < `distance_cutoff'
eststo Model3
estadd scalar mean_depvar = `mean3'

* Tabulate results for connections variables
esttab Model1 Model2 Model3 using `results_dir'/023-first_stage_connections.tex, label replace ///
  stats(r2 N F mean_depvar, fmt(2 0 3 2) labels("R-squared" "Observations" "F-stat" "Mean Dependent Var")) ///
  mlabels("log(Total connections)" "log(N. transformers)" "log(N. generators) (water, steam, diesel)") ///
  cells(b(star fmt(3)) se(par fmt(2))) ///
  addnotes("Robust standard errors in parentheses")

