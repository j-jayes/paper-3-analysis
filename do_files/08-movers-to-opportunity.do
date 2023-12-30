* Purpose and Overview
* --------------------
* Check what the distance that individuals moved were
* Utilizes the dataset created by set_dataset_params.do

* Initial Setup
* -------------
clear all
set more off 
cd "/Users/jonathanjayes/Documents/PhD/paper-3-analysis/"
use "data/census/1930_census_regression_dataset_params_set.dta" // read in data

* Data Preparation
* ----------------
drop if employed == 0 // Exclude non-employed records

* Define Results Directory
* ------------------------
local results_dir "results/regressions/"

log using "logs/movers-by-distance.log", replace

*--------------------------------------------------*
* What is the average distance someone moves ?	   *
*--------------------------------------------------*

summarize dist_bp_to_cp_km if dist_bp_to_cp_km > 0, detail
/* 
In our sample of treated and control individuals, who are older than 15, the average distance moved from birth parish to current parish is 36 km.
*/


*--------------------------------------------------*
* Do people in treated parishes move more or less? *
*--------------------------------------------------*
* clustering at the parish level.

reg dist_bp_to_cp_km birth_parish_treated, vce(cluster birth_parish_ref_code)

/* 
They move on average 20km more from their birth parish compared to control individuals

This makes sense, as our treated parishes have higher incomes, on average.
*/

*--------------------------------------------------*
* What about when we add in controls?              *
*--------------------------------------------------*

reg dist_bp_to_cp_km birth_parish_treated female age b2.hisclass, vce(cluster birth_parish_ref_code)

/* 
Older people have moved further (this makes sense to me), women move marginally less

Relative to farmers and fishermen, elites move the furthest, followed by foremen and white collar workers.

This also makes sense as it is costly to move, and if you don't have skills that reward moving, you don't.
*/

*--------------------------------------------------*
* What about holders of direct electricity jobs?   *
*--------------------------------------------------*

reg dist_bp_to_cp_km electricity_job_direct birth_parish_treated female age b2.hisclass, vce(cluster birth_parish_ref_code)

/* 
Holders of direct electricity jobs moved 15km further on average to their current parish, controlling for standard controls
*/

*--------------------------------------------------*
* What about holders of indirect electricity jobs?   *
*--------------------------------------------------*

reg dist_bp_to_cp_km electricity_job_indirect birth_parish_treated female age b2.hisclass, vce(cluster birth_parish_ref_code)

/* 
Holders of indirect electricity do not move further on average to their current parish, controlling for standard controls

I think this indicates that skills for direct electricity jobs were more scarce than for indirect electricity jobs. Indirect electricity jobs could be filled locally.
*/






*--------------------------------------------------*
* Movers and stayers   *
*--------------------------------------------------*

gen mover = .
replace mover = 0 if dist_bp_to_cp_km == 0
replace mover = 1 if dist_bp_to_cp_km > 0

label var mover "Moves from parish of birth"

summarize mover, detail

tab mover birth_parish_treated, col

reg log_income mover##birth_parish_treated age age_2 female i.marital i.schooling i.hisclass, vce(cluster birth_parish_ref_code)
eststo Model1


local results_dir "results/regressions/"


* Tabulate the regression results and save them in TeX format
esttab Model1 using `results_dir'/08-log-income-regression-for-movers-and-stayers.tex, label replace ///
  stats(r2 N F mean_depvar, fmt(2 0 3 2) labels("R-squared" "Observations" "F-stat" "Mean Dependent Var")) ///
  cells(b(star fmt(3)) se(par fmt(2))) ///
  addnotes("Clustered standard errors in parentheses")



log close
