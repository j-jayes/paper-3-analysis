*--------------------------------------------------*
* Income Regressions: log_income as Dependent Var  *
*--------------------------------------------------*

* Set the environment
clear all
set more off 

* Setting the working directory
cd "C:\Users\User\Documents\Recon\paper-3-analysis"

* Load the dataset created by the 'set_dataset_params.do' script
use "data/census/1930_census_regression_dataset_params_set.dta"

* Drop observations where the individual is not employed
drop if employed == 0

* Define the results directory for storing output
local results_dir "results/regressions/"

*-------------------------------------------------------------*
* Linear Regressions for log_income: Main Specification 
*-------------------------------------------------------------*

* Model 1: Regression with log_income as DV, birth_parish_treated as IV
quietly summarize log_income
local mean1 = round(r(mean), 0.01)
reg log_income birth_parish_treated, vce(cluster birth_parish_ref_code)
eststo Model1
estadd scalar mean_depvar = `mean1'

* Model 2: Extending Model 1 by adding age, age squared, and female
quietly summarize log_income
local mean2 = round(r(mean), 0.01)
reg log_income birth_parish_treated age age_2 female, vce(cluster birth_parish_ref_code)
eststo Model2
estadd scalar mean_depvar = `mean2'

* Model 3: Extending Model 2 by adding marital status, schooling, and hisclass_group_abb
quietly summarize log_income
local mean3 = round(r(mean), 0.01)
reg log_income birth_parish_treated age age_2 female i.marital i.schooling i.hisclass_group_abb, vce(cluster birth_parish_ref_code)
eststo Model3
estadd scalar mean_depvar = `mean3'

* Tabulate the regression results and save them in TeX format
esttab Model1 Model2 Model3 using `results_dir'/04_log-income-regression.tex, label replace ///
  stats(r2 N F mean_depvar, fmt(2 0 3 2) labels("R-squared" "Observations" "F-stat" "Mean Dependent Var")) ///
  cells(b(star fmt(3)) se(par fmt(2))) ///
  addnotes("Robust standard errors in parentheses")
  
  
*-------------------------------------------------------------*
* Quantile Regressions for log_income: Main Specification 
*-------------------------------------------------------------*

* Model 1: Regression with log_income as DV, birth_parish_treated as IV
quietly summarize log_income
local mean1 = round(r(mean), 0.01)
reg log_income birth_parish_treated, vce(cluster birth_parish_ref_code)
eststo Model1
estadd scalar mean_depvar = `mean1'

* Model 2: Extending Model 1 by adding age, age squared, and female
quietly summarize log_income
local mean2 = round(r(mean), 0.01)
reg log_income birth_parish_treated age age_2 female, vce(cluster birth_parish_ref_code)
eststo Model2
estadd scalar mean_depvar = `mean2'

* Model 3: Extending Model 2 by adding marital status, schooling, and hisclass_group_abb
quietly summarize log_income
local mean3 = round(r(mean), 0.01)
reg log_income birth_parish_treated age age_2 female i.marital i.schooling i.hisclass_group_abb, vce(cluster birth_parish_ref_code)
eststo Model3
estadd scalar mean_depvar = `mean3'

* Tabulate the regression results and save them in TeX format
esttab Model1 Model2 Model3 using `results_dir'/04_log-income-regression.tex, label replace ///
  stats(r2 N F mean_depvar, fmt(2 0 3 2) labels("R-squared" "Observations" "F-stat" "Mean Dependent Var")) ///
  cells(b(star fmt(3)) se(par fmt(2))) ///
  addnotes("Robust standard errors in parentheses")

*-------------------------------------------------------------*
* Linear Regressions for log_income: Interaction with union membership
*-------------------------------------------------------------*

eststo clear

* Model 1: Regression with log_income as DV, birth_parish_treated as IV
quietly summarize log_income
local mean1 = round(r(mean), 0.01)
reg log_income birth_parish_treated##c.popular_movement_density_1900_FA, vce(cluster birth_parish_ref_code)
eststo Model1
estadd scalar mean_depvar = `mean1'

* Model 2: Extending Model 1 by adding age, age squared, and female
quietly summarize log_income
local mean2 = round(r(mean), 0.01)
reg log_income birth_parish_treated##c.popular_movement_density_1900_FA age age_2 female, vce(cluster birth_parish_ref_code)
eststo Model2
estadd scalar mean_depvar = `mean2'

