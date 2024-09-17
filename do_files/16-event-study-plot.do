* Set the environment
clear all
set more off 

* Setting the working directory
* cd "C:\Users\User\Documents\Recon\paper-3-analysis"
cd "/Users/jonathanjayes/Documents/PhD/paper-3-analysis/"

use "data/census/census_1880_1930_event_study.dta"


statsby  _b _se, by(year) saving(indirect_est_1, replace): regress electricity_job_indirect birth_parish_treated, vce(cluster birth_parish_ref_code)

statsby  _b _se, by(year) saving(indirect_est_2, replace): regress electricity_job_indirect birth_parish_treated age female , vce(cluster birth_parish_ref_code)

// statsby  _b _se, by(year) saving(indirect_est_3, replace): regress electricity_job_indirect birth_parish_treated age female i.birth_parish_ref_code, vce(cluster birth_parish_ref_code)



statsby  _b _se, by(year) saving(direct_est_1, replace): regress electricity_job_direct birth_parish_treated, vce(cluster birth_parish_ref_code)

statsby  _b _se, by(year) saving(direct_est_2, replace): regress electricity_job_direct birth_parish_treated age female , vce(cluster birth_parish_ref_code)

// statsby  _b _se, by(year) saving(direct_est_3, replace): regress electricity_job_direct birth_parish_treated age female i.birth_parish_ref_code, vce(cluster birth_parish_ref_code)
