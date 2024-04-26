
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
```