* Model 3: Extending Model 2 by adding marital status, schooling, and hisclass_group_abb
quietly summarize log_income
local mean3 = round(r(mean), 0.01)
reg log_income birth_parish_treated##c.popular_movement_density_1900_FA age age_2 female i.marital i.schooling i.hisclass_group_abb, vce(cluster birth_parish_ref_code)
eststo Model3
estadd scalar mean_depvar = `mean3'

* Tabulate the regression results and save them in TeX format
esttab Model1 Model2 Model3 using `results_dir'/041_log-income-regression_interaction.tex, label replace ///
  stats(r2 N F mean_depvar, fmt(2 0 3 2) labels("R-squared" "Observations" "F-stat" "Mean Dependent Var")) ///
  cells(b(star fmt(3)) se(par fmt(2))) ///
  addnotes("Robust standard errors in parentheses")

*-------------------------------------------------------------*
* Linear Regressions for log_income: Interaction with union membership
*-------------------------------------------------------------*

eststo clear

* Model 1: Regression with log_income as DV, birth_parish_treated as IV
quietly summarize log_income
local mean1 = round(r(mean), 0.01)
reg log_income birth_parish_treated##c.popular_movement_density_1910_FA, vce(cluster birth_parish_ref_code)
eststo Model1
estadd scalar mean_depvar = `mean1'

* Model 2: Extending Model 1 by adding age, age squared, and female
quietly summarize log_income
local mean2 = round(r(mean), 0.01)
reg log_income birth_parish_treated##c.popular_movement_density_1910_FA age age_2 female, vce(cluster birth_parish_ref_code)
eststo Model2
estadd scalar mean_depvar = `mean2'

* Model 3: Extending Model 2 by adding marital status, schooling, and hisclass_group_abb
quietly summarize log_income
local mean3 = round(r(mean), 0.01)
reg log_income birth_parish_treated##c.popular_movement_density_1910_FA age age_2 female i.marital i.schooling i.hisclass_group_abb, vce(cluster birth_parish_ref_code)
eststo Model3
estadd scalar mean_depvar = `mean3'

* Tabulate the regression results and save them in TeX format
esttab Model1 Model2 Model3 using `results_dir'/041_log-income-regression_interaction.tex, label replace ///
  stats(r2 N F mean_depvar, fmt(2 0 3 2) labels("R-squared" "Observations" "F-stat" "Mean Dependent Var")) ///
  cells(b(star fmt(3)) se(par fmt(2))) ///
  addnotes("Robust standard errors in parentheses")
  
*-------------------------------------------------------------*
* Linear Regressions for log_income: Interaction with temperence movement
*-------------------------------------------------------------*

eststo clear

* Model 1: Regression with log_income as DV, birth_parish_treated as IV
quietly summarize log_income
local mean1 = round(r(mean), 0.01)
reg log_income birth_parish_treated##c.popular_movement_density_1900_NY, vce(cluster birth_parish_ref_code)
eststo Model1
estadd scalar mean_depvar = `mean1'

* Model 2: Extending Model 1 by adding age, age squared, and female
quietly summarize log_income
local mean2 = round(r(mean), 0.01)
reg log_income birth_parish_treated##c.popular_movement_density_1900_NY age age_2 female, vce(cluster birth_parish_ref_code)
eststo Model2
estadd scalar mean_depvar = `mean2'

* Model 3: Extending Model 2 by adding marital status, schooling, and hisclass_group_abb
quietly summarize log_income
local mean3 = round(r(mean), 0.01)
reg log_income birth_parish_treated##c.popular_movement_density_1900_NY age age_2 female i.marital i.schooling i.hisclass_group_abb, vce(cluster birth_parish_ref_code)
eststo Model3
estadd scalar mean_depvar = `mean3'

* Tabulate the regression results and save them in TeX format
esttab Model1 Model2 Model3 using `results_dir'/041_log-income-regression_interaction.tex, label replace ///
  stats(r2 N F mean_depvar, fmt(2 0 3 2) labels("R-squared" "Observations" "F-stat" "Mean Dependent Var")) ///
  cells(b(star fmt(3)) se(par fmt(2))) ///
  addnotes("Robust standard errors in parentheses")

