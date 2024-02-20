#' Location table
#'
#' @param key your FT API key
#'
#' @return A tibble
fm_location <- function(key) {
  fm_tbl("locationD", key) |> 
    dplyr::select(location_id, location, tenant_id)
}


#' Coordinates of fishing zones
#' 
#' Specific for St. Kitt's and Nevis
#'
#' @param key you FT API key
#'
#' @return a tibble
fm_location_knr <- function(key) {
  
  fm_location(key) |> 
    dplyr::left_join(fishing_zone |> 
                       dplyr::select(location = area, lon, lat)) |> 
    dplyr::select(-is_active)
  
}
