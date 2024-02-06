
#' The surveyitemdtl api table
#'
#' The function gets the data from the FM api and ensure correct variable types.
#' Variable names and order as as it comes from the API. The user should 
#' normally use the fm_surveyitem function.
#' 
#' @param key your FM API key
#'
#' @return a tibble
fm_surveyitemdtl_api <- function(key) {
  d <- 
    fm_tbl(table = "surveyItemDtl", key) |> 
    dplyr::mutate(dplyr::across(c(dplyr::ends_with("_id"),
                                  weight,
                                  price,
                                  no_of_gears,
                                  gear_size,
                                  no_of_sets,
                                  soak_time,
                                  depth_min,
                                  depth_max,
                                  is_by_catch,
                                  is_targetted,
                                  item_count,
                                  batch_no,
                                  cooler_no), 
                                as.numeric),
                  dplyr::across(c(created_date,
                                  last_modified_date), 
                                lubridate::ymd_hms))
}



#' The surveyitemdtl table
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
fm_surveyitemdtl <- function(key, std = TRUE, trim = TRUE, remove_empty = TRUE) {
  
  d <- 
    fm_surveyitemdtl_api(key) |> 
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
