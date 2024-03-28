*--------------------------------------------------*
* Income Regressions: log_income as Dependent Var  *
*--------------------------------------------------*

* Set the environment
clear all
set more off 

* Setting the working directory
* cd "C:\Users\User\Documents\Recon\paper-3-analysis"
cd "/Users/jonathanjayes/Documents/PhD/paper-3-analysis/"


* Load the dataset created by the 'set_dataset_params.do' script
use "data/census/1930_census_regression_dataset_params_set.dta"

* Drop observations where the individual is not employed
drop if employed == 0

* Define the results directory for storing output
global results_dir "results/regressions/"

*-------------------------------------------------------------*
* Linear Regressions for log_income: Main Specification 
*-------------------------------------------------------------*


reg log_income birth_parish_treated age age_2 female i.marital i.schooling i.hisclass if birth_parish_distance_to_line <= 100, vce(cluster birth_parish_ref_code)
eststo Model_100


reg log_income birth_parish_treated age age_2 female i.marital i.schooling i.hisclass if birth_parish_distance_to_line <= 150, vce(cluster birth_parish_ref_code) 
eststo Model_150



local start = 100
local end = 500
local increment = 50

forvalues i = `start'(50)`end' {
    reg log_income birth_parish_treated age age_2 female i.marital i.schooling i.hisclass if birth_parish_distance_to_line <= `i', vce(cluster birth_parish_ref_code)
    eststo Model_`i'
}



* Tabulate the regression results and save them in TeX format
esttab Model_100 Model_150 Model_200 Model_250 Model_300 Model_350 Model_400 Model_450 Model_500 using $results_dir/10-log-income-regression-100_500.tex, label replace ///
  stats(r2 N, fmt(2 0) labels("R-squared" "Observations")) keep(birth_parish_treated) ///
  	mtitles("100" "150" "200"  "250" "300" "350" "400" "450" "500") ///
  cells(b(star fmt(3)) se(par fmt(2))) ///
  addnotes("Clustered standard errors in parentheses")
  
