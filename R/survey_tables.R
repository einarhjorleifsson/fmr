
# 2024-02-01
#  A bit of reverse engineering here until requested api's becomes available
#   The base information (for now) is the landingF table. That is however
#   a wide-table, generated from three diffrent tables. Below the single
#   table is split into 3 tables again.


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

# SURVEY table -----------------------------------------------------------------

#' The survey variables in landingF
#'
#' @param key your FM API key
#'
#' @return a tibble
fm_sF <- function(key) {
  
  ## selecting - not needed once available on API ------------------------------
  d <-
    fm_landingF(key) |> 
    dplyr::select(survey_id,
                  # I think the original name in the database is survey_time or
                  #  survey_date
                  landing_date,
                  landing_site_id,
                  survey_status_id,
                  tenant_id,
                  is_active,
                  # need confirmation if this comes from the survey table
                  created_by,
                  created_date)
  
  ## formatting ----------------------------------------------------------------
  d <- 
    d |> 
    dplyr::mutate(landing_date = lubridate::ymd_hms(landing_date),
                  created_date = lubridate::ymd_hms(created_date)) |> 
    dplyr::distinct()
  
  return(d)
  
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
#' \item{\code{date}}{Date of the survey}
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
    fm_sF(key) |> 
    dplyr::mutate(time = landing_date, .after = landing_date) |> 
    dplyr::mutate(landing_date = lubridate::as_date(landing_date)) |> 
    dplyr::left_join(fm_site(key, trim = FALSE) |> 
                       dplyr::select(party_id,
                                     site,
                                     island),
                     by = dplyr::join_by(landing_site_id == party_id)) |> 
    dplyr::select(site, island, landing_date, time, survey_id, dplyr::everything())
  
  if(std) {
    
    d <-
      d |> 
      dplyr::rename(dplyr::any_of(vocabulary))
    
    if(trim) {
      d <-
        d |> 
        dplyr::select(site:.s1)
    }
  }
  
  return(d)
  
}

# SURVEY_ITEM table ------------------------------------------------------------
#  E.g. trip table
#   Note gear information are stored in the item table


#' The survey_item variables in landingF
#'
#' @param key your FM API key
#'
#' @return a tibble
fm_siF <- function(key) {
  
  ## selecting - not needed once available on API ------------------------------
  d <- 
    fm_landingF(key) |> 
    dplyr::filter(!is.na(survey_item_id)) |> 
    dplyr::select(survey_item_id,        # primary key for linking to survey_item_dtl
                  survey_id,             # key for linking to survey
                  vessel_id,
                  secondary_vessel_id,

                  fuel_used,
                  
                  dep_location_id,
                  dep_time,
                  
                  arr_location_id,
                  arr_time,
                  
                  # types
                  measurement_type_id,
                  survey_item_type_id,
                  infraction_type_id,
                  
                  # status
                  dep_status_id,
                  arr_status_id,
                  survey_item_status_id,
                  
                  infraction_desc) |> 
    dplyr::distinct() 
  
  ## formatting ----------------------------------------------------------------
  d <-
    d |> 
    dplyr::mutate(dep_time = lubridate::ymd_hms(dep_time),
                  arr_time = lubridate::ymd_hms(arr_time))
  
  return(d)
  
}

#' survey_item table
#'
#' @param key your FM API key
#' @param std boolean
#' @param trim boolean
#'
#' @return a tibble
#' @export
fm_survey_item <- function(key, std = TRUE, trim = TRUE) {
  d <- 
    fm_siF(key) |> 
    dplyr::left_join(fm_vesselD(key) |> 
                       dplyr::select(vessel_id,
                                     vessel_name,
                                     registration_no),
                     by = dplyr::join_by(vessel_id))
  if(std) {
    d <- 
      d |> 
      dplyr::rename(dplyr::any_of(vocabulary)) |> 
      dplyr::select(vessel,
                    reg,
                    fuel,
                    T1,
                    T2,
                    fuel,
                    vid,
                    .s1,
                    .s2,
                    hid1,
                    hid2,
                    dplyr::everything())
  }
  
  if(trim) {
    d <- 
      d |> 
      dplyr::select(vessel:.s2)
  }
  
  return(d)
}
fm_trip <- fm_survey_item


# SURVEY_ITEM_DTL --------------------------------------------------------------

#' The survey_item_dtl variables in landingF
#'
#' @param key your FM API key
#'
#' @return a tibble
fm_sidF <- function(key) {
  fm_landingF(key) |> 
    # should really be and rather than or
    dplyr::filter(!is.na(survey_item_id) | !is.na(survey_item_dtl_id)) |> 
    dplyr::select(species_id,
                  weight,
                  price,
                  gear_id,
                  fishing_zone_id,
                  condition_id,
                  disposition_id,
                  is_by_catch,
                  is_targetted,
                  storage_id,
                  survey_item_dtl_id,
                  survey_item_id,
                  # for debugging
                  .rid = id)
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

