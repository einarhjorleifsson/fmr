
#' The surveyitem api table
#'
#' The function gets the data from the FM api and ensure correct variable types.
#' Variable names and order as as it comes from the API. The user should 
#' normally use the fm_surveyitem function.
#' 
#' @param key your FM API key
#'
#' @return a tibble
fm_surveyitem_api <- function(key) {
  d <- 
    fm_tbl("surveyItem", key) |> 
    dplyr::mutate(dplyr::across(c(dplyr::ends_with("_id"),
                                  fuel_used,
                                  rank), 
                                as.numeric),
                  dplyr::across(c(dep_time,
                                  arr_time,
                                  created_date,
                                  last_modified_date), 
                                lubridate::ymd_hms))
}



#' The surveyitem table
#'
#' The function returns information about each ...
#' 
#' @param key your FM API key
#' @param std boolean, if TRUE (default) variables are renamed according to 
#' {fmr} convention
#' @param trim boolean, if TRUE (default) only essential (standard) variables
#' are returned. Only active if arguement std is set to TRUE.
#' @param remove_empty boolean, if TRUE (default) remove variables whose values 
#' are all NA's
#' 
#' @return a tibble
#' 
#' @format A data frame with these variables if using default arguements:
#' \describe{
#' \item{\code{xxx}}{yyy}
#' }
#' 
#' @export
fm_trip <- function(key, std = TRUE, trim = TRUE, remove_empty = TRUE) {
  
  site <- 
    fm_site(key = key) |> 
    dplyr::select(party_id, site)
  vessel <- 
    fm_vessel(key = key, std = FALSE, add_owner = TRUE, add_operator = TRUE) |> 
    dplyr::select(vessel_id,
                  vessel_name,
                  registration_no,
                  owner,
                  operator)
  
  d <- 
    fm_surveyitem_api(key) |> 
    dplyr::left_join(vessel,
                     by = dplyr::join_by(vessel_id)) |> 
    dplyr::left_join(site |> dplyr::rename(site1 = site, dep_location_id = party_id),
                     by = dplyr::join_by(dep_location_id)) |> 
    dplyr::left_join(site |> dplyr::rename(site2 = site, arr_location_id = party_id),
                     by = dplyr::join_by(arr_location_id)) |> 
    dplyr::select(vessel_id, vessel_name, registration_no,
                  owner, operator,
                  gear_id,
                  dep_time, arr_time, fuel_used, 
                  site1, site2,
                  survey_item_id, survey_id,
                  comment,
                  created_by, created_date,
                  last_modified_by, last_modified_date,
                  dplyr::everything())
  
  if(std) {
    
    d <-
      d |> 
      dplyr::rename(dplyr::any_of(vocabulary))
    
    if(trim) {
      d <-
        d |> 
        dplyr::select(vid:survey_id)
    }
  }
  
  if(remove_empty) {
    d <- 
      d |> 
      janitor::remove_empty(which = "cols")
  }
  return(d)
  
}
