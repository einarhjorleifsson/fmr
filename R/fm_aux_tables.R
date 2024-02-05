


# gear stuff -------------------------------------------------------------------


# License ----------------------------------------------------------------------





# Any other table --------------------------------------------------------------
#' coordinate table (coordinateD)
#'
#' @param key your FM API key
#'
#' @return a tibble
fm_coordinateD <- function(key) {
  fm_tbl(table == "coordinateD", key)
}

#' country table (countryD)
#'
#' @param key your FM API key
#'
#' @return a tibble
fm_countryD <- function(key) {
  fm_tbl(table == "countryD", key)
}


#' location table (locationD)
#'
#' @param key your FM API key
#'
#' @return a tibble
fm_location <- function(key) {
  fm_tbl(table == "locationD", key)
}

#' surveydate table (surveydateD)
#'
#' @param key your FM API key
#'
#' @return a tibble
fm_surveydateD <- function(key) {
  fm_tbl(table = "surveydateD", key) |> 
    janitor::clean_names() |> 
    dplyr::rename(date = survey_date) |> 
    dplyr::mutate(date = lubridate::ymd_hms(date),
                  day = as.integer(day),
                  month = as.integer(month),
                  year = as.integer(year),
                  week = as.integer(week),
                  quarter = as.integer(quarter))
}

#' tenant table (tenantD)
#'
#' @param key your FM API key
#'
#' @return a tibble
fm_tentantD <- function(key) {
  fm_tbl(table = "tenantD", key)
}


#' party table (partyV)
#'
#' @param key your FM API key
#'
#' @return a tibble
fm_partyV <- function(key) {
  fm_tbl(table = "partyV", key)
}
