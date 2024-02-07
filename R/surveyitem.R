
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
    fm_tbl(table = "surveyItem", key) |> 
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
fm_surveyitem <- function(key, std = TRUE, trim = TRUE, remove_empty = TRUE) {
  
  site <- 
    fm_site(key) |> 
    dplyr::select(party_id, site)
  d <- 
    fm_surveyitem_api(key) |> 
    dplyr::left_join(fm_vesselD(key) |> 
                       dplyr::select(vessel_id,
                                     vessel_name,
                                     registration_no),
                     by = dplyr::join_by(vessel_id)) |> 
    dplyr::left_join(site |> dplyr::rename(site1 = site, dep_location_id = party_id),
                     by = dplyr::join_by(dep_location_id)) |> 
    dplyr::left_join(site |> dplyr::rename(site2 = site, arr_location_id = party_id),
                     by = dplyr::join_by(arr_location_id)) |> 
    dplyr::select(vessel_id, vessel_name, registration_no,
                  gear_id,
                  dep_time, arr_time, fuel_used, comment,
                  site1, site2,
                  created_by, created_date,
                  last_modified_by, last_modified_date,
                  survey_item_id, survey_id,
                  dplyr::everything())
  
  if(std) {
    
    d <-
      d |> 
      dplyr::rename(dplyr::any_of(vocabulary))
    
    if(trim) {
      d <-
        d |> 
        dplyr::select(vid:.s1)
    }
  }
  
  if(remove_empty) {
    d <- 
      d |> 
      janitor::remove_empty(which = "cols")
  }
  return(d)
  
}

#' A trip table
#' 
#' @note For now same as fm_surveytable with default arguments. In future will
#' most likely need a filter using one of the _id, _class or _category
#'
#' @param key your FM API key
#'
#' @return a tibble
#' @export
#'
fm_trip <- function(key) {
  fm_surveyitem(key)
}
