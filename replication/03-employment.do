*--------------------------------------------------*
* Income Regressions: Employment as Dependent Var  *
*--------------------------------------------------*

clear all
set more off 

* Setting the working directory
cd "/Users/jonathanjayes/Documents/PhD/paper-3-analysis/"

* Load the dataset that results from the 'set_dataset_params.do' script
use "data/census/1930_census_regression_dataset_params_set.dta"

*---------------------------------------------------*
* Linear Regressions for Employment 
*---------------------------------------------------*

* Model 1: Employment regression with birth_parish_treated only
reg employed birth_parish_treated, vce(cluster birth_parish_ref_code)

* Model 2: Adding age, age squared, and female to the regression
reg employed birth_parish_treated age age_2 female, vce(cluster birth_parish_ref_code)

* Model 3: Further adding marital status and schooling to the regression
reg employed birth_parish_treated age age_2 female i.marital i.schooling, vce(cluster birth_parish_ref_code)

*---------------------------------------------------*
* Probit Regressions for Employment 
*---------------------------------------------------*

* Model 1: Employment regression using probit with birth_parish_treated only
probit employed birth_parish_treated, vce(cluster birth_parish_ref_code)

* Model 2: Adding age, age squared, and female to the probit regression
probit employed birth_parish_treated age age_2 female, vce(cluster birth_parish_ref_code)

* Model 3: Further adding marital status and schooling to the probit regression
probit employed birth_parish_treated age age_2 female i.marital i.schooling, vce(cluster birth_parish_ref_code)
