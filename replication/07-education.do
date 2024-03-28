*--------------------------------------------------*
* Education impact		  						   *
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
* Education impact regression					   *
*--------------------------------------------------*

* Model 1: Interacting education with birth_parish_treated
reg log_income birth_parish_treated##i.schooling age age_2 female i.marital  i.hisclass, vce(cluster birth_parish_ref_code)
