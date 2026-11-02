/*******************************************************************************
	NAME:		Create variables
	GOALS:		-Creat variables for the next step estimations
				-
				
		
				
	DATE: 		2024-02-05
	Adjusted: Feb 27, data on Precipitation, Humidity, wind sped and air pressure are added
	Adjusted: April 22, code to obtain long0-erm pollution at country level from the citylevel data (FA)
	Adjusted: Sept 12, added data for macro variables of the runners' country of origins 
******************************************************************************/


 
*global root="C:\Users\mahya\Dropbox\26 running in the heat\Mahyar\0-replication package"
 global root="/Users/faragons/Dropbox/FARAGON/6. papers faragon/26 running in the heat/Mahyar/0-replication package"

cd "$root"

************************
*1 extract data from   addtional var hlp.xls
clear all
import excel "$root/supplementary/additional vars FA.xlsx", sheet("Sheet1") cellrange(A10:h362) firstrow clear
sort marathon_name
ren description description_1
drop if marathon_name==.
save "$root/temp/tmp_additional_vars.dta", replace

************************
*2. exttract data on 2023 level of pollution_0_days_before

import excel "$root/supplementary/mege_pollution_ioccode.xlsx", sheet("data") cellrange(A7:J141) firstrow clear
keep country C
ren country country_code
ren C pm25_in_2023
drop if country_code==""
save "$root/temp/tmp_merge_pollution_iocode.dta", replace


************************

*2  obtain ocuntry level measure sof lon-term pollution 

use "$root/supplementary/long-term pollutants, city-level.dta", clear 

 
 * Rename variables based on labels and remove dashes
ds v*, has(varlabel)
foreach var in `r(varlist)' {
    local label: variable label `var'
    local newlabel = subinstr("`label'", "-", "", .)
    if `"`newlabel'"' != "" {
        rename `var' `newlabel'
    }
}
 
//  * Generate new variable names with date and reshape
//  foreach var in pm25_* pm10_* o3_* co_* {
//     local newname = substr("`var'", strlen("`var'")-6, 7)
//     rename `var' `newname'
// }

* Reshape from wide to long
 reshape long  pm25_ pm10_ o3_ co_ t2mmean_, i(city2)  

 *rename variables
 ren _j yearmonth 
 ren *_ *
 gen year=int(yearmonth/100)
 
 *create country-averages period 2019-2023
 keep if year >=2019 & year <=2023
 keep if country!=""
 
 *take country-month average  90
 
 collapse (mean) pm25 pm10 o3 co t2mmean   , by(country)

 foreach x of varlist  pm25* pm10* o3* co* t2mmean* {
	ren `x' `x'_2019_2023
 }
 ren country country_code
 save "$root/temp/country_pollution_data.dta", replace


 
 ************************************************
 
*3. prepare final dataset (data_ready.dta)

*using themarch 2024 version
*use "$root/raw_data_mar2024.dta", clear
 *ren	marathon_name marathon_name_old
*merge m:1  marathon_name_old using "$root/temp/tmp_additional_vars.dta", keep(master match) 

 use "$root/raw_data.dta", clear

 *eliminate duplicates
 duplicates drop athlete_id  competition_id  second marathon_name  
 
