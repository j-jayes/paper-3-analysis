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

* Model 3: Extending Model 2 by adding marital status, schooling, and hisclass
quietly summarize log_income
local mean3 = round(r(mean), 0.01)
reg log_income birth_parish_treated age age_2 female i.marital i.schooling i.hisclass, vce(cluster birth_parish_ref_code)
eststo Model3
estadd scalar mean_depvar = `mean3'

* Tabulate the regression results and save them in TeX format
esttab Model1 Model2 Model3 using `results_dir'/04-log-income-regression.tex, label replace ///
  stats(r2 N F mean_depvar, fmt(2 0 3 2) labels("R-squared" "Observations" "F-stat" "Mean Dependent Var")) ///
  cells(b(star fmt(3)) se(par fmt(2))) ///
  addnotes("Robust standard errors in parentheses")
  
  
  
*-------------------------------------------------------------*
* Quantile Regressions for log_income: Quantile regressions
*-------------------------------------------------------------*
eststo clear


forvalues i = 0.1(0.1)0.9 {

	di `i'

	qreg2 log_income birth_parish_treated age ///
	age_2 female i.marital i.schooling i.hisclass, ///
	quantile(`i') cluster (birth_parish_ref_code)
	
	loc h = `i' * 10
	
	eststo Model`h'
}

qreg2 log_income birth_parish_treated age ///
age_2 female i.marital i.schooling i.hisclass, ///
quantile(.8) cluster (birth_parish_ref_code)
	
eststo Model8

qreg2 log_income birth_parish_treated age ///
age_2 female i.marital i.schooling i.hisclass, ///
quantile(.9) cluster (birth_parish_ref_code)
	
eststo Model9


* Tabulate the regression results and save them in TeX format
esttab Model1 Model2 Model3 Model4 Model5 Model6 Model7 Model8 Model9 ///
	using 0401-quantile_reg_log-income.tex, label replace ///
    stats(r2 N F mean_depvar, fmt(2 0 3 2) labels("R-squared" "Observations" "F-stat" "Mean Dependent Var")) ///
    cells(b(star fmt(3)) se(par fmt(5))) ///
    addnotes("Robust standard errors in parentheses")
  
*-------------------------------------------------------------*
* Quantile Regressions for log_income: Main Specification 
*-------------------------------------------------------------*
eststo clear
local results_dir "results/regressions/"


forvalues i = 0.1(0.1)0.7 {

	di `i'

	qreg2 log_income birth_parish_treated##c.popular_movement_density_1910_FA age ///
	age_2 female i.marital i.schooling i.hisclass, ///
	quantile(`i') cluster (birth_parish_ref_code)
	
	loc h = `i' * 10
	
	eststo Model`h'
}

qreg2 log_income birth_parish_treated##c.popular_movement_density_1900_FA age ///
age_2 female i.marital i.schooling i.hisclass, ///
quantile(.8) cluster (birth_parish_ref_code)
	
eststo Model8

qreg2 log_income birth_parish_treated##c.popular_movement_density_1900_FA age ///
age_2 female i.marital i.schooling i.hisclass, ///
quantile(.9) cluster (birth_parish_ref_code)
	
eststo Model9


* Tabulate the regression results and save them in TeX format
esttab Model1 Model2 Model3 Model4 Model5 Model6 Model7 Model8 Model9 ///
	using 0402-quantile_reg_1900_union_density_log-income.tex, label replace ///
    stats(r2 N F mean_depvar, fmt(2 0 3 2) labels("R-squared" "Observations" "F-stat" "Mean Dependent Var")) ///
    cells(b(star fmt(3)) se(par fmt(5))) ///
    addnotes("Robust standard errors in parentheses")

*-------------------------------------------------------------*
* Quantile Regressions for log_income: 1930 union density
*-------------------------------------------------------------*
eststo clear

forvalues i = 0.1(0.1)0.7 {

	di `i'

	qreg2 log_income birth_parish_treated##c.popular_movement_density_1930_FA age ///
	age_2 female i.marital i.schooling i.hisclass, ///
	quantile(`i') cluster (birth_parish_ref_code)
	
	loc h = `i' * 10
	
	eststo Model`h'
}

qreg2 log_income birth_parish_treated##c.popular_movement_density_1930_FA age ///
age_2 female i.marital i.schooling i.hisclass, ///
quantile(.8) cluster (birth_parish_ref_code)
	
eststo Model8

qreg2 log_income birth_parish_treated##c.popular_movement_density_1930_FA age ///
age_2 female i.marital i.schooling i.hisclass, ///
quantile(.9) cluster (birth_parish_ref_code)
	
eststo Model9


* Tabulate the regression results and save them in TeX format
esttab Model1 Model2 Model3 Model4 Model5 Model6 Model7 Model8 Model9 ///
	using 0403-quantile_reg_1930_union_density_log-income.tex, label replace ///
    stats(r2 N F mean_depvar, fmt(2 0 3 2) labels("R-squared" "Observations" "F-stat" "Mean Dependent Var")) ///
    cells(b(star fmt(3)) se(par fmt(5))) ///
    addnotes("Robust standard errors in parentheses")

	
*-------------------------------------------------------------*
* Quantile Regressions for log_income: 1910 union density
*-------------------------------------------------------------*
eststo clear

local results_dir "results/regressions/"