*-------------------------------------------------------------*
* Linear Regressions for log_income: Interaction with temperence movement
*-------------------------------------------------------------*

eststo clear

* Model 1: Regression with log_income as DV, birth_parish_treated as IV
quietly summarize log_income
local mean1 = round(r(mean), 0.01)
reg log_income birth_parish_treated##c.popular_movement_density_1910_NY, vce(cluster birth_parish_ref_code)
eststo Model1
estadd scalar mean_depvar = `mean1'

* Model 2: Extending Model 1 by adding age, age squared, and female
quietly summarize log_income
local mean2 = round(r(mean), 0.01)
reg log_income birth_parish_treated##c.popular_movement_density_1910_NY age age_2 female, vce(cluster birth_parish_ref_code)
eststo Model2
estadd scalar mean_depvar = `mean2'

* Model 3: Extending Model 2 by adding marital status, schooling, and hisclass_group_abb
quietly summarize log_income
local mean3 = round(r(mean), 0.01)
reg log_income birth_parish_treated##c.popular_movement_density_1910_NY age age_2 female i.marital i.schooling i.hisclass_group_abb, vce(cluster birth_parish_ref_code)
eststo Model3
estadd scalar mean_depvar = `mean3'

* Tabulate the regression results and save them in TeX format
esttab Model1 Model2 Model3 using `results_dir'/041_log-income-regression_interaction.tex, label replace ///
  stats(r2 N F mean_depvar, fmt(2 0 3 2) labels("R-squared" "Observations" "F-stat" "Mean Dependent Var")) ///
  cells(b(star fmt(3)) se(par fmt(2))) ///
  addnotes("Robust standard errors in parentheses")
  
*-------------------------------------------------------------*
* Linear Regressions for log_income: Interaction with party membership
*-------------------------------------------------------------*

eststo clear

* Model 1: Regression with log_income as DV, birth_parish_treated as IV
quietly summarize log_income
local mean1 = round(r(mean), 0.01)
reg log_income birth_parish_treated##c.popular_movement_density_1900_PA, vce(cluster birth_parish_ref_code)
eststo Model1
estadd scalar mean_depvar = `mean1'

* Model 2: Extending Model 1 by adding age, age squared, and female
quietly summarize log_income
local mean2 = round(r(mean), 0.01)
reg log_income birth_parish_treated##c.popular_movement_density_1900_PA age age_2 female, vce(cluster birth_parish_ref_code)
eststo Model2
estadd scalar mean_depvar = `mean2'

* Model 3: Extending Model 2 by adding marital status, schooling, and hisclass_group_abb
quietly summarize log_income
local mean3 = round(r(mean), 0.01)
reg log_income birth_parish_treated##c.popular_movement_density_1900_PA age age_2 female i.marital i.schooling i.hisclass_group_abb, vce(cluster birth_parish_ref_code)
eststo Model3
estadd scalar mean_depvar = `mean3'

* Tabulate the regression results and save them in TeX format
esttab Model1 Model2 Model3 using `results_dir'/041_log-income-regression_interaction.tex, label replace ///
  stats(r2 N F mean_depvar, fmt(2 0 3 2) labels("R-squared" "Observations" "F-stat" "Mean Dependent Var")) ///
  cells(b(star fmt(3)) se(par fmt(2))) ///
  addnotes("Robust standard errors in parentheses")

*-------------------------------------------------------------*
* Linear Regressions for log_income: Interaction with party membership
*-------------------------------------------------------------*

eststo clear

* Model 1: Regression with log_income as DV, birth_parish_treated as IV
quietly summarize log_income
local mean1 = round(r(mean), 0.01)
reg log_income birth_parish_treated##c.popular_movement_density_1910_PA, vce(cluster birth_parish_ref_code)
eststo Model1
estadd scalar mean_depvar = `mean1'

* Model 2: Extending Model 1 by adding age, age squared, and female
quietly summarize log_income
local mean2 = round(r(mean), 0.01)
reg log_income birth_parish_treated##c.popular_movement_density_1910_PA age age_2 female, vce(cluster birth_parish_ref_code)
eststo Model2
estadd scalar mean_depvar = `mean2'

