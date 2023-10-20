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

eststo clear

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
  
  
*---------------------------------------------------*
* Linear Regressions for Employment (income of zero)
*---------------------------------------------------*

eststo clear

* Model 1: Holds occupational title but income of zero or missing regression with birth_parish_treated only
quietly summarize occ_title_without_income
local mean1 = round(r(mean), 0.01)
reg occ_title_without_income birth_parish_treated, vce(cluster birth_parish_ref_code)
eststo Model1
estadd scalar mean_depvar = `mean1'

* Model 2: Adding age, age squared, and female to the regression
quietly summarize occ_title_without_income
local mean2 = round(r(mean), 0.01)
reg occ_title_without_income birth_parish_treated age age_2 female, vce(cluster birth_parish_ref_code)
eststo Model2
estadd scalar mean_depvar = `mean2'

* Model 3: Further adding marital status and schooling to the regression
quietly summarize occ_title_without_income
local mean3 = round(r(mean), 0.01)
reg occ_title_without_income birth_parish_treated age age_2 female i.marital i.schooling, vce(cluster birth_parish_ref_code)
eststo Model3
estadd scalar mean_depvar = `mean3'

* Tabulate linear regression results
esttab Model1 Model2 Model3 using `results_dir'/033-occ_title_no_income_regression.tex, label replace ///
  stats(r2 N F mean_depvar, fmt(2 0 3 2) labels("R-squared" "Observations" "F-stat" "Mean Dependent Var")) ///
  cells(b(star fmt(3)) se(par fmt(2))) ///
  addnotes("Robust standard errors in parentheses")
  
  
  
*---------------------------------------------------*
* Linear Regressions for Employment: effect of unions 1900
*---------------------------------------------------*

eststo clear

* Model 1: Employment regression with birth_parish_treated only
quietly summarize employed
local mean1 = round(r(mean), 0.01)
reg employed birth_parish_treated##c.popular_movement_density_1900_FA, vce(cluster birth_parish_ref_code)
eststo Model1
estadd scalar mean_depvar = `mean1'

* Model 2: Adding age, age squared, and female to the regression
quietly summarize employed
local mean2 = round(r(mean), 0.01)
reg employed birth_parish_treated##c.popular_movement_density_1900_FA age age_2 female, vce(cluster birth_parish_ref_code)
eststo Model2
estadd scalar mean_depvar = `mean2'

* Model 3: Further adding marital status and schooling to the regression
quietly summarize employed
local mean3 = round(r(mean), 0.01)
reg employed birth_parish_treated##c.popular_movement_density_1900_FA age age_2 female i.marital i.schooling, vce(cluster birth_parish_ref_code)
eststo Model3
estadd scalar mean_depvar = `mean3'

* Tabulate linear regression results
esttab Model1 Model2 Model3 using `results_dir'/034-employed_regression.tex, label replace ///
  stats(r2 N F mean_depvar, fmt(2 0 3 2) labels("R-squared" "Observations" "F-stat" "Mean Dependent Var")) ///
  cells(b(star fmt(3)) se(par fmt(2))) ///
  addnotes("Robust standard errors in parentheses")
  
  
*---------------------------------------------------*
* Linear Regressions for Employment: effect of unions 1910
*---------------------------------------------------*

eststo clear

* Model 1: Employment regression with birth_parish_treated only
quietly summarize employed
local mean1 = round(r(mean), 0.01)
reg employed birth_parish_treated##c.popular_movement_density_1910_FA, vce(cluster birth_parish_ref_code)
eststo Model1
estadd scalar mean_depvar = `mean1'

* Model 2: Adding age, age squared, and female to the regression
quietly summarize employed
local mean2 = round(r(mean), 0.01)
reg employed birth_parish_treated##c.popular_movement_density_1910_FA age age_2 female, vce(cluster birth_parish_ref_code)
eststo Model2
estadd scalar mean_depvar = `mean2'

* Model 3: Further adding marital status and schooling to the regression
quietly summarize employed
local mean3 = round(r(mean), 0.01)
reg employed birth_parish_treated##c.popular_movement_density_1910_FA age age_2 female i.marital i.schooling, vce(cluster birth_parish_ref_code)
eststo Model3
estadd scalar mean_depvar = `mean3'

* Tabulate linear regression results
esttab Model1 Model2 Model3 using `results_dir'/035-employed_regression.tex, label replace ///
  stats(r2 N F mean_depvar, fmt(2 0 3 2) labels("R-squared" "Observations" "F-stat" "Mean Dependent Var")) ///
  cells(b(star fmt(3)) se(par fmt(2))) ///
  addnotes("Robust standard errors in parentheses")
  

