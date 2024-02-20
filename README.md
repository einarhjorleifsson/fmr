
<!-- README.md is generated from README.Rmd. Please edit that file -->

# fmr

<!-- badges: start -->
<!-- badges: end -->

The goal of {fmr} is to:

- Establish R-connection to [The Fisheries
  Manager](https://fimsehf.atlassian.net/wiki/spaces/FT/overview?homepageId=3175186440)
  data provided by [Fisheries Technologies](https://fishtech.is)
  - The current communication is via API’s that provides data in
    json-format
- Provide wrapper functions to FTM tables and views
- Provide markdown report templates for various standardized reports
- R-code examples for data analysis and graphical presentations

## Quick start

``` r
remotes::install_github("einarhjorleifsson/fmr")
```

``` r
library(fmr)
library(tidyverse)
key <- "your_FM_API_key"
```

``` r
fm_survey(key) |> glimpse()
#> Rows: 2,343
#> Columns: 15
#> $ site        <chr> "Basseterre West", "Sandy Point Bay", "Basseterre East", "…
#> $ island      <chr> "Saint Kitts", "Saint Kitts", "Saint Kitts", "Saint Kitts"…
#> $ status      <chr> "In progress", "Completed", "Completed", "Completed", "Com…
#> $ date        <date> NA, 2023-01-11, 2023-01-08, 2023-01-08, 2023-01-08, 2023-…
#> $ T1          <dttm> NA, 2023-01-11 14:00:00, 2023-01-08 16:00:00, 2023-01-08 …
#> $ T2          <dttm> 2023-02-15 03:07:21, 2023-01-11 23:00:00, 2023-01-08 20:0…
#> $ total_boats <dbl> 1, 1, 4, 4, 4, 12, 4, 4, 1, 1, 1, 6, 1, 6, 10, 10, 10, 6, …
#> $ comment     <chr> "Feb6  amend", NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
#> $ type        <chr> "Landing", "Landing", "Landing", "Landing", "Landing", "La…
#> $ collector   <chr> "Enver Pemberton", "Doret Williams", NA, NA, NA, "Judika E…
#> $ .cn         <chr> "EnverP", "TracyG", "TracyG", "TracyG", "TracyG", "TracyG"…
#> $ .ct         <dttm> 2023-02-15 07:12:23, 2023-02-16 14:27:51, 2023-02-16 16:5…
#> $ .un         <chr> "EnverP", "TracyG", "TracyG", "TracyG", "TracyG", "TracyG"…
#> $ .ut         <dttm> 2023-02-15 07:12:23, 2023-03-03 14:12:29, 2023-02-28 14:4…
#> $ .s1         <dbl> 1475, 1487, 1493, 1494, 1495, 1496, 1498, 1499, 1503, 1513…
```
