# SURVEY table -----------------------------------------------------------------

#' The survey table
#'
#' @param key your FM API key
#'
#' @return a tibble
fm_survey_api <- function(key) {
  fm_tbl(table = "survey") |> 
    dplyr::mutate(dplyr::across(c(dplyr::ends_with("_id"),
                                  total_boats,
                                  rank,
                                  is_active), 
                                as.numeric),
                  dplyr::across(c(survey_date,
                                  survey_start_time,
                                  survey_stop_time,
                                  survey_period_from,
                                  survey_period_to,
                                  created_date,
                                  last_modified_date), 
                                lubridate::ymd_hms))
  
}



#' The survey main table
#'
#' The function returns information about each survey.
#' 
#' @param key your FM API key
#' @param std boolean, if TRUE (default) variables are renamed according to 
#' {fmr} convention
#' @param trim boolean, if TRUE (defaul) only essential (standard) variables
#' are returned. Only active if arguement std is set to TRUE.
#' 
#' @return a tibble
#' 
#' @format A data frame with nine variables:
#' \describe{
#' \item{\code{site}}{Name of the (landing) site}
#' \item{\code{island}}{Name of the island, returned in some cases}
#' \item{\code{date}}{Date of the survey, a derived variable from variable time.}
#' \item{\code{time}}{Time of the survey}
#' \item{\code{survey_id}}{Numerical code, used to join to other tables}
#' }
#'
#' For further details, see \url{https://fimsehf.atlassian.net/wiki/spaces/FT/pages/3283812558/New+The+Data+Structure+Explained}
#' 
#' @export
#'
fm_survey <- function(key, std = TRUE, trim = TRUE) {
  
  d <- 
    fm_survey_api(key) |> 
    dplyr::left_join(fm_site(key, trim = FALSE) |> 
                       dplyr::select(party_id,
                                     site,
                                     island),
                     by = dplyr::join_by(landing_site_id == party_id))
  
  if(std) {
    
    d <-
      d |> 
      dplyr::rename(dplyr::any_of(vocabulary)) |> 
      dplyr::select(site, island, date, T1, T2, total_boats, .s1, dplyr::everything()) |> 
      dplyr::mutate(date = lubridate::as_date(date))
    
    if(trim) {
      d <-
        d |> 
        dplyr::select(site:.s1)
    }
  }
  
  return(d)
  
}

