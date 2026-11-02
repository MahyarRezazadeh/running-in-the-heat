
// Do file merges pollution and runner's data created by mahyar on october 4
// stores resuls in raw_data_oct4.dta
// Author:FA
// DAte: october 5

global root "C:\Users\mahya\OneDrive - Simon Fraser University (1sfu)\Desktop\Incorporating Cornel comments"

cd "$root"


use runner_sample.dta, clear


 
replace competition_day=start_date  if start_date==end_date  /*1 day compeittions had missing data on competition day*/

merge m:1 competition_id competition_day using weather_data_main.dta
drop if _merge==2 /*drop obs of using dataset*/
drop _merge

save "$root/raw_data_oct10", replace
/*
merge m:1 competition_id competition_day using pollution_data2_october4.dta
drop if _merge==2 /*drop obs of using dataset*/
drop _merge

/*
encode(discipline), gen(marathon_name)
encode(country), gen(country1)
drop country
rename country1 country
encode(Nationality), gen(Nationality1)
drop Nationality
rename Nationality1 Nationality
encode(race), gen(race1)
drop race
gen race_sex="male" if gender==4
replace race_sex="female" if gender==3
rename race1 race
*/

/*
replace competition_day = start_date + index
format competition_day %td

*/
save "$root/raw_data_new_pollution.dta", replace
*/