{ 
merge m:1  marathon_name using "$root/temp/tmp_additional_vars.dta", keep(master match) 

gen year=year(start_date)
gen month=month(start_date)

gen speed = race_distance_meters/second
gen ln_speed=ln(speed)
  label var speed "Speed (m/second)"
    label var ln_speed "ln speed (m/second)"
/*
**generating wind speed
gen wind_speed=wind2 if wind2>0
replace wind_speed=-wind2 if wind2<0
replace wind_speed=0 if wind_speed==.
label variable wind_speed "Wind speed (m/s)"*/

/*Unit changes for pollutant data**********************/
drop O3
rename V north_wind
rename U east_wind
rename TPRECMAX precipitation
rename QV humidity
rename PS air_pressure
label variable air_pressure "Air pressure, pa"
*1-Converting CO to ppm measures
replace co_0_days_before=co_0_days_before*2.9*10^6
replace co_1_days_before=co_1_days_before*2.9*10^6
replace co_2_days_before=co_2_days_before*2.9*10^6
replace co_3_days_before=co_3_days_before*2.9*10^6
replace co_4_days_before=co_4_days_before*2.9*10^6
label variable co_0_days_before "CO ppm, 24-hr level"
label variable co_1_days_before "CO ppm, 24-hr level one day lag "
label variable co_2_days_before "CO ppm, 24-hr level two days lag"
label variable co_3_days_before "CO ppm, 24-hr level three days lag"
label variable co_4_days_before "CO ppm, 24-hr level four days lag"

*2-converting O3 to ppb measure


replace o3_0_days_before=(o3_0_days_before*2.69*10^6) 
replace o3_1_days_before=(o3_1_days_before*2.69*10^6)
replace o3_2_days_before=(o3_2_days_before*2.69*10^6)
replace o3_3_days_before=(o3_3_days_before*2.69*10^6)
replace o3_4_days_before=(o3_4_days_before*2.69*10^6)
replace o3_5_days_before=(o3_5_days_before*2.69*10^6)
label variable o3_0_days_before "O3 ppb, 24-hr level"
label variable o3_1_days_before "O3 ppb, 24-hr level one days lag"
label variable o3_2_days_before "O3 ppb, 24-hr level two days lag"
label variable o3_3_days_before "O3 ppb, 24-hr level three days lag"
label variable o3_4_days_before "O3 ppb, 24-hr level four days lag"
label variable o3_5_days_before "O3 ppb, 24-hr level five days lag" 




/* Polynomial variables******************/
****polynomial of CO and O3
gen co_quad=co_0_days_before^2 
gen co_cub=co_0_days_before^3
gen o3_quad=o3_0_days_before^2
gen o3_cub=o3_0_days_before^3 
label variable co_quad "CO quadratic"
label variable co_cub "CO cubic"
label variable o3_quad "O3 quadratic"
label variable o3_cub "O3 cubic"


***polynomial of age
gen age_2=age^2
label variable age_2 "Athlete's age (qaudratic)"



*polynomial of pm2.5

gen pm0=pollution_0_days_before
label variable pm0 "PM2.5 24-hr level"
gen pm0_2=pm0^2 
label variable pm0_2 "PM2.5 quadratic"
gen pm0_3=pm0^3
label variable pm0_3 "PM2.5 cubic"
gen pm0_4=pm0^4

gen pm1=pollution_1_days_before
gen pm1_2=pm0^2
gen pm1_3=pm0^3
gen pm1_4=pm0^4

*polynomial lf temp 0

gen temp0=temp_0_days_before
gen temp0_2=temp0^2
gen temp0_3=temp0^3

*interaction variables
label variable temp0 "Temperature"
gen o3_temp=o3_0_days_before*temp0
label variable o3_temp "O3‍‍*Temperature"
gen pm_temp=pm0*temp0
label variable pm_temp "PM2.5*Temperature"
gen co_temp=co_0_days_before*temp0
label variable co_temp "CO*Temperature"

*gen season
*1 fall 2 winter 3 spring 4 summer
gen season=.
replace season=1 if month>=10 & month<=12 & realLatitude>0
replace season=2 if month>=1 & month<=3 & realLatitude>0
replace season=3 if month>=4 & month<=6 & realLatitude>0
replace season=4 if month>=7 & month<=9 & realLatitude>0

replace season=3 if month>=10 & month<=12 & realLatitude<0
replace season=4 if month>=1 & month<=3 & realLatitude<0
replace season=1 if month>=4 & month<=6 & realLatitude<0
replace season=2 if month>=7 & month<=9 & realLatitude<0

preserve
	 **average temp by country
 	keep   if season==4
	keep country venue date temp_0_days_before
	 duplicates drop
	 ren temp_0_days_before mean_temp_summer
	 collapse (mean) mean_temp_summer, by(country)
	 save "$root/temp/mean_temp_summer.dta", replace
 restore 

*add lomg term pollution data from two sources

*using average 2019=2023, cities in IOC sample, aggregated at country level
decode country, generate(country_code)


cap drop _merge
merge m:1 country_code  using "$root/temp/country_pollution_data.dta",  keep(match master)
*using data grofrom IQAir website with annual PM25 in country in 2023
cap drop _merge
merge m:1 country_code  using "$root/temp/tmp_merge_pollution_iocode.dta",  keep(match master)

*using dmean temp n summer 9imferred from data0
cap drop _merge
merge m:1 country   using "$root/temp/mean_temp_summer.dta",  keep(match master)


cap drop _merge

*create 3 days averages

*PM and speed using 0, 1 and last 3 days average
egen pm13=rmean(pollution_1_days_before pollution_2_days_before pollution_3_days_before)
egen pm03=rmean(pollution_0_days_before pollution_1_days_before pollution_2_days_before pollution_3_days_before)

egen pm05=rmean(pollution_0_days_before pollution_1_days_before pollution_2_days_before pollution_3_days_before pollution_4_days_before pollution_5_days_before)

egen pm35=rmean(      pollution_3_days_before pollution_4_days_before pollution_5_days_before)

egen pm10_03=rmean(pm10 pm10_1_days_ago pm10_2_days_ago pm10_3_days_ago)

egen temp13=rmean(temp_1_days_before temp_2_days_before temp_3_days_before)
egen temp03=rmean(temp_0_days_before temp_1_days_before temp_2_days_before temp_3_days_before)

gen o3_0=o3_0_days_before
egen o3_13 =rmean(o3_1_days_before o3_2_days_before o3_3_days_before)
 egen o3_03 =rmean(o3_0_days_before o3_1_days_before o3_2_days_before o3_3_days_before)

 gen co_0=co_0_days_before
 
egen co_13 = rmean(co_1_days_before co_2_days_before co_3_days_before)
egen co_03 = rmean(co_0_days_before co_1_days_before co_2_days_before co_3_days_before)

foreach x of varlist pm? pm?? temp? temp?? co_? co_?? o3_? o3_??  {
	gen ln_`x'=ln(`x')
	
}

gen CO_0=co_0_days_before  
gen CO_03= co_03 


gen racetype=.
replace racetype=1 if race_type=="sprint"
replace racetype=2 if race_type=="middle"
replace racetype=3 if race_type=="long"

 



  
 
*create standarsize measure of performance as in sexton et al (JAERE 2022)

preserve
	import excel "$root/supplementary/world_records.xlsx", sheet("Sheet1") cellrange(A6:C14) firstrow clear
	save "$root/temp/tmp_worldrecords.dta", replace

restore


merge m:1 race_distance_meters using  "$root/temp/tmp_worldrecords.dta" , keep(match master)
drop _merge

 *idnetifier of race type
 gen racetypeid=.

replace  racetypeid=1 if race_type=="sprint"
replace  racetypeid=2 if race_type=="middle"
replace  racetypeid=3 if race_type=="long"

}



