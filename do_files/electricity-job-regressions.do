* purpose
* electricity occupation regressions
* uses the dta file that is produced from set_dataset_params.do

clear all
set more off 
cd "C:\Users\User\Documents\Recon\paper-3-analysis"
* read in data from 
use "data/census/1930_census_regression_dataset_params_set.dta"

*** results directory "results/regressions/" as a local
local results_dir "results/regressions/"

*** Regression 1: employment as dependent variable.

* Regression for electricity_job_direct with birth_parish_treated only
quietly summarize electricity_job_direct if birth_parish_treated == 0
local mean1 = round(r(mean), 0.01)
reg electricity_job_direct birth_parish_treated, robust
eststo Model1
estadd scalar mean_depvar = `mean1'

* Adding age and age squared
quietly summarize electricity_job_direct if birth_parish_treated == 0
local mean2 = round(r(mean), 0.01)
reg electricity_job_direct birth_parish_treated age age_2, robust
eststo Model2
estadd scalar mean_depvar = `mean2'

* Adding female
quietly summarize electricity_job_direct if birth_parish_treated == 0
local mean3 = round(r(mean), 0.01)
reg electricity_job_direct birth_parish_treated age age_2 female, robust
eststo Model3
estadd scalar mean_depvar = `mean3'

* Adding marital status
quietly summarize electricity_job_direct if birth_parish_treated == 0
local mean4 = round(r(mean), 0.01)
reg electricity_job_direct birth_parish_treated age age_2 female i.marital, robust
eststo Model4
estadd scalar mean_depvar = `mean4'

* Adding hisclass_group_abb
quietly summarize electricity_job_direct if birth_parish_treated == 0
local mean5 = round(r(mean), 0.01)
reg electricity_job_direct birth_parish_treated age age_2 female i.marital, robust
eststo Model5
estadd scalar mean_depvar = `mean5'

* Adding schooling
quietly summarize electricity_job_direct if birth_parish_treated == 0
local mean6 = round(r(mean), 0.01)
reg electricity_job_direct birth_parish_treated age age_2 female i.marital i.schooling, robust
eststo Model6
estadd scalar mean_depvar = `mean6'



* Output the results
esttab Model1 Model2 Model3 Model4 Model5 Model6 using `results_dir'/electricity_job_direct_regression.tex, label replace ///
  stats(r2 N F mean_depvar, fmt(2 0 3 2) labels("R-squared" "Observations" "F-stat" "Mean Dependent Var")) ///
  cells(b(star fmt(3)) se(par fmt(2))) ///
  addnotes("Robust standard errors in parentheses")

esttab Model1 Model2 Model3 Model4 Model5, keep(birth_parish_treated) nogaps ///
  stats(mean_depvar N, labels("Mean Dep. Var." "Observations")) ///
  star(* 0.05 ** 0.01 *** 0.001) scalars(e(N) "Observations") ///
  mlabels("Model 1" "Model 2" "Model 3" "Model 4" "Model 5") collabels(none) varlabels(_cons Constant) ///
  nonotes label ///
  title("Influence of birth_parish_treated on electricity_job_direct") ///
  caption("Model 1: Baseline, Model 2: Age controls, Model 3: Female controls, Model 4: Marital Status controls, Model 5: Hisclass and Schooling controls") 

