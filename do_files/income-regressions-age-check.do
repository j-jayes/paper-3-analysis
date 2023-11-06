* purpose
* income regressions
* uses the dta file that is produced from set_dataset_params.do

clear all
set more off 
cd "/Users/jonathanjayes/Documents/PhD/paper-3-analysis/"
* read in data from 
use "data/census/1930_census_regression_dataset_params_set.dta"

drop if employed == 0

* Gen age categories


*** results directory "results/regressions/" as a local
local results_dir "results/margins/"


* Model 1: 
reg log_income female i.marital i.schooling i.hisclass_group_abb ///
	c.age##c.birth_parish_treated, vce(cluster birth_parish_ref_code)

eststo: margins, dydx(birth_parish_treated) at(age = (min_age_value(1)max_age_value))

esttab using results.csv, replace








quietly summarize log_income
local mean3 = round(r(mean), 0.01)
reg log_income birth_parish_treated age age_2 female i.marital i.schooling i.hisclass_group_abb, vce(cluster birth_parish_ref_code)
eststo Model1
estadd scalar mean_depvar = `mean3'

* Tabulate the regression results and save them in TeX format
esttab Model1 using `results_dir'/05-income-regressions-age-check.do.tex, label replace ///
  stats(r2 N F mean_depvar, fmt(2 0 3 2) labels("R-squared" "Observations" "F-stat" "Mean Dependent Var")) ///
  cells(b(star fmt(3)) se(par fmt(2))) ///s
  addnotes("Robust standard errors in parentheses")
  
  



*** Regression 1: log_income as dependent variable.

* Regression for log_income with birth_parish_treated only
quietly summarize log_income if birth_parish_treated == 0
local mean1 = round(r(mean), 0.01)
reg log_income birth_parish_treated#age_40_plus, robust
eststo Model1
estadd scalar mean_depvar = `mean1'

* Adding age and age squared and female
quietly summarize log_income if birth_parish_treated == 0
local mean2 = round(r(mean), 0.01)
reg log_income birth_parish_treated#age_40_plus age age_2 female, robust
eststo Model2
estadd scalar mean_depvar = `mean2'

* Adding schooling
quietly summarize log_income if birth_parish_treated == 0
local mean3 = round(r(mean), 0.01)
reg log_income birth_parish_treated#age_40_plus age age_2 female i.marital i.schooling i.hisclass_group_abb, robust
eststo Model3
estadd scalar mean_depvar = `mean3'


esttab Model1 Model2 Model3 using `results_dir'/log_income_regression_age_40_plus.tex, label replace ///
  stats(r2 N F mean_depvar, fmt(2 0 3 2) labels("R-squared" "Observations" "F-stat" "Mean Dependent Var")) ///
  cells(b(star fmt(3)) se(par fmt(2))) ///
  addnotes("Robust standard errors in parentheses")


*** Regression 2: log_income as dependent variable.

eststo clear

* Defining results directory

forval i=16/69 {

	quietly summarize log_income if age == `i'
	local mean_`i' = round(r(mean), 0.01)
	quietly reg log_income birth_parish_treated female i.marital i.schooling i.hisclass_group_abb if age == `i', robust
	eststo Model_`i'
	estadd scalar mean_depvar = `mean_`i''

}

* Corrected esttab command to match the looped model names
esttab Model_16 Model_17 Model_18 Model_19 Model_20 Model_21 Model_22 Model_23 Model_24 Model_25 Model_26 Model_27 Model_28 Model_29 Model_30 Model_31 Model_32 Model_33 Model_34 Model_35 Model_36 Model_37 Model_38 Model_39 Model_40 Model_41 Model_42 Model_43 Model_44 Model_45 Model_46 Model_47 Model_48 Model_49 Model_50 Model_51 Model_52 Model_53 Model_54 Model_55 Model_56 Model_57 Model_58 Model_59 Model_60 Model_61 Model_62 Model_63 Model_64 Model_65 Model_66 Model_67 Model_68 Model_69 using "`results_dir'/log_income_regression_age_16_69.csv", label replace ///
  stats(r2 N F mean_depvar, fmt(2 0 3 2) labels("R-squared" "Observations" "F-stat" "Mean Dependent Var")) ///
  cells(b(star fmt(3)) se(par fmt(2))) ///
  addnotes("Robust standard errors in parentheses")


  
*** Regression 3: log_income as dependent variable - 15 - 40

eststo clear

* drop if age > 40
* Defining results directory



forval i=16/40 {

	quietly summarize log_income if age == `i'
	local mean_`i' = round(r(mean), 0.01)
	quietly reg log_income birth_parish_treated female i.marital i.schooling i.hisclass_group_abb if age == `i', robust
	eststo Model_`i'
	estadd scalar mean_depvar = `mean_`i''

}

* Corrected esttab command to match the looped model names
esttab Model_16 Model_17 Model_18 Model_18 Model_19 Model_20 Model_21 Model_22 ///
	Model_23 Model_24 Model_25 Model_26 Model_27 Model_28 Model_29 Model_30 ///
	Model_31 Model_32 Model_33 Model_34 Model_35 Model_36 Model_37 Model_38 ///
	Model_39 Model_40 using "`results_dir'/log_income_regression_age_16_40.csv", label replace ///
  stats(r2 N F mean_depvar, fmt(2 0 3 2) labels("R-squared" "Observations" "F-stat" "Mean Dependent Var")) ///
  cells(b(star fmt(3)) se(par fmt(2))) ///
  addnotes("Robust standard errors in parentheses")


  
*** Regression 4: log_income as dependent variable. Checking if age makes any impact.

* Regression for log_income with birth_parish_treated only
quietly summarize log_income if birth_parish_treated == 0
local mean1 = round(r(mean), 0.01)
reg log_income birth_parish_treated, robust
eststo Model1
estadd scalar mean_depvar = `mean1'

* Adding age and age squared and female
quietly summarize log_income if birth_parish_treated == 0
local mean2 = round(r(mean), 0.01)
reg log_income birth_parish_treated female age age_2, robust
eststo Model2
estadd scalar mean_depvar = `mean2'

* Adding schooling
quietly summarize log_income if birth_parish_treated == 0
local mean3 = round(r(mean), 0.01)
reg log_income birth_parish_treated age age_2 female i.marital i.schooling i.hisclass_group_abb, robust
eststo Model3
estadd scalar mean_depvar = `mean3'


esttab Model1 Model2 Model3 using `results_dir'/log_income_regression_age_no_limits.tex, label replace ///
  stats(r2 N F mean_depvar, fmt(2 0 3 2) labels("R-squared" "Observations" "F-stat" "Mean Dependent Var")) ///
  cells(b(star fmt(3)) se(par fmt(2))) ///
  addnotes("Robust standard errors in parentheses")
