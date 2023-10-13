*--------------------------------------------------*
* Income Regressions: Employment as Dependent Var  *
*--------------------------------------------------*

clear all
set more off 

* Setting the working directory
cd "C:\Users\User\Documents\Recon\paper-3-analysis"

* Load the dataset that results from the 'set_dataset_params.do' script
use "data/census/1930_census_regression_dataset_params_set.dta"

* Define the results directory for storing output
local results_dir "results/regressions/"

*---------------------------------------------------*
* Linear Regressions for Employment 
*---------------------------------------------------*

* Model 1: Employment regression with birth_parish_treated only
quietly summarize employed
local mean1 = round(r(mean), 0.01)
reg employed birth_parish_treated, vce(cluster birth_parish_ref_code)
eststo Model1
estadd scalar mean_depvar = `mean1'

* Model 2: Adding age, age squared, and female to the regression
quietly summarize employed
local mean2 = round(r(mean), 0.01)
reg employed birth_parish_treated age age_2 female, vce(cluster birth_parish_ref_code)
eststo Model2
estadd scalar mean_depvar = `mean2'

* Model 3: Further adding marital status and schooling to the regression
quietly summarize employed
local mean3 = round(r(mean), 0.01)
reg employed birth_parish_treated age age_2 female i.marital i.schooling, vce(cluster birth_parish_ref_code)
eststo Model3
estadd scalar mean_depvar = `mean3'

* Tabulate linear regression results
esttab Model1 Model2 Model3 using `results_dir'/031-employed_regression.tex, label replace ///
  stats(r2 N F mean_depvar, fmt(2 0 3 2) labels("R-squared" "Observations" "F-stat" "Mean Dependent Var")) ///
  cells(b(star fmt(3)) se(par fmt(2))) ///
  addnotes("Robust standard errors in parentheses")

*---------------------------------------------------*
* Probit Regressions for Employment 
*---------------------------------------------------*

* Model 1: Employment regression using probit with birth_parish_treated only
quietly summarize employed
local mean1 = round(r(mean), 0.01)
probit employed birth_parish_treated, vce(cluster birth_parish_ref_code)
eststo Model1
estadd scalar mean_depvar = `mean1'

* Model 2: Adding age, age squared, and female to the probit regression
quietly summarize employed
local mean2 = round(r(mean), 0.01)
probit employed birth_parish_treated age age_2 female, vce(cluster birth_parish_ref_code)
eststo Model2
estadd scalar mean_depvar = `mean2'

* Model 3: Further adding marital status and schooling to the probit regression
quietly summarize employed
local mean3 = round(r(mean), 0.01)
probit employed birth_parish_treated age age_2 female i.marital i.schooling, vce(cluster birth_parish_ref_code)
eststo Model3
estadd scalar mean_depvar = `mean3'

* Tabulate probit regression results
esttab Model1 Model2 Model3 using `results_dir'/032-employed_probit.tex, label replace ///
  stats(r2 N F mean_depvar, fmt(2 0 3 2) labels("R-squared" "Observations" "F-stat" "Mean Dependent Var")) ///
  cells(b(star fmt(3)) se(par fmt(2))) ///
  addnotes("Robust standard errors in parentheses")