*---------------------------------------------------*
* Linear Regressions for Employment: effect of temperence 1900
*---------------------------------------------------*

eststo clear

* Model 1: Employment regression with birth_parish_treated only
quietly summarize employed
local mean1 = round(r(mean), 0.01)
reg employed birth_parish_treated##c.popular_movement_density_1900_NY, vce(cluster birth_parish_ref_code)
eststo Model1
estadd scalar mean_depvar = `mean1'

* Model 2: Adding age, age squared, and female to the regression
quietly summarize employed
local mean2 = round(r(mean), 0.01)
reg employed birth_parish_treated##c.popular_movement_density_1900_NY age age_2 female, vce(cluster birth_parish_ref_code)
eststo Model2
estadd scalar mean_depvar = `mean2'

* Model 3: Further adding marital status and schooling to the regression
quietly summarize employed
local mean3 = round(r(mean), 0.01)
reg employed birth_parish_treated##c.popular_movement_density_1900_NY age age_2 female i.marital i.schooling, vce(cluster birth_parish_ref_code)
eststo Model3
estadd scalar mean_depvar = `mean3'

* Tabulate linear regression results
esttab Model1 Model2 Model3 using `results_dir'/036-employed_regression.tex, label replace ///
  stats(r2 N F mean_depvar, fmt(2 0 3 2) labels("R-squared" "Observations" "F-stat" "Mean Dependent Var")) ///
  cells(b(star fmt(3)) se(par fmt(2))) ///
  addnotes("Robust standard errors in parentheses")
  
  
*---------------------------------------------------*
* Linear Regressions for Employment: effect of temperence 1910
*---------------------------------------------------*

eststo clear

* Model 1: Employment regression with birth_parish_treated only
quietly summarize employed
local mean1 = round(r(mean), 0.01)
reg employed birth_parish_treated##c.popular_movement_density_1910_NY, vce(cluster birth_parish_ref_code)
eststo Model1
estadd scalar mean_depvar = `mean1'

* Model 2: Adding age, age squared, and female to the regression
quietly summarize employed
local mean2 = round(r(mean), 0.01)
reg employed birth_parish_treated##c.popular_movement_density_1910_NY age age_2 female, vce(cluster birth_parish_ref_code)
eststo Model2
estadd scalar mean_depvar = `mean2'

* Model 3: Further adding marital status and schooling to the regression
quietly summarize employed
local mean3 = round(r(mean), 0.01)
reg employed birth_parish_treated##c.popular_movement_density_1910_NY age age_2 female i.marital i.schooling, vce(cluster birth_parish_ref_code)
eststo Model3
estadd scalar mean_depvar = `mean3'

* Tabulate linear regression results
esttab Model1 Model2 Model3 using `results_dir'/037-employed_regression.tex, label replace ///
  stats(r2 N F mean_depvar, fmt(2 0 3 2) labels("R-squared" "Observations" "F-stat" "Mean Dependent Var")) ///
  cells(b(star fmt(3)) se(par fmt(2))) ///
  addnotes("Robust standard errors in parentheses")
  

  

*---------------------------------------------------*
* Linear Regressions for Employment: effect of party membership 1900
*---------------------------------------------------*

eststo clear

* Model 1: Employment regression with birth_parish_treated only
quietly summarize employed
local mean1 = round(r(mean), 0.01)
reg employed birth_parish_treated##c.popular_movement_density_1900_PA, vce(cluster birth_parish_ref_code)
eststo Model1
estadd scalar mean_depvar = `mean1'

* Model 2: Adding age, age squared, and female to the regression
quietly summarize employed
local mean2 = round(r(mean), 0.01)
reg employed birth_parish_treated##c.popular_movement_density_1900_PA age age_2 female, vce(cluster birth_parish_ref_code)
eststo Model2
estadd scalar mean_depvar = `mean2'

* Model 3: Further adding marital status and schooling to the regression
quietly summarize employed
local mean3 = round(r(mean), 0.01)
reg employed birth_parish_treated##c.popular_movement_density_1900_PA age age_2 female i.marital i.schooling, vce(cluster birth_parish_ref_code)
eststo Model3
estadd scalar mean_depvar = `mean3'

* Tabulate linear regression results
esttab Model1 Model2 Model3 using `results_dir'/037-employed_regression.tex, label replace ///
  stats(r2 N F mean_depvar, fmt(2 0 3 2) labels("R-squared" "Observations" "F-stat" "Mean Dependent Var")) ///
  cells(b(star fmt(3)) se(par fmt(2))) ///
  addnotes("Robust standard errors in parentheses")
  
  