**********************Adding macro variables for country of origin

decode Nationality, gen(Nationality_)
replace Nationality_="SWZ" if Nationality_=="SUI"
replace Nationality_="AGO" if Nationality_=="AIA"
replace Nationality_="PRT" if Nationality_=="POR"
replace Nationality_="DEU" if Nationality_=="GER"
replace Nationality_="DNK" if Nationality_=="DEN"
replace Nationality_="RUS" if Nationality_=="RSA"
replace Nationality_="BHS" if Nationality_=="BAH"
replace Nationality_="BWA" if Nationality_=="BOT"
replace Nationality_="BGD" if Nationality_=="BAN"
replace Nationality_="BGR" if Nationality_=="BUL"
replace Nationality_="CHL" if Nationality_=="CHI"
replace Nationality_="GRC" if Nationality_=="GRE"
merge m:1 Nationality_ using  "$root/supplementary/doctor_percap_country.dta" , keep(match master)
drop _merge

merge m:1 Nationality_ using  "$root/supplementary/growth_rate_country.dta" , keep(match master)
drop _merge

merge m:1 Nationality_ using  "$root/supplementary/hospital_beds_country.dta" , keep(match master)
drop _merge

merge m:1 Nationality_ using  "$root/supplementary/pollution_mort_by_country(2019).dta" , keep(match master)
drop _merge

merge m:1 Nationality_ using  "$root/supplementary/poverty_ratio_country.dta" , keep(match master)
drop _merge

merge m:1 Nationality_ using  "$root/supplementary/GDP_percapita_country.dta" , keep(match master)
drop _merge

drop Nationality_ country_
 
save "$root/data_ready.dta", replace


