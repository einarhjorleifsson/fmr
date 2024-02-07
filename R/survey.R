# SURVEY table -----------------------------------------------------------------

# 2024-02-06 For the time being there is no filter on the survey_type_id, because
#            there is only one (1817 - Landing)
#            In the future, once multiple survey types have been entered in the
#            database one could forsee having to create convenient wrapper
#            functions. Need to start thinking about naming conventions.

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
#' @param remove_empty boolean, if TRUE (default) remove variables whose values 
#' are all NA's
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
fm_survey <- function(key, std = TRUE, trim = TRUE, remove_empty = TRUE) {
  
  ch <- fm_choice(key)
  party <- 
    fm_tbl("partyD", key) |> 
    tidyr::unite(col = "collector", first_name, middle_name, last_name, sep = " ", na.rm = TRUE) |> 
    dplyr::select(data_collector_id = party_id, collector)
  
  
  d <- 
    fm_survey_api(key) |> 
    dplyr::left_join(fm_site(key, trim = FALSE) |> 
                       dplyr::select(party_id,
                                     site,
                                     island),
                     by = dplyr::join_by(landing_site_id == party_id)) |> 
    dplyr::left_join(ch |> 
                       dplyr::select(choice_id, status = code),
                     by = dplyr::join_by(survey_status_id == choice_id)) |> 
    dplyr::left_join(party,
                     by = dplyr::join_by(data_collector_id))
    
  
  if(std) {
    
    d <-
      d |> 
      dplyr::rename(dplyr::any_of(vocabulary)) |> 
      dplyr::select(site, island, status, date, T1, T2, 
                    total_boats, comment,
                    collector,
                    .cn, .ct, .un, .ut, .s1, 
                    dplyr::everything()) |> 
      dplyr::mutate(date = lubridate::as_date(date))
    
    if(trim) {
      d <-
        d |> 
        dplyr::select(site:.s1)
    }
  }
  
  if(remove_empty) {
    d <- 
      d |> 
      janitor::remove_empty(which = "cols")
  }
  
  return(d)
  
}

