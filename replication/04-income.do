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

*-------------------------------------------------------------*
* Linear Regressions for log_income: Main Specification 
*-------------------------------------------------------------*

* Model 1: Regression with log_income as DV, birth_parish_treated as IV
reg log_income birth_parish_treated, vce(cluster birth_parish_ref_code)


* Model 2: Extending Model 1 by adding age, age squared, and female
reg log_income birth_parish_treated age age_2 female, vce(cluster birth_parish_ref_code)

* Model 3: Extending Model 2 by adding marital status, schooling, and hisclass
reg log_income birth_parish_treated age age_2 female i.marital i.schooling i.hisclass, vce(cluster birth_parish_ref_code)
  
*-------------------------------------------------------------*
* Quantile Regressions for log_income: Quantile regressions
*-------------------------------------------------------------*


forvalues i = 0.05(0.1) .95 {

	qreg2 log_income birth_parish_treated age ///
	age_2 female i.marital i.schooling i.hisclass, ///
	quantile(`i') cluster (birth_parish_ref_code)
	
	loc h = round(`i' * 100)
	
	di `h'
}
	
	
	
*-------------------------------------------------------------*
* Quantile Regressions for log_income: Quantile regressions (unconditional)
*-------------------------------------------------------------*

global x age age_2 female i.marital i.schooling i.hisclass

rqr log_income birth_parish_treated, quantile(.15(.1).85) controls($x) 

rqrplot
  

*-------------------------------------------------------------*
* Quantile Regressions for log_income: 1900 union density 
*-------------------------------------------------------------*

forvalues i = 0.05(0.1) .95 {


	qreg2 log_income birth_parish_treated##c.popular_movement_density_1900_FA age ///
	age_2 female i.marital i.schooling i.hisclass, ///
	quantile(`i') cluster (birth_parish_ref_code)
	
	loc h = round(`i' * 100)
	
	di `h'
	
}


*-------------------------------------------------------------*
* Quantile Regressions for log_income: 1910 union density
*-------------------------------------------------------------*

forvalues i = 0.05(0.1) .95 {

	qreg2 log_income birth_parish_treated##c.popular_movement_density_1910_FA age ///
	age_2 female i.marital i.schooling i.hisclass, ///
	quantile(`i') cluster (birth_parish_ref_code)
	
	loc h = round(`i' * 100)
	
	di `h'
	
}
	

*-------------------------------------------------------------*
* Quantile Regressions for log_income: 1930 union density
*-------------------------------------------------------------*

forvalues i = 0.05(0.1) .95 {

	qreg2 log_income birth_parish_treated##c.popular_movement_density_1930_FA age ///
	age_2 female i.marital i.schooling i.hisclass, ///
	quantile(`i') cluster (birth_parish_ref_code)
	
	loc h = round(`i' * 100)
	
	di `h'
	
}
	
