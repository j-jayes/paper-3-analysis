* purpose
* employment regressions
* uses the dta file that is produced from set_dataset_params.do

clear all
set more off 
cd "C:\Users\User\Documents\Recon\paper-3-analysis"
* read in data from 
use "data/census/1930_census_regression_dataset_params_set.dta"

*** results directory "results/regressions/" as a local
local results_dir "results/regressions/"

*** Regression 1: employment as dependent variable.

* Regression for employed with birth_parish_treated only
quietly summarize employed
local mean1 = round(r(mean), 0.01)
reg employed birth_parish_treated, robust
eststo Model1
estadd scalar mean_depvar = `mean1'

* Adding age and age squared and female
quietly summarize employed
local mean2 = round(r(mean), 0.01)
reg employed birth_parish_treated age age_2 female, robust
eststo Model2
estadd scalar mean_depvar = `mean2'

* Adding marital status and schooling
quietly summarize employed
local mean3 = round(r(mean), 0.01)
reg employed birth_parish_treated age age_2 female i.marital i.schooling, robust
eststo Model3
estadd scalar mean_depvar = `mean3'
  
esttab Model1 Model2 Model3 using `results_dir'/031-employed_regression.tex, label replace ///
  stats(r2 N F mean_depvar, fmt(2 0 3 2) labels("R-squared" "Observations" "F-stat" "Mean Dependent Var")) ///
  cells(b(star fmt(3)) se(par fmt(2))) ///
  addnotes("Robust standard errors in parentheses")

*** Regression 2: employment as dependent variable in a probit

* Regression for employed with birth_parish_treated only
quietly summarize employed
local mean1 = round(r(mean), 0.01)
probit employed birth_parish_treated, robust
eststo Model1
estadd scalar mean_depvar = `mean1'

* Adding age and age squared and female
quietly summarize employed
local mean2 = round(r(mean), 0.01)
probit employed birth_parish_treated age age_2 female, robust
eststo Model2
estadd scalar mean_depvar = `mean2'

* Adding marital status and schooling
quietly summarize employed
local mean3 = round(r(mean), 0.01)
probit employed birth_parish_treated age age_2 female i.marital i.schooling, robust
eststo Model3
estadd scalar mean_depvar = `mean3'
  
esttab Model1 Model2 Model3 using `results_dir'/032-employed_probit.tex, label replace ///
  stats(r2 N F mean_depvar, fmt(2 0 3 2) labels("R-squared" "Observations" "F-stat" "Mean Dependent Var")) ///
  cells(b(star fmt(3)) se(par fmt(2))) ///
  addnotes("Robust standard errors in parentheses")
