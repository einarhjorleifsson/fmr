
<!-- README.md is generated from README.Rmd. Please edit that file -->

# fmr

<!-- badges: start -->
<!-- badges: end -->

The goal of {fmr} is to:

- Establish R-connection to Fisheries Technology Management (FTM) Oracle
  database
- Provide convenient functions to FTM tables and views
- Provide Rmarkdown report templates for various standardized reports
- R-code examples for data analysis and graphical presentations

## Quick start

``` r
remotes::install_github("einarhjorleifsson/fmr")
```

``` r
library(fmr)
library(tidyverse)
#> ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
#> ✔ dplyr     1.1.4     ✔ readr     2.1.5
#> ✔ forcats   1.0.0     ✔ stringr   1.5.1
#> ✔ ggplot2   3.4.4     ✔ tibble    3.2.1
#> ✔ lubridate 1.9.3     ✔ tidyr     1.3.0
#> ✔ purrr     1.0.2     
#> ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
#> ✖ dplyr::filter() masks stats::filter()
#> ✖ dplyr::lag()    masks stats::lag()
#> ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors
key <- "your FM API key"
```

``` r
fm_survey(key) |> glimpse()
#> Rows: 2,277
#> Columns: 5
#> $ site      <chr> "Basseterre West", "Basseterre West", "Basseterre West", "Ba…
#> $ island    <chr> "Saint Kitts", "Saint Kitts", "Saint Kitts", "Saint Kitts", …
#> $ date      <date> 2023-01-05, 2023-01-09, 2023-01-12, 2023-01-08, 2023-01-08,…
#> $ time      <dttm> 2023-01-05 10:00:00, 2023-01-09 10:00:00, 2023-01-12 10:00:…
#> $ survey_id <int> 1478, 1484, 1489, 1492, 1495, 1497, 1500, 1502, 1503, 1505, …
```
