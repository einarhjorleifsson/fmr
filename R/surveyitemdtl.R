
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
fm_catch <- function(key, std = TRUE, trim = TRUE, remove_empty = TRUE) {
  
  sp <- 
    fm_species(key)
  
  gear <- 
    fm_gear(key)
  
  ch <- 
    fm_choice(key) |> 
    dplyr::filter(table == "survey_item_dtl")
  
  fz <- 
    fishing_zone |> 
    dplyr::rename(fz = area) |> 
    dplyr::left_join(fm_tbl("locationD", key) |> dplyr::rename(fz = location),
                     by = dplyr::join_by(fz)) |> 
    dplyr::select(fz, lon, lat, fishing_zone_id = location_id)
  
  d <- 
    fm_surveyitemdtl_api(key) |> 
    # should be removed downstream
    janitor::remove_empty(which = "cols") |> 
    dplyr::left_join(ch |> 
                dplyr::filter(variable == "measurement_type_id") |> 
                dplyr::select(measurement_type_id = choice_id,
                              measurement_type = code),
                by = dplyr::join_by(measurement_type_id)) |> 
    dplyr::left_join(gear,
                     by = dplyr::join_by(gear_id)) |> 
    dplyr::left_join(fz,
                     by = dplyr::join_by(fishing_zone_id)) |> 
    dplyr::left_join(sp,
                     by = dplyr::join_by(species_id))
  d <- 
    d |> 
    # anything to do with gear first - guess could be thought of as "synis_id"
    dplyr::select(gear, gear_size, no_of_sets, soak_time,
                  depth_min, depth_max, 
                  no_of_gears,
                  fz,
                  lon,
                  lat,
                  measurement_type,
                  species_id,
                  species,
                  weight,
                  price,
                  survey_item_id,
                  survey_item_dtl_id,
                  created_by,
                  created_date,
                  last_modified_by,
                  last_modified_date,
                  dplyr::everything())
  
  if(std) {
    
    d <-
      d |> 
      dplyr::rename(dplyr::any_of(vocabulary))
    
    if(trim) {
      d <-
        d |> 
        dplyr::select(gear:.s3)
    }
  }
  
  if(remove_empty) {
    d <- 
      d |> 
      janitor::remove_empty(which = "cols")
  }
  return(d)
  
}
