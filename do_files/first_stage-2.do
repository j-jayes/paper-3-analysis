* what do I want the output to include?

* first I want the mean of the dependent variable

* then, I want the coefficient on treated, that's what we are interested in. and the p-value

* then I want the number of observations, F-stat, R-squared

* Then I want to indicate which controls are included. 



* What I need to create is a function to take the output from my regression in Stata and format it for the paper in Latex in the manner that I want. I can use the code intepreter for this I am sure.


clear all
set more off 
cd "C:\Users\User\Documents\Recon\paper-3-analysis"

* read in data from "data/first-stage/parish-level-power-station-data.xlsx"
import excel "data/first-stage/test-parish-level-power-station-data.xlsx", sheet("Sheet1") firstrow clear



*** start again - what should the baseline regression be?

*** What is the story that I want to tell

* First, being on the line meant you had access to more power in total, and that this power came through transmission lines, rather than pre-existing hydro power.

* gen total power not 

reg total_power treated area population_1900 if distance_to_line < 300, robust

reg total_power_transmitted treated area population_1900 if distance_to_line < 300, robust

reg total_power_generated treated area population_1900 if distance_to_line < 300, robust

* Second, being on the line meant you had access to more numbers of distribution stations.

* make variable for number of other stations

reg total_stations treated area population_1900 if distance_to_line < 300, robust

reg number_of_stations_transmitted treated area population_1900 if distance_to_line < 300, robust

reg number_of_stations_generated treated area population_1900 if distance_to_line < 300, robust

* add in & touching_treated_clean == 0

* robustness - what do we want to do? Change the thresholds, change the population controls, exclude area.

* this I can ask ChatGPT to do.

* let's go through a few

reg total_stations treated area population_1930 if distance_to_line < 300, robust

reg number_of_stations_transmitted treated area population_1930 if distance_to_line < 300, robust

reg number_of_stations_generated treated area population_1930 if distance_to_line < 300, robust


**** export

quietly summarize total_power if distance_to_line < 300
local mean1 = round(r(mean), 0.01)

quietly summarize total_power_transmitted if distance_to_line < 300
local mean2 = round(r(mean), 0.01)

quietly summarize total_power_generated if distance_to_line < 300
local mean3 = round(r(mean), 0.01)

esttab Model1 Model2 Model3 using mytable.tex, replace ///
  stats(r2 N F, fmt(2 0 3) labels("R-squared" "Observations" "F-stat")) ///
  mlabels("Total Power" "Total Power Transmitted" "Total Power Generated") ///
  addnotes("Mean of total power: `mean1'. Mean of total power transmitted: `mean2'. Mean of total power generated: `mean3'. Robust standard errors in parentheses") ///
  cells(b(star fmt(3)) se(par fmt(2)))

**** This is trying to improve on the above
  
label var treated "Treated parishes"
label var area "Parish area in square kilometers"
label var population_1900 "Parish population in 1900"

quietly summarize total_power if distance_to_line < 300
local mean1 = round(r(mean), 0.01)
reg total_power treated area population_1900 if distance_to_line < 300, robust
eststo Model1
estadd scalar mean_depvar = `mean1'

quietly summarize total_power_transmitted if distance_to_line < 300
local mean2 = round(r(mean), 0.01)
reg total_power_transmitted treated area population_1900 if distance_to_line < 300, robust
eststo Model2
estadd scalar mean_depvar = `mean2'

