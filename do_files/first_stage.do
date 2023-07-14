

clear all
set more off 
cd "C:\Users\User\Documents\Recon\paper-3-analysis"


* Define parameter options
local exclude_touching_options "True"
local outcome_var_options "num_power_stations amount_final"
local source_type_options "transmitted water"
local include_area_options "True"
local include_population_options "True False"
local distances "100 150 200 250"

* Loop over distances and other parameters
foreach distance in `distances' {
    foreach source_type in `source_type_options' {
        foreach outcome_var in `outcome_var_options' {
            foreach exclude_touching in `exclude_touching_options' {
                foreach include_area in `include_area_options' {
                    foreach include_population in `include_population_options' {

                        * Define the file name based on parameters
                        local file_name "data\stata\first_stage\distance_`distance'_source_`source_type'_outcome_`outcome_var'_exclude_touching_`exclude_touching'_area_`include_area'_population_`include_population'.dta"

						local file_name "data\stata\first_stage\distance_100_source_None_outcome_num_power_stations_exclude_touching_True_area_True_population_False.dta"
                        * Import the data
                        use `file_name', clear

                        * Run the regressions based on parameters
                        if "`include_area'" == "True" & "`include_population'" == "True" {
                            reg `outcome_var' treatment area_sqkm population_1930
                        }
                        else if "`include_area'" == "True" {
                            reg `outcome_var' treatment area_sqkm
                        }
                        else if "`include_population'" == "True" {
                            reg `outcome_var' treatment population_1930
                        }
                        else {
                            reg `outcome_var' treatment
                        }

                        * Output the regression results (replace this with your desired output format)
                        outreg2 using "results/`distance'`source_type'`outcome_var'`exclude_touching'`include_area'`include_population'.doc", replace
                    }
                }
            }
        }
    }
}
