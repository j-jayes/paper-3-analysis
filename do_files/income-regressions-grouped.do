* purpose
* income regressions
* uses the dta file that is produced from set_dataset_params.do

clear all
set more off 
cd "C:\Users\User\Documents\Recon\paper-3-analysis"
* read in data from 
use "data/census/1930_census_regression_dataset_params_set.dta"

drop if employed == 0

*** results directory "results/regressions/" as a local
local results_dir "results/regressions/"

*** Regression 1: log_income as dependent variable.

* Regression for log_income with birth_parish_treated only
quietly summarize log_income if birth_parish_treated == 0
local mean1 = round(r(mean), 0.01)
reg log_income birth_parish_treated, robust
eststo Model1
estadd scalar mean_depvar = `mean1'

* Adding age and age squared and female
quietly summarize log_income if birth_parish_treated == 0
local mean2 = round(r(mean), 0.01)
reg log_income birth_parish_treated age age_2 female, robust
eststo Model2
estadd scalar mean_depvar = `mean2'

* Adding schooling
quietly summarize log_income if birth_parish_treated == 0
local mean3 = round(r(mean), 0.01)
reg log_income birth_parish_treated age age_2 female i.marital i.schooling i.hisclass_group_abb, robust
eststo Model3
estadd scalar mean_depvar = `mean3'

* Output the results
esttab Model1 Model2 Model3 using `results_dir'/log_income_regression.csv, label replace ///
  stats(r2 N F mean_depvar, fmt(2 0 3 2) labels("R-squared" "Observations" "F-stat" "Mean Dependent Var")) ///
  cells(b(star fmt(3)) se(par fmt(2))) ///
  addnotes("Robust standard errors in parentheses")

esttab Model1 Model2 Model3 using `results_dir'/log_income_regression.tex, label replace ///
  stats(r2 N F mean_depvar, fmt(2 0 3 2) labels("R-squared" "Observations" "F-stat" "Mean Dependent Var")) ///
  cells(b(star fmt(3)) se(par fmt(2))) ///
  addnotes("Robust standard errors in parentheses")


* Regression for log_income with birth_parish_treated and mover
quietly summarize log_income if birth_parish_treated == 0
local mean1 = round(r(mean), 0.01)
reg log_income birth_parish_treated mover, robust
eststo Model1
estadd scalar mean_depvar = `mean1'
