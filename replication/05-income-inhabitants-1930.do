*--------------------------------------------------*
* Income Regressions: inhabitants 1930			   *
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
global results_dir "results/regressions"

*--------------------------------------------------*
* Export 2SLS with ivreg2 	
*--------------------------------------------------*

* OLS no controls
reg log_income current_parish_treated, vce(cluster birth_parish_ref_code)

* First stage no controls
reg current_parish_treated birth_parish_treated, vce(cluster birth_parish_ref_code)

* 2SLS no controls
ivreg2 log_income (current_parish_treated = birth_parish_treated), cluster (birth_parish_ref_code) 

* OLS controls
reg log_income current_parish_treated age age_2 female i.marital i.schooling i.hisclass, vce(cluster birth_parish_ref_code)

* First stage controls
reg current_parish_treated birth_parish_treated age age_2 female i.marital i.schooling i.hisclass, vce(cluster birth_parish_ref_code)

* 2SLS controls
ivreg2 log_income age age_2 female i.marital i.schooling i.hisclass (current_parish_treated = birth_parish_treated), cluster (birth_parish_ref_code) 