quietly summarize total_power_generated if distance_to_line < 300
local mean3 = round(r(mean), 0.01)
reg total_power_generated treated area population_1900 if distance_to_line < 300, robust
eststo Model3
estadd scalar mean_depvar = `mean3'

esttab Model1 Model2 Model3 using mytable.tex, label replace ///
  stats(r2 N F mean_depvar, fmt(2 0 3 2) labels("R-squared" "Observations" "F-stat" "Mean Dependent Var")) ///
  mlabels("Total Power" "Total Power Transmitted" "Total Power Generated") ///
  cells(b(star fmt(3)) se(par fmt(2))) ///
  addnotes("Robust standard errors in parentheses")


  
 *** now for robustness
eststo clear

foreach pop in population_1900 population_1910 {
  foreach dist in 100 200 300 400 500 {
    quietly summarize total_power if distance_to_line < `dist'
    local mean1 = round(r(mean), 0.01)
    reg total_power treated area `pop' if distance_to_line < `dist', robust
    eststo Model`pop'_`dist'
    estadd scalar mean_depvar = `mean1'
    
    quietly summarize total_power_transmitted if distance_to_line < `dist'
    local mean2 = round(r(mean), 0.01)
    reg total_power_transmitted treated area `pop' if distance_to_line < `dist', robust
    eststo ModelT`pop'_`dist'
    estadd scalar mean_depvar = `mean2'
    
    quietly summarize total_power_generated if distance_to_line < `dist'
    local mean3 = round(r(mean), 0.01)
    reg total_power_generated treated area `pop' if distance_to_line < `dist', robust
    eststo ModelG`pop'_`dist'
    estadd scalar mean_depvar = `mean3'
  }
}

esttab Modelpopulation_1900_100 ModelTpopulation_1900_100 ModelGpopulation_1900_100 ///
  Modelpopulation_1900_200 ModelTpopulation_1900_200 ModelGpopulation_1900_200 ///
  Modelpopulation_1900_300 ModelTpopulation_1900_300 ModelGpopulation_1900_300 ///
  Modelpopulation_1900_400 ModelTpopulation_1900_400 ModelGpopulation_1900_400 ///
  Modelpopulation_1900_500 ModelTpopulation_1900_500 ModelGpopulation_1900_500 ///
  Modelpopulation_1910_100 ModelTpopulation_1910_100 ModelGpopulation_1910_100 ///
  Modelpopulation_1910_200 ModelTpopulation_1910_200 ModelGpopulation_1910_200 ///
  Modelpopulation_1910_300 ModelTpopulation_1910_300 ModelGpopulation_1910_300 ///
  Modelpopulation_1910_400 ModelTpopulation_1910_400 ModelGpopulation_1910_400 ///
  Modelpopulation_1910_500 ModelTpopulation_1910_500 ModelGpopulation_1910_500 ///
  using mytable.tex, replace ///
  keep(treated) ///
  stats(mean_depvar, fmt(2) labels("Mean Dependent Var")) ///
  mlabels("Total Power d<100 pop1900" "Total Power Transmitted d<100 pop1900" "Total Power Generated d<100 pop1900" ///
  "Total Power d<200 pop1900" "Total Power Transmitted d<200 pop1900" "Total Power Generated d<200 pop1900" ///
  "Total Power d<300 pop1900" "Total Power Transmitted d<300 pop1900" "Total Power Generated d<300 pop1900" ///
  "Total Power d<400 pop1900" "Total Power Transmitted d<400 pop1900" "Total Power Generated d<400 pop1900" ///
  "Total Power d<500 pop1900" "Total Power Transmitted d<500 pop1900" "Total Power Generated d<500 pop1900" ///
  "Total Power d<100 pop1910" "Total Power Transmitted d<100 pop1910" "Total Power Generated d<100 pop1910" ///
  "Total Power d<200 pop1910" "Total Power Transmitted d<200 pop1910" "Total Power Generated d<200 pop1910" ///
  "Total Power d<300 pop1910" "Total Power Transmitted d<300 pop1910" "Total Power Generated d<300 pop1910" ///
  "Total Power d<400 pop1910" "Total Power Transmitted d<400 pop1910" "Total Power Generated d<400 pop1910" ///
  "Total Power d<500 pop1910" "Total Power Transmitted d<500 pop1910" "Total Power Generated d<500 pop1910") ///
  cells(b(star fmt(3)) se(par fmt(2))) ///
  addnotes("Robust standard errors in parentheses")

