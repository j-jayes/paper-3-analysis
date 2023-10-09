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

*** Regression 1: employment as dependent variable.

* Regression for electricity_job_direct with birth_parish_treated only
quietly summarize electricity_job_direct if birth_parish_treated == 0
local mean1 = round(r(mean), 0.01)
reg electricity_job_direct birth_parish_treated, robust
eststo Model1
estadd scalar mean_depvar = `mean1'

* Adding age and age squared and female
quietly summarize electricity_job_direct if birth_parish_treated == 0
local mean2 = round(r(mean), 0.01)
reg electricity_job_direct birth_parish_treated age age_2 female, robust
eststo Model2
estadd scalar mean_depvar = `mean2'

* Adding marital status and schooling
quietly summarize electricity_job_direct if birth_parish_treated == 0
local mean3 = round(r(mean), 0.01)
reg electricity_job_direct birth_parish_treated age age_2 female i.marital i.schooling, robust
eststo Model3
estadd scalar mean_depvar = `mean3'

* Output the results
esttab Model1 Model2 Model3 using `results_dir'/electricity_job_direct_regression.tex, label replace ///
  stats(r2 N F mean_depvar, fmt(2 0 3 2) labels("R-squared" "Observations" "F-stat" "Mean Dependent Var")) ///
  cells(b(star fmt(3)) se(par fmt(2))) ///
  addnotes("Robust standard errors in parentheses")
  
****** Probit

* Regression for electricity_job_direct with birth_parish_treated only
quietly summarize electricity_job_direct if birth_parish_treated == 0
local mean1 = round(r(mean), 0.01)
probit electricity_job_direct birth_parish_treated, robust
eststo Model1
estadd scalar mean_depvar = `mean1'

margins

* Adding age and age squared and female
quietly summarize electricity_job_direct if birth_parish_treated == 0
local mean2 = round(r(mean), 0.01)
probit electricity_job_direct birth_parish_treated age age_2 female, robust
eststo Model2
estadd scalar mean_depvar = `mean2'

* Adding marital status and schooling
quietly summarize electricity_job_direct if birth_parish_treated == 0
local mean3 = round(r(mean), 0.01)
probit electricity_job_direct birth_parish_treated age age_2 female i.marital i.schooling, robust
eststo Model3
estadd scalar mean_depvar = `mean3'

ereturn list


* Output the results
esttab Model1 Model2 Model3 using `results_dir'/electricity_job_direct_probit.tex, label replace ///
  stats(r2_p N mean_depvar, fmt(2 0 3 2) labels("Pseudo R-squared" "Observations" "Mean Dependent Var")) ///
  cells(b(star fmt(3)) se(par fmt(2))) ///
  addnotes("Robust standard errors in parentheses")
