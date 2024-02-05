#' landingF data-warehouse table
#' 
#' A wide table consisting elements from the survey_table, survey_item table and 
#' survey_item_dtl table
#'
#' @param key your FM API key
#'
#' @return a tibble
#' @export
fm_landingF <- function(key) {
  fm_tbl(table = "landingF", key)
}

#' landingV data-warehouse table
#' 
#' A wide table consisting elements from the survey_table, survey_item table and 
#' survey_item_dtl table as well as variables from auxillary tables.
#'
#' @param key your FM API key
#'
#' @return a tibble
#' @export
fm_landingV <- function(key) {
  fm_tbl(table = "landingV", key) |> 
    dplyr::mutate(landing_date = lubridate::ymd_hms(landing_date),
                  landing_date_time_str = lubridate::dmy_hm(landing_date_time_str),
                  created_date_time_str = lubridate::dmy_hm(created_date_time_str))
}
