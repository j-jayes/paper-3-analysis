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


* Model 1: Interacting education with birth_parish_treated
reg log_income birth_parish_treated##i.schooling age age_2 female i.marital  i.hisclass, vce(cluster birth_parish_ref_code)
eststo Model1

* Tabulate the regression results and save them in TeX format
esttab Model1 using $results_dir/09-education-impact-regression.tex, label replace ///
  stats(ar2 N F mean_depvar, fmt(2 0 3 2) labels("R-squared" "Observations" "F-stat" "Mean Dependent Var")) ///
  cells(b(star fmt(3)) se(par fmt(2))) ///
  addnotes("Clustered standard errors in parentheses")
