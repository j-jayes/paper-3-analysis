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
global results_dir "results/regressions"

*--------------------------------------------------*
* Baseline										   *
*--------------------------------------------------*

reg log_income current_parish_treated age age_2 female i.marital i.schooling i.hisclass, vce(cluster birth_parish_ref_code)


* question we need to answer:
* how many people are born in early electrifying parishes and move to other early electrifying parishes
* we can choose between two instruments:
* born in early electrifying parishes 



*--------------------------------------------------*
* Manual 2SLS									   *
*--------------------------------------------------*

* first stage, we regress the endogenous variable on all of the instruements

reg current_parish_treated birth_parish_treated age age_2 female i.marital i.schooling i.hisclass, vce(cluster birth_parish_ref_code)

* save the predicted values

predict current_parish_treated_hat, xb

* run the second regression

reg log_income current_parish_treated_hat age age_2 female i.marital i.schooling i.hisclass, vce(cluster birth_parish_ref_code)


*--------------------------------------------------*
* 2SLS with ivregress (correct SEs)  			   *
*--------------------------------------------------*


ivregress 2sls log_income age age_2 female i.marital i.schooling i.hisclass (current_parish_treated = birth_parish_treated), vce(cluster birth_parish_ref_code)



*--------------------------------------------------*
* 'test' for endogeneity  						   *
*--------------------------------------------------*

* original regressions
reg log_income current_parish_treated age age_2 female i.marital i.schooling i.hisclass, vce(cluster birth_parish_ref_code)

* save residuals
predict e, residual

* add residuals from first stage as explanatory variable

reg log_income current_parish_treated age age_2 female i.marital i.schooling i.hisclass e, vce(cluster birth_parish_ref_code)


*--------------------------------------------------*
* 2SLS with ivreg2 								   *
*--------------------------------------------------*

ivreg2 log_income age age_2 female i.marital i.schooling i.hisclass (current_parish_treated = birth_parish_treated), cluster (birth_parish_ref_code) 

* optionally add first stage results:

ivreg2 log_income age age_2 female i.marital i.schooling i.hisclass (current_parish_treated = birth_parish_treated), cluster (birth_parish_ref_code) ffirst



* why do we underestimate the effect with OLS? Surely if people are moving in to benefit from higher returns 


*--------------------------------------------------*
* 2SLS with ivreg2 	without controls			   *
*--------------------------------------------------*

ivreg2 log_income (current_parish_treated = birth_parish_treated), cluster (birth_parish_ref_code) 

reg log_income birth_parish_treated, cluster (birth_parish_ref_code) 



*--------------------------------------------------*
* Export 2SLS with ivreg2 	
*--------------------------------------------------*

eststo iv_controls_stage_2: ivreg2 log_income age age_2 female i.marital i.schooling i.hisclass (current_parish_treated = birth_parish_treated), cluster (birth_parish_ref_code) 


eststo iv_controls_stage_1: reg current_parish_treated birth_parish_treated age age_2 female i.marital i.schooling i.hisclass, vce(cluster birth_parish_ref_code)

estadd scalar f round(e(F), 0.001)

eststo OLS_controls: reg log_income current_parish_treated age age_2 female i.marital i.schooling i.hisclass, vce(cluster birth_parish_ref_code)

estadd scalar f round(e(F), 0.001)

	
eststo iv_no_controls_stage_2: ivreg2 log_income (current_parish_treated = birth_parish_treated), cluster (birth_parish_ref_code) 


eststo iv_no_controls_stage_1: reg current_parish_treated birth_parish_treated, vce(cluster birth_parish_ref_code)

estadd scalar f round(e(F), 0.001)

eststo OLS_no_controls: reg log_income current_parish_treated, vce(cluster birth_parish_ref_code)

estadd scalar f round(e(F), 0.001)





* separate columns

#delimit ;

esttab OLS_no_controls OLS_controls iv_no_controls_stage_1 iv_controls_stage_1 iv_no_controls_stage_2 iv_controls_stage_2   using "$results_dir/12-IV-regression_with_OLS_rearranged.tex",
	replace
	label 
	se(3)
	b(4)
	
	title("Iv Regression" \label{columns})
	mgroups
	(
	"OLS" "First Stage" "2SLS", pattern(1 0 1 0 1 0)
		prefix(\multicolumn{@span}{c}{)
		suffix(})
		span
		erepeat(\cmidrule(lr){@span})
	)
	mtitles("Log Income" "Log Income" "Current Parish (Treated)"  "Current Parish (Treated)" "Log Income" "Log Income")

;

	
	
	
#delimit cr;



	keep(log_income current_parish_treated birth_parish_treated)

	coeflabels(
	log_income "Ln Income"
	current_parish_treated "Current parish treated"
	birth_parish_treated "Birth parish treated")