forvalues i = 0.1(0.1)0.7 {

	di `i'

	qreg2 log_income birth_parish_treated##c.popular_movement_density_1910_FA age ///
	age_2 female i.marital i.schooling i.hisclass, ///
	quantile(`i') cluster (birth_parish_ref_code)
	
	loc h = `i' * 10
	
	eststo Model`h'
}

qreg2 log_income birth_parish_treated##c.popular_movement_density_1910_FA age ///
age_2 female i.marital i.schooling i.hisclass, ///
quantile(.8) cluster (birth_parish_ref_code)
	
eststo Model8

qreg2 log_income birth_parish_treated##c.popular_movement_density_1910_FA age ///
age_2 female i.marital i.schooling i.hisclass, ///
quantile(.9) cluster (birth_parish_ref_code)
	
eststo Model9


* Tabulate the regression results and save them in TeX format
esttab Model1 Model2 Model3 Model4 Model5 Model6 Model7 Model8 Model9 ///
	using 0404-quantile_reg_1910_union_density_log-income.tex, label replace ///
    stats(r2 N F mean_depvar, fmt(2 0 3 2) labels("R-squared" "Observations" "F-stat" "Mean Dependent Var")) ///
    cells(b(star fmt(3)) se(par fmt(5))) ///
    addnotes("Robust standard errors in parentheses")

* Model 1: Regression with log_income as DV, birth_parish_treated as IV
quietly summarize log_income
local mean1 = round(r(mean), 0.01)
sqreg log_income birth_parish_treated, vce(cluster birth_parish_ref_code) quantile(.25, .5, .75)
eststo Model1
estadd scalar mean_depvar = `mean1'

* Model 2: Extending Model 1 by adding age, age squared, and female
quietly summarize log_income
local mean2 = round(r(mean), 0.01)
reg log_income birth_parish_treated age age_2 female, vce(cluster birth_parish_ref_code)
eststo Model2
estadd scalar mean_depvar = `mean2'

* Model 3: Extending Model 2 by adding marital status, schooling, and hisclass
quietly summarize log_income
local mean3 = round(r(mean), 0.01)
reg log_income birth_parish_treated age age_2 female i.marital i.schooling i.hisclass, vce(cluster birth_parish_ref_code)
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

* Model 3: Extending Model 2 by adding marital status, schooling, and hisclass
quietly summarize log_income
local mean3 = round(r(mean), 0.01)
reg log_income birth_parish_treated##c.popular_movement_density_1900_FA age age_2 female i.marital i.schooling i.hisclass, vce(cluster birth_parish_ref_code)
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

* Model 3: Extending Model 2 by adding marital status, schooling, and hisclass
quietly summarize log_income
local mean3 = round(r(mean), 0.01)
reg log_income birth_parish_treated##c.popular_movement_density_1910_FA age age_2 female i.marital i.schooling i.hisclass, vce(cluster birth_parish_ref_code)
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

* Model 3: Extending Model 2 by adding marital status, schooling, and hisclass
quietly summarize log_income
local mean3 = round(r(mean), 0.01)
reg log_income birth_parish_treated##c.popular_movement_density_1900_NY age age_2 female i.marital i.schooling i.hisclass, vce(cluster birth_parish_ref_code)
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

* Model 3: Extending Model 2 by adding marital status, schooling, and hisclass
quietly summarize log_income
local mean3 = round(r(mean), 0.01)
reg log_income birth_parish_treated##c.popular_movement_density_1910_NY age age_2 female i.marital i.schooling i.hisclass, vce(cluster birth_parish_ref_code)
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

* Model 3: Extending Model 2 by adding marital status, schooling, and hisclass
quietly summarize log_income
local mean3 = round(r(mean), 0.01)
reg log_income birth_parish_treated##c.popular_movement_density_1900_PA age age_2 female i.marital i.schooling i.hisclass, vce(cluster birth_parish_ref_code)
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

* Model 3: Extending Model 2 by adding marital status, schooling, and hisclass
quietly summarize log_income
local mean3 = round(r(mean), 0.01)
reg log_income birth_parish_treated##c.popular_movement_density_1910_PA age age_2 female i.marital i.schooling i.hisclass, vce(cluster birth_parish_ref_code)
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

* Model 3: Extending Model 2 by adding marital status, schooling, and hisclass
quietly summarize log_income
local mean3 = round(r(mean), 0.01)
reg log_income birth_parish_treated##c.popular_movement_density_1900_FR age age_2 female i.marital i.schooling i.hisclass, vce(cluster birth_parish_ref_code)
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

* Model 3: Extending Model 2 by adding marital status, schooling, and hisclass
quietly summarize log_income
local mean3 = round(r(mean), 0.01)
reg log_income birth_parish_treated##c.popular_movement_density_1910_FR age age_2 female i.marital i.schooling i.hisclass, vce(cluster birth_parish_ref_code)
eststo Model3
estadd scalar mean_depvar = `mean3'

* Tabulate the regression results and save them in TeX format
esttab Model1 Model2 Model3 using `results_dir'/041_log-income-regression_interaction.tex, label replace ///
  stats(r2 N F mean_depvar, fmt(2 0 3 2) labels("R-squared" "Observations" "F-stat" "Mean Dependent Var")) ///
  cells(b(star fmt(3)) se(par fmt(2))) ///
  addnotes("Robust standard errors in parentheses")

  
*-------------------------------------------------------------*
* Linear Regressions for log_income: Interaction of hisclass with treatment?
*-------------------------------------------------------------*

reg log_income birth_parish_treated##b2.hisclass age age_2 female i.marital i.schooling, vce(cluster birth_parish_ref_code)
