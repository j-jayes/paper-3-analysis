* Purpose and Overview
* --------------------
* Income Regressions Analysis
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

* Regression Analysis
* -------------------
* Perform Regression: Log of Income on Demographic and Economic Characteristics
reg log_income female i.marital i.schooling i.hisclass_group_abb ///
    c.age##c.birth_parish_treated, vce(cluster birth_parish_ref_code)

* Marginal Effects Calculation
* ----------------------------
margins, dydx(birth_parish_treated) at(age = (15(1)16)) vce(unconditional)

matrix b = r(b)

* Marginal Effects Plot
* ---------------------
marginsplot

* Outcomes Table Preparation
* --------------------------
local results_dir "results/regressions/"
eststo clear

* Counter Initialization
* ------------------------------------------
local counter = 1

* Loop to Obtain Coefficient for Interaction Term by Age
* ------------------------------------------------------
forvalues i = 15 / 60 {
    quietly reg log_income female i.marital i.schooling i.hisclass_group_abb ///
        c.age##c.birth_parish_treated, vce(cluster birth_parish_ref_code)
    quietly margins, dydx(birth_parish_treated) at(age = `i')  vce(unconditional) post coeflegend
    matrix b = r(b)
    matrix v = r(V)
    scalar b_birth_parish_treated = _b[birth_parish_treated]
    scalar se_birth_parish_treated = _se[birth_parish_treated]
	scalar ci_95_low = _b[birth_parish_treated] - invttail(e(df_r),0.025)*_se[birth_parish_treated]
	scalar ci_95_high = _b[birth_parish_treated] + invttail(e(df_r),0.025)*_se[birth_parish_treated]

    estadd scalar b_birth_parish_treated
    estadd scalar se_birth_parish_treated
	estadd scalar ci_95_low
	estadd scalar ci_95_high
    local counter = `counter' + 1
    eststo
}

* Export Regression Table to LaTeX
* -------------------------------
esttab using `results_dir'/05-income-regressions-age-check.tex , stats(ci_95_low ci_95_high) replace
