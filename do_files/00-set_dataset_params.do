*---------------------------------------------------*
* Stata Dofile: Data Preparation for Paper-3-Analysis*
*---------------------------------------------------*

clear all
set more off 

* Setting the working directory
* cd "C:\Users\User\Documents\Recon\paper-3-analysis"

cd "/Users/jonathanjayes/Documents/PhD/paper-3-analysis/"

*---------------------------------------------------*
* Initial Data Import
*---------------------------------------------------*

* Load the dataset for the 1930 census
use "data/census/1930_census_regression_dataset.dta"

*-----* Stata Dofile: Data Preparation for Paper-3-Analysis*
*---------------------------------------------------*

clear all
set more off 

* Setting the working directory
* cd "C:\Users\User\Documents\Recon\paper-3-analysis"

cd "/Users/jonathanjayes/Documents/PhD/paper-3-analysis/"

*---------------------------------------------------*
* Initial Data Import
*---------------------------------------------------*

* Load the dataset for the 1930 census
use "data/census/1930_census_regression_dataset.dta"

*---------------------------------------------------*
* Encoding and Variable Creation
*---------------------------------------------------*

* Encoding the abbreviated schooling and marital status variables
egen schooling = group(schooling_abb), label
egen marital = group(marital_status), label

* Drop the original abbreviated columns as they are no longer needed
drop schooling_abb
drop marital_status

*---------------------------------------------------*
* Parameter and Label Settings
*---------------------------------------------------*

* Set local parameters for data trimming
local distance_cutoff = 250
local age_low = 15
local age_high = 100

* Assign labels to variables for clarity in tables and models
label var id "ID"
label var log_income "Log Income"
label var log_wealth "Log Wealth"
label var employed "Has occupation"
label var occ_title_without_income "Has occupational title but no income"
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


*---------------------------------------------------*
* Data Cleaning and Trimming
*---------------------------------------------------*

* Drop observations based on distance and age parameters
drop if birth_parish_distance_to_line > `distance_cutoff'
drop if `age_low' > age | `age_high' < age

* List all variables in the dataset
ds

* Store a list of variables excluding certain ones
local varlist = r(varlist)
local varlist: subinstr local varlist "log_wealth" "", all
local varlist: subinstr local varlist "hisclass_group_abb" "", all
local varlist: subinstr local varlist "log_income" "", all
local varlist: subinstr local varlist "occ_title_without_income" "", all

* Create an indicator for any missing value across all variables
egen anymissing = rmiss(`varlist')

* Drop observations with any missing value
drop if anymissing != 0

* Remove the temporary missing indicator variable
drop anymissing

*---------------------------------------------------*
* Final Data Save
*---------------------------------------------------*

* Save the cleaned dataset with parameters set
save "C:\Users\User\Documents\Recon\paper-3-analysis\data\census\1930_census_regression_dataset_params_set.dta", replace