* Model 3: Extending Model 2 by adding marital status, schooling, and hisclass_group_abb
quietly summarize log_income
local mean3 = round(r(mean), 0.01)
reg log_income birth_parish_treated##c.popular_movement_density_1910_PA age age_2 female i.marital i.schooling i.hisclass_group_abb, vce(cluster birth_parish_ref_code)
eststo Model3
estadd scalar mean_depvar = `mean3'

* Tabulate the regression results and save them in TeX format
esttab Model1 Model2 Model3 using `results_dir'/041_log-income-regression_interaction.tex, label replace ///
  stats(r2 N F mean_depvar, fmt(2 0 3 2) labels("R-squared" "Observations" "F-stat" "Mean Dependent Var")) ///
  cells(b(star fmt(3)) se(par fmt(2))) ///
  addnotes("Robust standard errors in parentheses")
  
*-------------------------------------------------------------*
* Linear Regressions for log_income: Interaction with free church membership
*-------------------------------------------------------------*

eststo clear

* Model 1: Regression with log_income as DV, birth_parish_treated as IV
quietly summarize log_income
local mean1 = round(r(mean), 0.01)
reg log_income birth_parish_treated##c.popular_movement_density_1900_FR, vce(cluster birth_parish_ref_code)
eststo Model1
estadd scalar mean_depvar = `mean1'

* Model 2: Extending Model 1 by adding age, age squared, and female
quietly summarize log_income
local mean2 = round(r(mean), 0.01)
reg log_income birth_parish_treated##c.popular_movement_density_1900_FR age age_2 female, vce(cluster birth_parish_ref_code)
eststo Model2
estadd scalar mean_depvar = `mean2'

* Model 3: Extending Model 2 by adding marital status, schooling, and hisclass_group_abb
quietly summarize log_income
local mean3 = round(r(mean), 0.01)
reg log_income birth_parish_treated##c.popular_movement_density_1900_FR age age_2 female i.marital i.schooling i.hisclass_group_abb, vce(cluster birth_parish_ref_code)
eststo Model3
estadd scalar mean_depvar = `mean3'

* Tabulate the regression results and save them in TeX format
esttab Model1 Model2 Model3 using `results_dir'/041_log-income-regression_interaction.tex, label replace ///
  stats(r2 N F mean_depvar, fmt(2 0 3 2) labels("R-squared" "Observations" "F-stat" "Mean Dependent Var")) ///
  cells(b(star fmt(3)) se(par fmt(2))) ///
  addnotes("Robust standard errors in parentheses")

*-------------------------------------------------------------*
* Linear Regressions for log_income: Interaction with free church membership
*-------------------------------------------------------------*

eststo clear

* Model 1: Regression with log_income as DV, birth_parish_treated as IV
quietly summarize log_income
local mean1 = round(r(mean), 0.01)
reg log_income birth_parish_treated##c.popular_movement_density_1910_FR, vce(cluster birth_parish_ref_code)
eststo Model1
estadd scalar mean_depvar = `mean1'

* Model 2: Extending Model 1 by adding age, age squared, and female
quietly summarize log_income
local mean2 = round(r(mean), 0.01)
reg log_income birth_parish_treated##c.popular_movement_density_1910_FR age age_2 female, vce(cluster birth_parish_ref_code)
eststo Model2
estadd scalar mean_depvar = `mean2'

* Model 3: Extending Model 2 by adding marital status, schooling, and hisclass_group_abb
quietly summarize log_income
local mean3 = round(r(mean), 0.01)
reg log_income birth_parish_treated##c.popular_movement_density_1910_FR age age_2 female i.marital i.schooling i.hisclass_group_abb, vce(cluster birth_parish_ref_code)
eststo Model3
estadd scalar mean_depvar = `mean3'

* Tabulate the regression results and save them in TeX format
esttab Model1 Model2 Model3 using `results_dir'/041_log-income-regression_interaction.tex, label replace ///
  stats(r2 N F mean_depvar, fmt(2 0 3 2) labels("R-squared" "Observations" "F-stat" "Mean Dependent Var")) ///
  cells(b(star fmt(3)) se(par fmt(2))) ///
  addnotes("Robust standard errors in parentheses")

