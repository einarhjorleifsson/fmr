
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

## Installing

``` r
remotes::install_github("einarhjorleifsson/fmr")
```

## Connection

``` r
library(fmr)
library(tidyverse)
key <- "your_FM_API_key"
```

## The FM API

The current API does not provide direct access to the database used by
FM (Oracle) but to an API that provides the data in a JSON format. An
example of such an interface (here for the gear table) is:

### Primary tables

Currently there are three primary datatables within the FM-system:

- …

### Auxillary tables

- …

## The {fmr} philosophy

The {fmr}-package provides a convenient wrapper to the FM-API so that
data can be imported directly into R. The lowest level function is
`fm_tbl`-function. One can e.g. obtain an exact copy of the what can be
obtained from the JSON API “surveyItem” (read: The trip table) by using
the following arguments:

``` r
fm_tbl(table = "surveyItem", key = key, clean = FALSE) |> glimpse()
#> Rows: 5,764
#> Columns: 35
#> $ surveyItemId           <int> 1520, 1529, 1530, 1531, 1535, 1536, 1538, 1540,…
#> $ surveyItemTypeId       <int> 1871, 1871, 1871, 1871, 1871, 1871, 1871, 1871,…
#> $ surveyItemStatusId     <int> 1867, 1867, 1867, 1867, 1867, 1867, 1867, 1867,…
#> $ surveyId               <int> 1481, 1489, 1490, 1491, 1495, 1496, 1498, 1500,…
#> $ depLocationId          <int> 10081, 10081, 10081, 10081, 10080, 10080, 10080…
#> $ depTime                <chr> "2023-01-05T05:00:00.000+00:00", "2023-01-12T09…
#> $ depStatusId            <int> 1861, 1861, 1861, 1861, 1861, 1861, 1861, 1861,…
#> $ arrLocationId          <int> 10081, 10081, 10081, 10081, 10080, 10080, 10080…
#> $ plannedDestinationId   <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
#> $ arrTime                <chr> "2023-01-05T15:00:00.000+00:00", "2023-01-12T16…
#> $ arrStatusId            <int> 1856, 1856, 1856, 1856, 1856, 1856, 1856, 1856,…
#> $ vesselId               <int> 1892, 1893, 1892, 2029, 1872, 1997, 1872, 1994,…
#> $ vesselVersion          <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,…
#> $ secondaryVesselId      <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
#> $ secondaryVesselVersion <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
#> $ gearId                 <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
#> $ secondaryGearId        <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
#> $ gearClassId            <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
#> $ vesselClassId          <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
#> $ climateId              <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
#> $ infractionTypeId       <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
#> $ infractionDesc         <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
#> $ measurementTypeId      <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
#> $ fuelUsed               <dbl> NA, 500, 150, 500, NA, NA, 200, 245, NA, 150, 1…
#> $ totalCrew              <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
#> $ comment                <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
#> $ rank                   <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
#> $ imageName              <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
#> $ contentType            <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
#> $ tenantId               <int> 103, 103, 103, 103, 103, 103, 103, 103, 103, 10…
#> $ isActive               <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,…
#> $ createdBy              <chr> "TracyG", "TracyG", "TracyG", "TracyG", "TracyG…
#> $ lastModifiedBy         <chr> "TracyG", "TracyG", "TracyG", "TracyG", "TracyG…
#> $ createdDate            <chr> "2023-02-15T18:53:19.016+00:00", "2023-02-16T15…
#> $ lastModifiedDate       <chr> "2023-02-15T18:53:19.016+00:00", "2023-02-16T15…
```

This table has actually a lot of variables, starting off with a lot of
numerical “Id”s that an average data analyst may be unfamiliar with. …

There are also two addtional notes to make with respect to these “raw”
data:

- Variable names are in “camel-toe” format meaning some letters are
  capital format
- Some of the variable types are not as expected. Examples are all the
  datetime variables (depTime, arrTime, createdDate, lastModifiedDate)
  are set as characters. And then we have a lot of variables that are of
  type logigcal (<lgl>)

The reason for the latter is that the API JSON format does not provide
type specification of each variable and R imports variables based on the
“lowest denominator”.

Most of the function only need the user to supply the FM-API \*\*key\*,
it being strategically put as the first argument. So e.g. to access the
trip table one only needs the following:

``` r
fm_trip(key, std = FALSE) |> glimpse()
#> Rows: 5,764
#> Columns: 29
#> $ vessel_id                <dbl> 1892, 1893, 1892, 2029, 1872, 1997, 1872, 199…
#> $ vessel_name              <chr> "God's Blessings", "Togetherness 2", "God's B…
#> $ registration_no          <chr> "V4-601-BW", "V4-475-SP", "V4-601-BW", "V4-53…
#> $ owner                    <chr> "Keithroy David", NA, "Keithroy David", "Alla…
#> $ operator                 <chr> "Valet Pemberton", NA, "Valet Pemberton", "Al…
#> $ dep_time                 <dttm> 2023-01-05 05:00:00, 2023-01-12 09:15:00, 20…
#> $ arr_time                 <dttm> 2023-01-05 15:00:00, 2023-01-12 16:30:00, 20…
#> $ fuel_used                <dbl> NA, 500, 150, 500, NA, NA, 200, 245, NA, 150,…
#> $ site1                    <chr> "Basseterre West", "Basseterre West", "Basset…
#> $ site2                    <chr> "Basseterre West", "Basseterre West", "Basset…
#> $ survey_item_id           <dbl> 1520, 1529, 1530, 1531, 1535, 1536, 1538, 154…
#> $ survey_id                <dbl> 1481, 1489, 1490, 1491, 1495, 1496, 1498, 150…
#> $ comment                  <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
#> $ created_by               <chr> "TracyG", "TracyG", "TracyG", "TracyG", "Trac…
#> $ created_date             <dttm> 2023-02-15 18:53:19, 2023-02-16 15:02:09, 20…
#> $ last_modified_by         <chr> "TracyG", "TracyG", "TracyG", "TracyG", "Trac…
#> $ last_modified_date       <dttm> 2023-02-15 18:53:19, 2023-02-16 15:02:09, 20…
#> $ survey_item_type_id      <dbl> 1871, 1871, 1871, 1871, 1871, 1871, 1871, 187…
#> $ survey_item_status_id    <dbl> 1867, 1867, 1867, 1867, 1867, 1867, 1867, 186…
#> $ dep_location_id          <dbl> 10081, 10081, 10081, 10081, 10080, 10080, 100…
#> $ dep_status_id            <dbl> 1861, 1861, 1861, 1861, 1861, 1861, 1861, 186…
#> $ arr_location_id          <dbl> 10081, 10081, 10081, 10081, 10080, 10080, 100…
#> $ arr_status_id            <dbl> 1856, 1856, 1856, 1856, 1856, 1856, 1856, 185…
#> $ vessel_version           <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, …
#> $ secondary_vessel_id      <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
#> $ secondary_vessel_version <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
#> $ total_crew               <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
#> $ tenant_id                <dbl> 103, 103, 103, 103, 103, 103, 103, 103, 103, …
#> $ is_active                <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
```

``` r
fm_tbl(table = "vesselD", key) |> glimpse()
#> Rows: 296
#> Columns: 16
#> $ vessel_id         <int> 1861, 1875, 1889, 1903, 1917, 1929, 1945, 1961, 1977…
#> $ vessel_version    <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…
#> $ vessel_name       <chr> "Perseverance", "Royalty", "Kasim", "Adlyn", "MISHOY…
#> $ registration_no   <chr> "V4-594-BE", "V4-503-DB", "V4-149-SP", "V4-443-BE", …
#> $ district_code     <chr> "BE", "DB", "SP", "BE", "CH", "IC", "CH", "IC", "JB"…
#> $ district_no       <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
#> $ class_id          <int> 1029, 1025, 1029, 1029, 1029, 1029, 1029, 1029, 1029…
#> $ tenant_id         <int> 103, 103, 103, 103, 103, 103, 103, 103, 103, 103, 10…
#> $ is_active         <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0…
#> $ isscfv_id         <int> 1029, 1025, 1029, 1029, 1029, 1029, 1029, 1029, 1029…
#> $ category_code     <int> 10, 9, 10, 10, 10, 10, 10, 10, 10, 1, 10, 29, 10, 29…
#> $ category          <chr> "Multipurpose vessels", "Line vessels (other)", "Mul…
#> $ category_abbr     <chr> "MO", "LO", "MO", "MO", "MO", "MO", "MO", "MO", "MO"…
#> $ sub_category_code <dbl> 10.9, 9.9, 10.9, 10.9, 10.9, 10.9, 10.9, 10.9, 10.9,…
#> $ sub_category      <chr> "Multipurpose vessels nei", "Line vessels nei", "Mul…
#> $ sub_category_abbr <chr> "MOX", "LOX", "MOX", "MOX", "MOX", "MOX", "MOX", "MO…
```
