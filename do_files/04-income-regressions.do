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
esttab Model1 Model2 Model3 using $results_dir/04-log-income-regression.tex, label replace ///
  stats(r2 N F mean_depvar, fmt(2 0 3 2) labels("R-squared" "Observations" "F-stat" "Mean Dependent Var")) ///
  cells(b(star fmt(3)) se(par fmt(2))) ///
  addnotes("Clustered standard errors in parentheses")
  
  
  
*-------------------------------------------------------------*
* Quantile Regressions for log_income: Quantile regressions
*-------------------------------------------------------------*
eststo clear


forvalues i = 0.05(0.1) .95 {

	di `i'

	qreg2 log_income birth_parish_treated age ///
	age_2 female i.marital i.schooling i.hisclass, ///
	quantile(`i') cluster (birth_parish_ref_code)
	
	loc h = round(`i' * 100)
	
	di `h'
	
	eststo Model`h'
}


* Tabulate the regression results and save them in TeX format
esttab Model5 Model15 Model25 Model35 Model45 Model55 Model65 Model75 Model85 Model95 ///
	using $results_dir/0401-quantile_reg_log-income.tex, label replace ///
    stats(r2 N F mean_depvar, fmt(2 0 3 2) labels("R-squared" "Observations" "F-stat" "Mean Dependent Var")) ///
    cells(b(star fmt(3)) se(par fmt(5))) ///
    addnotes("Clustered standard errors in parentheses")

	
*-------------------------------------------------------------*
* Quantile Regressions for log_income: Quantile regressions sans controls
*-------------------------------------------------------------*
eststo clear


forvalues i = 0.05(0.1) .95 {

	di `i'

	qreg2 log_income birth_parish_treated, ///
	quantile(`i') cluster (birth_parish_ref_code)
	
	loc h = round(`i' * 100)
	
	di `h'
	
	eststo Model`h'
}


* Tabulate the regression results and save them in TeX format
esttab Model5 Model15 Model25 Model35 Model45 Model55 Model65 Model75 Model85 Model95 ///
	using $results_dir/0401-quantile_reg_log-income_no_controls.tex, label replace ///
    stats(r2 N F mean_depvar, fmt(2 0 3 2) labels("R-squared" "Observations" "F-stat" "Mean Dependent Var")) ///
    cells(b(star fmt(3)) se(par fmt(5))) ///
    addnotes("Clustered standard errors in parentheses")
	
	
	
*-------------------------------------------------------------*
* Quantile Regressions for log_income: Quantile regressions (unconditional)
*-------------------------------------------------------------*
eststo clear

global x age age_2 female i.marital i.schooling i.hisclass

rqr log_income birth_parish_treated, quantile(.15(.1).85) controls($x) 

bootstrap, reps(10): rqr log_income birth_parish_treated, quantile(.15(.1).85) controls($x) 

rqrplot




*-------------------------------------------------------------*
* Prep union density 
*-------------------------------------------------------------*

 foreach var of varlist union_density_1900-union_density_1930 {
 
                 replace `var'=0.01 if `var'==.

         }


gen log_union_density_1900 = ln(union_density_1900*100)
gen log_union_density_1910 = ln(union_density_1910*100)
gen log_union_density_1930 = ln(union_density_1930*100)


*-------------------------------------------------------------*
* Quantile Regressions for log_income: 1900 union density 
*-------------------------------------------------------------*
eststo clear

forvalues i = 0.05(0.1) .95 {

	di `i'

	qreg2 log_income birth_parish_treated##c.log_union_density_1900 age ///
	age_2 female i.marital i.schooling i.hisclass, ///
	quantile(`i') cluster (birth_parish_ref_code)
	
	loc h = round(`i' * 100)
	
	di `h'
	
	eststo Model`h'
}
	
* Tabulate the regression results and save them in TeX format
esttab Model5 Model15 Model25 Model35 Model45 Model55 Model65 Model75 Model85 Model95 ///
	using $results_dir/0402-quantile_reg_1900_union_density_log-income.tex, label replace ///
    stats(r2 N F mean_depvar, fmt(2 0 3 2) labels("R-squared" "Observations" "F-stat" "Mean Dependent Var")) ///
    cells(b(star fmt(3)) se(par fmt(5))) ///
    addnotes("Clustered standard errors in parentheses")


*-------------------------------------------------------------*
* Quantile Regressions for log_income: 1910 union density
*-------------------------------------------------------------*
eststo clear

forvalues i = 0.05(0.1) .95 {

	di `i'

	qreg2 log_income birth_parish_treated##c.log_union_density_1910 age ///
	age_2 female i.marital i.schooling i.hisclass, ///
	quantile(`i') cluster (birth_parish_ref_code)
	
	loc h = round(`i' * 100)
	
	di `h'
	
	eststo Model`h'
}
	
* Tabulate the regression results and save them in TeX format
esttab Model5 Model15 Model25 Model35 Model45 Model55 Model65 Model75 Model85 Model95 ///
	using $results_dir/0403-quantile_reg_1910_union_density_log-income.tex, label replace ///
    stats(r2 N F mean_depvar, fmt(2 0 3 2) labels("R-squared" "Observations" "F-stat" "Mean Dependent Var")) ///
    cells(b(star fmt(3)) se(par fmt(5))) ///
    addnotes("Clustered standard errors in parentheses")


	
*-------------------------------------------------------------*
* Quantile Regressions for log_income: 1930 union density
*-------------------------------------------------------------*
eststo clear

forvalues i = 0.05(0.1) .95 {

	di `i'

	qreg2 log_income birth_parish_treated##c.log_union_density_1930 age ///
	age_2 female i.marital i.schooling i.hisclass, ///
	quantile(`i') cluster (birth_parish_ref_code)
	
	loc h = round(`i' * 100)
	
	di `h'
	
	eststo Model`h'
}
	
* Tabulate the regression results and save them in TeX format
esttab Model5 Model15 Model25 Model35 Model45 Model55 Model65 Model75 Model85 Model95 ///
	using $results_dir/0404-quantile_reg_1930_union_density_log-income.tex, label replace ///
    stats(r2 N F mean_depvar, fmt(2 0 3 2) labels("R-squared" "Observations" "F-stat" "Mean Dependent Var")) ///
    cells(b(star fmt(3)) se(par fmt(5))) ///
    addnotes("Clustered standard errors in parentheses")


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








*-------------------------------------------------------------*
* Linear Regressions for log_income: new union density interaction
*-------------------------------------------------------------*
* do this at the top or here, not both

 foreach var of varlist union_density_1900-union_density_1930 {
 
                 replace `var'=0.01 if `var'==.

         }


gen log_union_density_1900 = ln(union_density_1900*100)
gen log_union_density_1910 = ln(union_density_1910*100)
gen log_union_density_1930 = ln(union_density_1930*100)


reg log_income birth_parish_treated##c.log_union_density_1900 age age_2 female i.marital i.schooling i.hisclass, vce(cluster birth_parish_ref_code)
eststo Model1


reg log_income birth_parish_treated##c.log_union_density_1910 age age_2 female i.marital i.schooling i.hisclass, vce(cluster birth_parish_ref_code)
eststo Model2

reg log_income birth_parish_treated##c.log_union_density_1930 age age_2 female i.marital i.schooling i.hisclass, vce(cluster birth_parish_ref_code)
eststo Model3

* Tabulate the regression results and save them in TeX format
esttab Model1 Model2 Model3 using $results_dir/0405-log-income-regression-with-union-density.tex, label replace ///
  stats(r2 N F, fmt(2 0 3) labels("R-squared" "Observations" "F-stat")) ///
  cells(b(star fmt(3)) se(par fmt(2))) ///
  addnotes("Clustered standard errors in parentheses")

  
  
  
  
  
  
  
   foreach var of varlist union_density_1900-union_density_1930 {
 
                 replace `var'=0 if `var'==.

         }


gen log_union_density_1900 = ln(union_density_1900*100)
gen log_union_density_1910 = ln(union_density_1910*100)
gen log_union_density_1930 = ln(union_density_1930*100)
  
  
reg log_income birth_parish_treated##c.union_density_1900 age age_2 female i.marital i.schooling i.hisclass, vce(cluster birth_parish_ref_code)
eststo Model1


reg log_income birth_parish_treated##c.union_density_1910 age age_2 female i.marital i.schooling i.hisclass, vce(cluster birth_parish_ref_code)
eststo Model2

reg log_income birth_parish_treated##c.union_density_1930 age age_2 female i.marital i.schooling i.hisclass, vce(cluster birth_parish_ref_code)
eststo Model3







*-------------------------------------------------------------*
* Prep union density 
*-------------------------------------------------------------*

 foreach var of varlist union_density_1900-union_density_1930 {
 
                 replace `var'=0.00 if `var'==.

         }

*-------------------------------------------------------------*
* Linear Regressions for log_income: standardized coefficients
*-------------------------------------------------------------*


tabulate marital, generate(marital_) // 5
tabulate schooling, generate(schooling_) // 4
tabulate hisclass, generate(hisclass_) // 7


 foreach var of varlist log_income birth_parish_treated age age_2 ///
 female ///
 marital_1 marital_2 marital_3 marital_4 marital_5 ///
 schooling_1 schooling_2 schooling_3 schooling_4 ///
 hisclass_1 hisclass_2 hisclass_3 hisclass_4 hisclass_5 hisclass_6 hisclass_7 ///
 union_density_1900 union_density_1910 union_density_1930 {
 	
   summ `var'
   egen float `var'_std = std(`var'), mean(0) std(1)
  
  }

reg log_income_std c.birth_parish_treated_std##c.union_density_1930_std age_std ///
	age_2_std female_std ///
	marital_2_std marital_3_std marital_4_std marital_5_std ///
	schooling_2_std schooling_3_std schooling_4_std ///
	hisclass_2_std hisclass_3_std hisclass_4_std ///
	hisclass_6_std hisclass_7_std ///
	, cluster(birth_parish_ref_code)


*-------------------------------------------------------------*
* Quantile Regressions for log_income: 1900 union density 
*-------------------------------------------------------------*
eststo clear

forvalues i = 0.05(0.1) .95 {

	di `i'

	qreg2 log_income_std birth_parish_treated##c.union_density_1900_std age_std ///
	age_2_std female_std ///
	marital_2_std marital_3_std marital_4_std marital_5_std ///
	schooling_2_std schooling_3_std schooling_4_std ///
	hisclass_2_std hisclass_3_std hisclass_4_std ///
	hisclass_6_std hisclass_7_std ///
	, quantile(`i') cluster (birth_parish_ref_code)
	
	loc h = round(`i' * 100)
	
	di `h'
	
	eststo Model`h'
}
	
* Tabulate the regression results and save them in TeX format
esttab Model5 Model15 Model25 Model35 Model45 Model55 Model65 Model75 Model85 Model95 ///
	using $results_dir/0404-quantile_reg_1900_union_density_log-income_std_correct.tex, label replace ///
    stats(r2 N F mean_depvar, fmt(2 0 3 2) labels("R-squared" "Observations" "F-stat" "Mean Dependent Var")) ///
    cells(b(star fmt(3)) se(par fmt(5))) ///
    addnotes("Clustered standard errors in parentheses")




*-------------------------------------------------------------*
* Quantile Regressions for log_income: 1910 union density
*-------------------------------------------------------------*
eststo clear

forvalues i = 0.05(0.1) .95 {

	di `i'

	qreg2 log_income_std birth_parish_treated##c.union_density_1910_std age_std ///
	age_2_std female_std ///
	marital_2_std marital_3_std marital_4_std marital_5_std ///
	schooling_2_std schooling_3_std schooling_4_std ///
	hisclass_2_std hisclass_3_std hisclass_4_std ///
	hisclass_6_std hisclass_7_std ///
	, quantile(`i') cluster (birth_parish_ref_code)
	
	loc h = round(`i' * 100)
	
	di `h'
	
	eststo Model`h'
}
	
* Tabulate the regression results and save them in TeX format
esttab Model5 Model15 Model25 Model35 Model45 Model55 Model65 Model75 Model85 Model95 ///
	using $results_dir/0403-quantile_reg_1910_union_density_log-income_std.tex, label replace ///
    stats(r2 N F mean_depvar, fmt(2 0 3 2) labels("R-squared" "Observations" "F-stat" "Mean Dependent Var")) ///
    cells(b(star fmt(3)) se(par fmt(5))) ///
    addnotes("Clustered standard errors in parentheses")


	
*-------------------------------------------------------------*
* Quantile Regressions for log_income: 1930 union density
*-------------------------------------------------------------*

eststo clear


forvalues i = 0.05(0.1) .95 {

	di `i'

	qreg2 log_income_std birth_parish_treated##c.union_density_1930_std age_std ///
	age_2_std female_std ///
	marital_2_std marital_3_std marital_4_std marital_5_std ///
	schooling_2_std schooling_3_std schooling_4_std ///
	hisclass_2_std hisclass_3_std hisclass_4_std ///
	hisclass_6_std hisclass_7_std ///
	, quantile(`i') cluster (birth_parish_ref_code)
	
	loc h = round(`i' * 100)
	
	di `h'
	
	eststo Model`h'
}
	
* Tabulate the regression results and save them in TeX format
esttab Model5 Model15 Model25 Model35 Model45 Model55 Model65 Model75 Model85 Model95 ///
	using $results_dir/0402-quantile_reg_1930_union_density_log-income_std.tex, label replace ///
    stats(r2 N F mean_depvar, fmt(2 0 3 2) labels("R-squared" "Observations" "F-stat" "Mean Dependent Var")) ///
    cells(b(star fmt(3)) se(par fmt(5))) ///
    addnotes("Clustered standard errors in parentheses")


	
	
	
	
*-------------------------------------------------------------*
* Quantile Regressions for log_income: 1900 union density testing standardization
*-------------------------------------------------------------*
eststo clear

forvalues i = 0.05(0.1) .95 {

	di `i'

	qreg2 log_income_std c.birth_parish_treated_std##c.union_density_1900_std age_std ///
	age_2_std female_std ///
	marital_2_std marital_3_std marital_4_std marital_5_std ///
	schooling_2_std schooling_3_std schooling_4_std ///
	hisclass_2_std hisclass_3_std hisclass_4_std ///
	hisclass_6_std hisclass_7_std ///
	, quantile(`i') cluster (birth_parish_ref_code)
	
	loc h = round(`i' * 100)
	
	di `h'
	
	eststo Model`h'
}
	
* Tabulate the regression results and save them in TeX format
esttab Model5 Model15 Model25 Model35 Model45 Model55 Model65 Model75 Model85 Model95 ///
	using $results_dir/0404-quantile_reg_1900_union_density_log-income_std_cts.tex, label replace ///
    stats(r2 N F mean_depvar, fmt(2 0 3 2) labels("R-squared" "Observations" "F-stat" "Mean Dependent Var")) ///
    cells(b(star fmt(3)) se(par fmt(5))) ///
    addnotes("Clustered standard errors in parentheses")





	
		
*-------------------------------------------------------------*
* Quantile Regressions for log_income: 1910 union density testing standardization
*-------------------------------------------------------------*
eststo clear

forvalues i = 0.05(0.1) .95 {

	di `i'

	qreg2 log_income_std c.birth_parish_treated_std##c.union_density_1910_std age_std ///
	age_2_std female_std ///
	marital_2_std marital_3_std marital_4_std marital_5_std ///
	schooling_2_std schooling_3_std schooling_4_std ///
	hisclass_2_std hisclass_3_std hisclass_4_std ///
	hisclass_6_std hisclass_7_std ///
	, quantile(`i') cluster (birth_parish_ref_code)
	
	loc h = round(`i' * 100)
	
	di `h'
	
	eststo Model`h'
}
	
* Tabulate the regression results and save them in TeX format
esttab Model5 Model15 Model25 Model35 Model45 Model55 Model65 Model75 Model85 Model95 ///
	using $results_dir/0404-quantile_reg_1910_union_density_log-income_std_cts.tex, label replace ///
    stats(r2 N F mean_depvar, fmt(2 0 3 2) labels("R-squared" "Observations" "F-stat" "Mean Dependent Var")) ///
    cells(b(star fmt(3)) se(par fmt(5))) ///
    addnotes("Clustered standard errors in parentheses")




	
		
*-------------------------------------------------------------*
* Quantile Regressions for log_income: 1930 union density testing standardization
*-------------------------------------------------------------*
eststo clear

forvalues i = 0.05(0.1) .95 {

	di `i'

	qreg2 log_income_std c.birth_parish_treated_std##c.union_density_1930_std age_std ///
	age_2_std female_std ///
	marital_2_std marital_3_std marital_4_std marital_5_std ///
	schooling_2_std schooling_3_std schooling_4_std ///
	hisclass_2_std hisclass_3_std hisclass_4_std ///
	hisclass_6_std hisclass_7_std ///
	, quantile(`i') cluster (birth_parish_ref_code)
	
	loc h = round(`i' * 100)
	
	di `h'
	
	eststo Model`h'
}
	
* Tabulate the regression results and save them in TeX format
esttab Model5 Model15 Model25 Model35 Model45 Model55 Model65 Model75 Model85 Model95 ///
	using $results_dir/0404-quantile_reg_1930_union_density_log-income_std_cts.tex, label replace ///
    stats(r2 N F mean_depvar, fmt(2 0 3 2) labels("R-squared" "Observations" "F-stat" "Mean Dependent Var")) ///
    cells(b(star fmt(3)) se(par fmt(5))) ///
    addnotes("Clustered standard errors in parentheses")




