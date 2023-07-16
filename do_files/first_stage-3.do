label var treated "Treated parishes"
label var area "Parish area in square kilometers"
label var population_1900 "Parish population in 1900"


*** Regression for total power

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