*---------------------------------------------------*
* Linear Regressions for Employment: effect of party membership 1910
*---------------------------------------------------*

eststo clear

* Model 1: Employment regression with birth_parish_treated only
quietly summarize employed
local mean1 = round(r(mean), 0.01)
reg employed birth_parish_treated##c.popular_movement_density_1910_PA, vce(cluster birth_parish_ref_code)
eststo Model1
estadd scalar mean_depvar = `mean1'

* Model 2: Adding age, age squared, and female to the regression
quietly summarize employed
local mean2 = round(r(mean), 0.01)
reg employed birth_parish_treated##c.popular_movement_density_1910_PA age age_2 female, vce(cluster birth_parish_ref_code)
eststo Model2
estadd scalar mean_depvar = `mean2'

* Model 3: Further adding marital status and schooling to the regression
quietly summarize employed
local mean3 = round(r(mean), 0.01)
reg employed birth_parish_treated##c.popular_movement_density_1910_PA age age_2 female i.marital i.schooling, vce(cluster birth_parish_ref_code)
eststo Model3
estadd scalar mean_depvar = `mean3'

* Tabulate linear regression results
esttab Model1 Model2 Model3 using `results_dir'/038-employed_regression.tex, label replace ///
  stats(r2 N F mean_depvar, fmt(2 0 3 2) labels("R-squared" "Observations" "F-stat" "Mean Dependent Var")) ///
  cells(b(star fmt(3)) se(par fmt(2))) ///
  addnotes("Robust standard errors in parentheses")
  

*---------------------------------------------------*
* Linear Regressions for Employment: effect of free church membership 1900
*---------------------------------------------------*

eststo clear

* Model 1: Employment regression with birth_parish_treated only
quietly summarize employed
local mean1 = round(r(mean), 0.01)
reg employed birth_parish_treated##c.popular_movement_density_1900_FR, vce(cluster birth_parish_ref_code)
eststo Model1
estadd scalar mean_depvar = `mean1'

* Model 2: Adding age, age squared, and female to the regression
quietly summarize employed
local mean2 = round(r(mean), 0.01)
reg employed birth_parish_treated##c.popular_movement_density_1900_FR age age_2 female, vce(cluster birth_parish_ref_code)
eststo Model2
estadd scalar mean_depvar = `mean2'

* Model 3: Further adding marital status and schooling to the regression
quietly summarize employed
local mean3 = round(r(mean), 0.01)
reg employed birth_parish_treated##c.popular_movement_density_1900_FR age age_2 female i.marital i.schooling, vce(cluster birth_parish_ref_code)
eststo Model3
estadd scalar mean_depvar = `mean3'

* Tabulate linear regression results
esttab Model1 Model2 Model3 using `results_dir'/039-employed_regression.tex, label replace ///
  stats(r2 N F mean_depvar, fmt(2 0 3 2) labels("R-squared" "Observations" "F-stat" "Mean Dependent Var")) ///
  cells(b(star fmt(3)) se(par fmt(2))) ///
  addnotes("Robust standard errors in parentheses")
  
  
*---------------------------------------------------*
* Linear Regressions for Employment: effect of free church membership 1910
*---------------------------------------------------*

eststo clear

* Model 1: Employment regression with birth_parish_treated only
quietly summarize employed
local mean1 = round(r(mean), 0.01)
reg employed birth_parish_treated##c.popular_movement_density_1910_FR, vce(cluster birth_parish_ref_code)
eststo Model1
estadd scalar mean_depvar = `mean1'

* Model 2: Adding age, age squared, and female to the regression
quietly summarize employed
local mean2 = round(r(mean), 0.01)
reg employed birth_parish_treated##c.popular_movement_density_1910_FR age age_2 female, vce(cluster birth_parish_ref_code)
eststo Model2
estadd scalar mean_depvar = `mean2'

* Model 3: Further adding marital status and schooling to the regression
quietly summarize employed
local mean3 = round(r(mean), 0.01)
reg employed birth_parish_treated##c.popular_movement_density_1910_FR age age_2 female i.marital i.schooling, vce(cluster birth_parish_ref_code)
eststo Model3
estadd scalar mean_depvar = `mean3'

* Tabulate linear regression results
esttab Model1 Model2 Model3 using `results_dir'/0391-employed_regression.tex, label replace ///
  stats(r2 N F mean_depvar, fmt(2 0 3 2) labels("R-squared" "Observations" "F-stat" "Mean Dependent Var")) ///
  cells(b(star fmt(3)) se(par fmt(2))) ///
  addnotes("Robust standard errors in parentheses")
  