global root="C:\Users\mahya\OneDrive - Simon Fraser University (1sfu)\Desktop\Separate files"
cd "$root"
use "$root/raw_data.dta", clear
*NO, obs: 778696
merge m:m competition_id start_date end_date using "$root/test.dta", force
keep if _merge==3
drop _merge
destring pm25 pm25_1_days_ago pm25_2_days_ago pm25_3_days_ago pm25_4_days_ago pm25_5_days_ago pm10 pm10_1_days_ago pm10_2_days_ago pm10_3_days_ago pm10_4_days_ago pm10_5_days_ago, replace
drop pm25_201803 pm25_201804 pm25_201805 pm25_201806 pm25_201807 pm25_201808 pm25_201809 pm25_201810 pm25_201811 pm25_201812 pm25_201901 pm25_201902 pm25_201903 pm25_201904 pm25_201905 pm25_201906 pm25_201907 pm25_201908 pm25_201909 pm25_201910 pm25_201911 pm25_201912 pm25_202001 pm25_202002 pm25_202003 pm25_202004 pm25_202005 pm25_202006 pm25_202007 pm25_202008 pm25_202009 pm25_202010 pm25_202011 pm25_202012 pm25_202101 pm25_202102 pm25_202103 pm25_202104 pm25_202105 pm25_202106 pm25_202107 pm25_202108 pm25_202109 pm25_202110 pm25_202111 pm25_202112 pm25_202201 pm25_202202 pm25_202203 pm25_202204 pm25_202205 pm25_202206 pm25_202207 pm25_202208 pm25_202209 pm25_202210 pm25_202211 pm25_202212 pm25_202301 pm25_202302 pm10_201803 pm10_201804 pm10_201805 pm10_201806 pm10_201807 pm10_201808 pm10_201809 pm10_201810 pm10_201811 pm10_201812 pm10_201901 pm10_201902 pm10_201903 pm10_201904 pm10_201905 pm10_201906 pm10_201907 pm10_201908 pm10_201909 pm10_201910 pm10_201911 pm10_201912 pm10_202001 pm10_202002 pm10_202003 pm10_202004 pm10_202005 pm10_202006 pm10_202007 pm10_202008 pm10_202009 pm10_202010 pm10_202011 pm10_202012 pm10_202101 pm10_202102 pm10_202103 pm10_202104 pm10_202105 pm10_202106 pm10_202107 pm10_202108 pm10_202109 pm10_202110 pm10_202111 pm10_202112 pm10_202201 pm10_202202 pm10_202203 pm10_202204 pm10_202205 pm10_202206 pm10_202207 pm10_202208 pm10_202209 pm10_202210 pm10_202211 pm10_202212 pm10_202301 pm10_202302 v401 v402 v403 v404 v405 v406 v407 v408 v409 v410 v411 v412 v413 v414 v415 v416 v417 v418 v419 v420 v421 v422 v423 v424 v425 v426 v427 v428 v429 v430 v431 v432 v433 v434 v435 v436 v437 v438 v439 v440 v441 v442 v443 v444 v445 v446 pm25_202303 pm25_202304 pm25_202305 pm25_202306 pm25_202307 pm25_202308 pm25_202309 pm25_202310 pm25_202311 pm25_202312 pm25_202401 pm25_202402 pm25_202403 v460 v461 v462 v463 v464 v465 v466 v467 v468 v469 v470 v471 v472 v473 v474 v475 v476 v477 v478 v479 v480 v481 v482 v483 v484 v485 v486 v487 v488 v489 v490 v491 v492 v493 v494 v495 v496 v497 v498 v499 v500 v501 v502 v503 v504 v505 pm10_202303 pm10_202304 pm10_202305 pm10_202306 pm10_202307 pm10_202308 pm10_202309 pm10_202310 pm10_202311 pm10_202312 pm10_202401 pm10_202402 pm10_202403 v637 v638 v639 v640
keep competitorname Nationality gender age athlete_id competitorbirthdate birthdate_variable birthyear start_date end_date competition_id marathon_name second meters disqualified non_defined_outcome mark_no_h mark place points wind wind2 racenumber lat_x lng_x lat_y lng_y race rankingcategory country competitorhasprofile city eventtitle records remark competitiongroup venue name index date realLatitude realLongitude latitude longitude distance discipline in_sample race_indoor race_type pm25 pm25_1_days_ago pm25_2_days_ago pm25_3_days_ago pm25_4_days_ago pm25_5_days_ago pm10 pm10_1_days_ago pm10_2_days_ago pm10_3_days_ago pm10_4_days_ago pm10_5_days_ago o3 o3_1_days_ago o3_2_days_ago o3_3_days_ago o3_4_days_ago o3_5_days_ago no2 no2_1_days_ago no2_2_days_ago no2_3_days_ago no2_4_days_ago no2_5_days_ago so2 so2_1_days_ago so2_2_days_ago so2_3_days_ago so2_4_days_ago so2_5_days_ago co co_2_days_ago co_1_days_ago co_3_days_ago co_4_days_ago co_5_days_ago
destring co co_1_days_ago co_2_days_ago co_3_days_ago co_4_days_ago co_5_days_ago so2 so2_1_days_ago so2_3_days_ago so2_2_days_ago so2_4_days_ago so2_5_days_ago no2 no2_1_days_ago no2_2_days_ago no2_3_days_ago no2_4_days_ago no2_5_days_ago o3 o3_1_days_ago o3_2_days_ago o3_3_days_ago o3_4_days_ago o3_5_days_ago pm10 pm10_1_days_ago pm10_2_days_ago pm10_3_days_ago pm10_4_days_ago pm10_5_days_ago pm25 pm25_1_days_ago pm25_2_days_ago pm25_3_days_ago pm25_4_days_ago pm25_5_days_ago, replace
save "$root/raw_data1.dta", replace

use "$root/raw_data1.dta", clear
merge m:m competition_id realLatitude realLongitude  using "$root/pollution_data.dta", force
keep if _merge==3
drop _merge
save "$root/raw_data2.dta", replace

use "$root/raw_data2.dta", clear
merge m:m competition_id realLatitude realLongitude  using "$root/O3 and CO.dta", force
keep if _merge==3
drop _merge
save "$root/raw_data3.dta", replace

use "$root/raw_data3.dta", clear
merge m:m competition_id  using "$root/pollution_data2.dta", force
keep if _merge==3
drop _merge
save "$root/raw_data4.dta", replace