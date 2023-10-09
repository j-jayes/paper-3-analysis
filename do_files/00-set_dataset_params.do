clear all
set more off 
cd "C:\Users\User\Documents\Recon\paper-3-analysis"
* read in data from 
use "data/census/1930_census_regression_dataset.dta"

*** encode vars

egen schooling = group(schooling_abb), label
egen marital = group(marital_status), label

drop schooling_abb
drop marital_status

*** gen vars for age and employed

gen age_2 = age^2

* Generate the "employed" variable based on "hisclass_group_abb"
gen employed = 0 if missing(hisclass_group_abb)
replace employed = 1 if employed == . 

* Label the "employed" variable
label variable employed "Has occupation"


*** set params

local distance_cutoff = 250
local age_low = 15
local age_high = 100

*** label vars

label var id "ID"
label var log_income "Log Income"
label var log_wealth "Log Wealth"
label var electricity_job_direct "Electricity in Job (Direct)"
label var electricity_job_indirect "Electricity in Job (Indirect)"
label var age "Age"
label var age_2 "Age Squared"
label var female "Female (1 = Yes 0 = No)"
label var marital "Marital Status"
label var hisclass_group_abb "Hisclass Group Abbreviation"
label var schooling "Schooling Abbreviation"
label var birth_parish_treated "Birth Parish (Treated)"
label var current_parish_treated "Current Parish (Treated)"
label var birth_parish_distance_to_line "Birth Parish Distance to Line"
label var current_parish_distance_to_line "Current Parish Distance to Line"
label var birth_parish_touching_treated "Birth Parish Touching Treated"
label var current_parish_touching_treated "Current Parish Touching Treated"

*** trim dataset

drop if birth_parish_distance_to_line > `distance_cutoff'
drop if `age_low' >= age
drop if `age_high' <= age


* Get a list of all variables in the dataset
ds

* Store the variable list, excluding log_wealth, hisclass_group_abb, and log_income
local varlist = r(varlist)
local varlist: subinstr local varlist "log_wealth" "", all
local varlist: subinstr local varlist "hisclass_group_abb" "", all
local varlist: subinstr local varlist "log_income" "", all

* Create a missing indicator for any variable
egen anymissing = rmiss(`varlist')

* Drop observations where anymissing is not 0 (indicating a missing value)
drop if anymissing != 0

* Drop the anymissing variable
drop anymissing

save "C:\Users\User\Documents\Recon\paper-3-analysis\data\census\1930_census_regression_dataset_params_set.dta", replace


