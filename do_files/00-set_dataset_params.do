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

gen current_parish_ref_code_num = current_parish_ref_code
replace current_parish_ref_code_num = subinstr(current_parish_ref_code_num, "SE/0", "", .)
replace current_parish_ref_code_num = subinstr(current_parish_ref_code_num, "SE/", "", .)

gen current_parish_ref_code_num_real = real(current_parish_ref_code_num)

* Drop rows where "current_parish_ref_code_num_real" is equal to 11506000
drop if current_parish_ref_code_num_real == 11506000

* Drop rows where "current_parish_ref_code_num_real" is equal to 11704000
drop if current_parish_ref_code_num_real == 11704000

* Drop rows where "current_parish_ref_code_num_real" is equal to 12004000
drop if current_parish_ref_code_num_real == 12004000

* Drop rows where "current_parish_ref_code_num_real" is equal to 12005000
drop if current_parish_ref_code_num_real == 12005000

* Drop rows where "current_parish_ref_code_num_real" is equal to 12501000
drop if current_parish_ref_code_num_real == 12501000

* Drop rows where "current_parish_ref_code_num_real" is equal to 12502000
drop if current_parish_ref_code_num_real == 12502000

* Drop rows where "current_parish_ref_code_num_real" is equal to 12504000
drop if current_parish_ref_code_num_real == 12504000

* Drop rows where "current_parish_ref_code_num_real" is equal to 12505000
drop if current_parish_ref_code_num_real == 12505000

* Drop rows where "current_parish_ref_code_num_real" is equal to 12506000
drop if current_parish_ref_code_num_real == 12506000

* Drop rows where "current_parish_ref_code_num_real" is equal to 12507000
drop if current_parish_ref_code_num_real == 12507000

* Drop rows where "current_parish_ref_code_num_real" is equal to 12508000
drop if current_parish_ref_code_num_real == 12508000

* Drop rows where "current_parish_ref_code_num_real" is equal to 12701000
drop if current_parish_ref_code_num_real == 12701000

* Drop rows where "current_parish_ref_code_num_real" is equal to 12801000
drop if current_parish_ref_code_num_real == 12801000

* Drop rows where "current_parish_ref_code_num_real" is equal to 13601000
drop if current_parish_ref_code_num_real == 13601000

* Drop rows where "current_parish_ref_code_num_real" is equal to 13603000
drop if current_parish_ref_code_num_real == 13603000

* Drop rows where "current_parish_ref_code_num_real" is equal to 13604000
drop if current_parish_ref_code_num_real == 13604000

* Drop rows where "current_parish_ref_code_num_real" is equal to 13605000
drop if current_parish_ref_code_num_real == 13605000

* Drop rows where "current_parish_ref_code_num_real" is equal to 13606000
drop if current_parish_ref_code_num_real == 13606000

* Drop rows where "current_parish_ref_code_num_real" is equal to 13607000
drop if current_parish_ref_code_num_real == 13607000

* Drop rows where "current_parish_ref_code_num_real" is equal to 13801000
drop if current_parish_ref_code_num_real == 13801000

* Drop rows where "current_parish_ref_code_num_real" is equal to 13901000
drop if current_parish_ref_code_num_real == 13901000

* Drop rows where "current_parish_ref_code_num_real" is equal to 13902000
drop if current_parish_ref_code_num_real == 13902000

* Drop rows where "current_parish_ref_code_num_real" is equal to 13903000
drop if current_parish_ref_code_num_real == 13903000

* Drop rows where "current_parish_ref_code_num_real" is equal to 13904000
drop if current_parish_ref_code_num_real == 13904000

* Drop rows where "current_parish_ref_code_num_real" is equal to 13905000
drop if current_parish_ref_code_num_real == 13905000

* Drop rows where "current_parish_ref_code_num_real" is equal to 13906000
drop if current_parish_ref_code_num_real == 13906000

* Drop rows where "current_parish_ref_code_num_real" is equal to 16201000
drop if current_parish_ref_code_num_real == 16201000

* Drop rows where "current_parish_ref_code_num_real" is equal to 18001000
drop if current_parish_ref_code_num_real == 18001000

* Drop rows where "current_parish_ref_code_num_real" is equal to 18103000
drop if current_parish_ref_code_num_real == 18103000

* Drop rows where "current_parish_ref_code_num_real" is equal to 18105000
drop if current_parish_ref_code_num_real == 18105000

* Drop rows where "current_parish_ref_code_num_real" is equal to 18106000
drop if current_parish_ref_code_num_real == 18106000

* Drop rows where "current_parish_ref_code_num_real" is equal to 18107000
drop if current_parish_ref_code_num_real == 18107000

* Drop rows where "current_parish_ref_code_num_real" is equal to 18108000
drop if current_parish_ref_code_num_real == 18108000

* Drop rows where "current_parish_ref_code_num_real" is equal to 18201000
drop if current_parish_ref_code_num_real == 18201000

* Drop rows where "current_parish_ref_code_num_real" is equal to 18803000
drop if current_parish_ref_code_num_real == 18803000

* Drop rows where "current_parish_ref_code_num_real" is equal to 18804000
drop if current_parish_ref_code_num_real == 18804000

* Drop rows where "current_parish_ref_code_num_real" is equal to 18805000
drop if current_parish_ref_code_num_real == 18805000

* Drop rows where "current_parish_ref_code_num_real" is equal to 18806000
drop if current_parish_ref_code_num_real == 18806000

* Drop rows where "current_parish_ref_code_num_real" is equal to 18808000
drop if current_parish_ref_code_num_real == 18808000

* Drop rows where "current_parish_ref_code_num_real" is equal to 18810000
drop if current_parish_ref_code_num_real == 18810000


*---------------------------------------------------*
* Encoding and Variable Creation
*---------------------------------------------------*

* Encoding the abbreviated schooling and marital status variables
egen schooling = group(schooling_abb), label
egen marital = group(marital_status), label
egen hisclass = group(hisclass_group_abb), label

* Drop the original abbreviated columns as they are no longer needed
drop schooling_abb
drop marital_status
drop hisclass_group_abb

*---------------------------------------------------*
* Parameter and Label Settings
*---------------------------------------------------*

* Set local parameters for data trimming
local distance_cutoff = 300
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
label var hisclass "Hisclass Group Abbreviation"
label var schooling "Schooling Abbreviation"
label var birth_parish_treated "Birth Parish (Treated)"
label var current_parish_treated "Current Parish (Treated)"
label var birth_parish_distance_to_line "Birth Parish Distance to Line"
label var current_parish_distance_to_line "Current Parish Distance to Line"
label var birth_parish_touching_treated "Birth Parish Touching Treated"
label var current_parish_touching_treated "Current Parish Touching Treated"
label var dist_bp_to_cp_km "Distance from birth parish to current parish"



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
local varlist: subinstr local varlist "hisclass" "", all
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
* save "C:\Users\User\Documents\Recon\paper-3-analysis\data\census\1930_census_regression_dataset_params_set.dta", replace
save "/Users/jonathanjayes/Documents/PhD/paper-3-analysis/data/census/1930_census_regression_dataset_params_set.dta", replace

