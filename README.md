# Not Too Hot to Run: Adaptation to Extreme Heat in Competitive Runners — data construction code

## Purpose

This repository holds the Stata and R code used to build the analysis dataset for the paper
"Not Too Hot to Run: Adaptation to Extreme Heat in Competitive Runners". The scripts merge
runner-level race records with weather, air-pollution and country-level variables and create
the variables used in estimation (for example speed, log speed, season, race type, and
country averages of temperature and PM2.5).

The repository contains data construction code only. No estimation scripts, tables or
figures are included.

## Status

Work in progress. Circulated as SFU Economics Discussion Paper 25-02.

## Authors

1. Fernando M. Aragón
2. Mahyar Rezazadeh

Author order follows the paper. Script headers mark some edits with "FA" (for example,
`Separate files, october2024/merging_.do`, "Author:FA").

## Data sources and access

**The data are not in this repository.** The scripts expect the files below to be present
under the folder set in `global root`. Access conditions and licences for these files are
not recorded in the repository.

| File read by the code | What the code says about it |
| --- | --- |
| `Separate files, october2024/raw_data_oct10.dta` | Runner and race records merged with weather data; created by `merging_.do` |
| `runner_sample.dta`, `weather_data_main.dta` | Inputs to `merging_.do`; source not recorded |
| `Separate files, october2024/Alternative weather data/daytime_temperature.dta` | Daytime temperature by competition day; source not recorded |
| `Separate files, october2024/Alternative weather data/bias corrected p.25/pm25_bias_corrected.dta` | Bias-corrected PM2.5 by competition day; source not recorded |
| `supplementary/long-term pollutants, city-level.dta` | Monthly city-level PM2.5, PM10, O3, CO and temperature; averaged to country level for 2019–2023 |
| `supplementary/mege_pollution_ioccode.xlsx` | Country PM2.5 in 2023; a code comment says it comes from the IQAir website |
| `supplementary/additional vars FA.xlsx` | Extra race-level variables; source not recorded |
| `supplementary/world_records.xlsx` | World records by distance, used for a standardized performance measure (code comment cites Sexton et al., JAERE 2022) |
| `supplementary/doctor_percap_country.dta`, `growth_rate_country.dta`, `hospital_beds_country.dta`, `pollution_mort_by_country(2019).dta`, `poverty_ratio_country.dta`, `GDP_percapita_country.dta` | Country-of-origin variables for runners; source not recorded |

The two R scripts download public tables:

- `supplementary/table_ioc_codes.R` reads the IOC country code table from
  https://en.wikipedia.org/wiki/List_of_IOC_country_codes
- `supplementary/table_pollution.R` reads the country pollution table from
  https://www.iqair.com/ca/world-most-polluted-countries

The original source of the runner records is not named in this repository (inferred: the
companion repository `Wordlathletics-replication-package` scrapes World Athletics results).
The raw records include athlete-level fields such as names and birth dates, so they should be
treated as personal data.

## Software and versions

- Stata: version not recorded. No user-written Stata packages are called.
- R: version not recorded. Packages: `rvest`, `openxlsx` (versions not recorded).

## Folder map

```
.
├── Separate files, october2024/
│   ├── merging_.do               # merges runner sample with weather data -> raw_data_oct10.dta
│   └── create dataset_oct4.do    # builds data_ready.dta and data_readywmean.dta (latest version)
├── Separate files/
│   └── merging dataset.do        # earlier merge of runner, pollution, O3 and CO files -> raw_data1-4.dta
├── older versions/
│   └── create dataset_sep24.do   # earlier version of the dataset build (reads raw_data_sep24.dta)
└── supplementary/
    ├── create dataset .do        # earlier version of the dataset build (reads raw_data.dta)
    ├── table_ioc_codes.R         # downloads IOC country codes to ioc_country_codes.xlsx
    └── table_pollution.R         # downloads IQAir country pollution table to pollution_data.xlsx
```

## How to run

No master script is provided. The order below is **inferred** from file names, dates in
comments, and the files each script reads and writes.

1. (Optional) Run `supplementary/table_ioc_codes.R` and `supplementary/table_pollution.R`
   to download the IOC code and IQAir tables. How these outputs became
   `supplementary/mege_pollution_ioccode.xlsx` is not recorded (inferred: a manual merge).
2. Run `Separate files, october2024/merging_.do` to create `raw_data_oct10.dta`.
3. Create an empty `temp/` folder under the root folder; the scripts save intermediate files
   there but do not create it.
4. Run `Separate files, october2024/create dataset_oct4.do`. It writes `data_ready.dta` and
   `data_readywmean.dta` in the root folder.

`Separate files/merging dataset.do`, `older versions/create dataset_sep24.do` and
`supplementary/create dataset .do` appear to be earlier versions of the same steps and are
kept for reference (inferred).

Before running, change `global root` at the top of each `.do` file and `file_path` in each
`.R` file to your own folder.

## Running time

Not recorded.

## Limitations

- **Hard-coded absolute paths.** Every script sets an absolute path to the authors' own
  machines (Dropbox and OneDrive folders on Windows and macOS). See
  `create dataset_oct4.do` lines 16–17, `merging_.do` line 7, `merging dataset.do` line 1,
  `create dataset_sep24.do` lines 16–17, `create dataset .do` lines 16–17, and line 22 of
  both R scripts. The `merging_.do` path points to a different folder from the other scripts.
- The data are not included, and the provenance of several input files is not recorded.
- No estimation code is included, so the paper's results cannot be reproduced from this
  repository alone.
- `create dataset_oct4.do` line 379 reads `gen pctile` with no expression; Stata will stop
  with a syntax error at that line, so the last block (which creates `data_readywmean.dta`)
  will not run as written.
- `merging dataset.do` uses `merge m:m ... , force`, which can pair records arbitrarily.
- Several country-code recodes in `create dataset_oct4.do` (lines 333–344) should be checked,
  for example `SUI` is recoded to `SWZ` and `RSA` to `RUS`.
- Software versions are not recorded.
