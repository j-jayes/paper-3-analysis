*** Inclusion test

clear all
set more off

cd "/Users/jonathanjayes/Documents/PhD/paper-3-analysis/"


* Import data
use "/Users/jonathanjayes/Documents/PhD/paper-3-analysis/data/balance-tests/included_1930.dta"

gen log_llabforce = .
replace log_llabforce = log(1 + llabforce)

* Define the results directory for storing output
global results_dir "results/regressions/"

label var shc1 "Elite (\%) 1900"
label var shc2 "White collar (\%) 1900"
label var shc3 "Foremen (\%) 1900"
label var shc4 "Medium skilled (\%) 1900"
label var shc5 "Farmers (\%) 1900"
label var shc6 "Lower skilled (\%) 1900"
label var shc7 "Unskilled (\%) 1900"
label var log_llabforce "Log (1 + Labour Force) 1900"
label var included_1930 "Parish included in 1930 census"



reg included_1930 shc2 shc3 shc4 shc5 shc6 shc7 log_llabforce, robust
eststo Model1

esttab Model1 using $results_dir/014-1930-inclusion-regression.tex, label replace ///
	cells(b(star fmt(3)) se(par fmt(2))) ///
	addnotes("Robust standard errors in parentheses")
  
