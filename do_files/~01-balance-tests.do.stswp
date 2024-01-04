clear all
set more off

/* Insert your own pathname here */
* cd "[path]/replication/"
cd "/Users/jonathanjayes/Documents/PhD/paper-3-analysis/"

/////////////////////////////////////////
/////// Variable definitions

** parish_name
* name of parish

** parish_code 
* numerical identifier of parish

** treated
* dummy variable denoting parishes that were connected to the western line electricity grid


** labforce
* number of individuals in labor force

** shc1-shc7
* variables measuring the share (in percent) of the labor force beloning to each of the following classes:
* 1. Elite
* 2. White collar
* 3. Foremen
* 4. Medium skilled
* 5. Farmers
* 6. Lower-skilled
* 7. Unskilled

////////////////////////////////////////////////////////////////////////////////
/////// Table: Differences Between Connected and Unconnected Parishes Prior to Access to the Grid 1890

clear all
cd "/Users/jonathanjayes/Documents/PhD/paper-3-analysis/"
import excel "data/balance-tests/filtered_data_with_distances_balanced.xlsx", sheet("Sheet1") firstrow


drop if year != 1890

* create table with the mean and standard deviation of each variable by later access to the grid
tabstat llabforce shc1 shc2 shc3 shc4 shc5 shc6 shc7, by(treated) format(%5.0g) stat(mean sd)

* test for difference-in-means 
foreach var of varlist llabforce shc1 shc2 shc3 shc4 shc5 shc6 shc7 {
ttest `var', by(treated)
}

/////////////////////////////////////////
/////// Table: Differences Between Connected and Unconnected Parishes Prior to Access to the Grid 1900

clear all
cd "/Users/jonathanjayes/Documents/PhD/paper-3-analysis/"
import excel "data/balance-tests/filtered_data_with_distances_balanced.xlsx", sheet("Sheet1") firstrow


drop if year != 1900

* create table with the mean and standard deviation of each variable by later access to the grid
tabstat llabforce shc1 shc2 shc3 shc4 shc5 shc6 shc7, by(treated) format(%5.0g) stat(mean sd)

* test for difference-in-means 
foreach var of varlist llabforce shc1 shc2 shc3 shc4 shc5 shc6 shc7 {
ttest `var', by(treated)
}


////////////////////////////////////////////////////////////////////////////////
/////// Table: Differences Between Connected and Unconnected Parishes Prior to Access to the Grid 1890
/////// Entire sample not balanbed sample

clear all
cd "/Users/jonathanjayes/Documents/PhD/paper-3-analysis/"
import excel "data/balance-tests/filtered_data_with_distances.xlsx", sheet("Sheet1") firstrow


drop if year != 1890

* create table with the mean and standard deviation of each variable by later access to the grid
tabstat llabforce shc1 shc2 shc3 shc4 shc5 shc6 shc7, by(treated) format(%5.0g) stat(mean sd)

* test for difference-in-means 
foreach var of varlist llabforce shc1 shc2 shc3 shc4 shc5 shc6 shc7 {
ttest `var', by(treated)
}

/////////////////////////////////////////
/////// Table: Differences Between Connected and Unconnected Parishes Prior to Access to the Grid 1900
/////// Entire sample not balanbed sample

clear all
cd "/Users/jonathanjayes/Documents/PhD/paper-3-analysis/"
import excel "data/balance-tests/filtered_data_with_distances.xlsx", sheet("Sheet1") firstrow


drop if year != 1900

* create table with the mean and standard deviation of each variable by later access to the grid
tabstat llabforce shc1 shc2 shc3 shc4 shc5 shc6 shc7, by(treated) format(%5.0g) stat(mean sd)

* test for difference-in-means 
foreach var of varlist llabforce shc1 shc2 shc3 shc4 shc5 shc6 shc7 {
ttest `var', by(treated)
}

