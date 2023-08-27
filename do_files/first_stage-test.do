clear all
set more off 

* declare the local parameter
local distance_cutoff = 300

cd "C:\Users\User\Documents\Recon\paper-3-analysis"

* read in data from "data/first-stage/parish-level-power-station-data.xlsx"
import excel "data/first-stage/parish-level-power-station-data-vf-copy.xlsx", sheet("Sheet1") firstrow clear

*** results directory "results/first-stage/" as a local
local results_dir "results/first-stage/"

*** label vars

label var treated "Treated parishes"
label var area "Parish area in square kilometers"
label var population_1900 "Parish population in 1900"

*** Regression for total power

quietly summarize total_power if distance_to_line < `distance_cutoff'
local mean1 = round(r(mean), 0.01)
reg total_power treated area population_1900 if distance_to_line < `distance_cutoff', robust
eststo Model1
estadd scalar mean_depvar = `mean1'

quietly summarize total_power_transmitted if distance_to_line < `distance_cutoff'
local mean2 = round(r(mean), 0.01)
reg total_power_transmitted treated area population_1900 if distance_to_line < `distance_cutoff', robust
eststo Model2
estadd scalar mean_depvar = `mean2'

quietly summarize total_power_generated if distance_to_line < `distance_cutoff'
local mean3 = round(r(mean), 0.01)
reg total_power_generated treated area population_1900 if distance_to_line < `distance_cutoff', robust
eststo Model3
estadd scalar mean_depvar = `mean3'

esttab Model1 Model2 Model3 using `results_dir'/first_stage_power.tex, label replace ///
  stats(r2 N F mean_depvar, fmt(2 0 3 2) labels("R-squared" "Observations" "F-stat" "Mean Dependent Var")) ///
  mlabels("Total Power" "Total Power Transmitted" "Total Power Generated") ///
  cells(b(star fmt(3)) se(par fmt(2))) ///
  addnotes("Robust standard errors in parentheses")
  
*** Regression for number of connections

eststo clear


quietly summarize total_connections if distance_to_line < `distance_cutoff'
local mean1 = round(r(mean), 0.01)
reg total_connections treated area population_1900 if distance_to_line < `distance_cutoff', robust
eststo Model1
estadd scalar mean_depvar = `mean1'

quietly summarize num_connections_transmitted if distance_to_line < `distance_cutoff'
local mean2 = round(r(mean), 0.01)
reg num_connections_transmitted treated area population_1900 if distance_to_line < `distance_cutoff', robust
eststo Model2
estadd scalar mean_depvar = `mean2'

quietly summarize num_connections_generated if distance_to_line < `distance_cutoff'
local mean3 = round(r(mean), 0.01)
reg num_connections_generated treated area population_1900 if distance_to_line < `distance_cutoff', robust
eststo Model3
estadd scalar mean_depvar = `mean3'


esttab Model1 Model2 Model3 using `results_dir'/first_stage_connections.tex, label replace ///
  stats(r2 N F mean_depvar, fmt(2 0 3 2) labels("R-squared" "Observations" "F-stat" "Mean Dependent Var")) ///
  mlabels("Total connections" "N. transformers" "N. generators (water, steam, diesel)") ///
  cells(b(star fmt(3)) se(par fmt(2))) ///
  addnotes("Robust standard errors in parentheses")
