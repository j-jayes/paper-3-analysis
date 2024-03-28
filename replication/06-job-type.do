*--------------------------------------------------*
* Job type regressions  						   *
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
* Direct Electricity Jobs						   *
*--------------------------------------------------*

*** Regression 1: employment as dependent variable.

* Regression for electricity_job_direct with birth_parish_treated only
reg electricity_job_direct birth_parish_treated, robust

* Adding age and age squared and female
reg electricity_job_direct birth_parish_treated age age_2 female, robust

* Adding marital status and schooling
reg electricity_job_direct birth_parish_treated age age_2 female i.marital i.schooling, robust

*--------------------------------------------------*
* Indirect Electricity Jobs						   *
*--------------------------------------------------*

*** Regression 1: employment as dependent variable.

* Regression for electricity_job_indirect with birth_parish_treated only
reg electricity_job_indirect birth_parish_treated, robust

* Adding age and age squared and female
reg electricity_job_indirect birth_parish_treated age age_2 female, robust

* Adding marital status and schooling
reg electricity_job_indirect birth_parish_treated age age_2 female i.marital i.schooling, robust
