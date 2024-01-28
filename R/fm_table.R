#' Fisheries manager table connection
#'
#' @param table string
#' @param key string
#'
#' @return a tibble
#' @export
#'
fm_tbl <- function(table = "siteD", key) {
  
  if(missing(key)) key <- Sys.getenv("fm_key")
  
  url <- 
  pth <- paste0("https://datistica.is/datistica/api/v1.0/public/", 
                table, "?key=", key)
  jsonlite::fromJSON(pth)$result |> 
    tibble::as_tibble() |> 
    janitor::clean_names()
  
}


fm_choice <- function(key) {
  fm_tbl(table == "choiceD", key)
}

fm_coordinates <- function(key) {
  fm_tbl(table == "coordinateD", key)
}
#' @export
fm_country <- function(key) {
  fm_tbl(table == "countryD", key)
}
#' @export
fm_gear <- function(key) {
  fm_tbl(table = "gearD", key) |> 
    janitor::clean_names() |> 
    dplyr::rename(gear = friendly_name) |> 
    dplyr::mutate(gear = stringr::str_squish(gear))
}
#' @export
fm_landings <- function(key) {
  fm_tbl(table = "landingV", key)
}

fm_landings_code <- function(key) {
  fm_tbl(table = "landingF", key)
}
#' @export
fm_landings_site <- function(key) {
  q <- 
    fm_tbl(table = "siteD", key) |> 
    dplyr::select(site, lon = longitude, lat = latitude, dplyr::everything())
  
  # possibly temporary
  .tid = q$tenant_id |> unique()
  if(length(.tid) == 1 & .tid == 103) {
    q <- 
      q |> 
      dplyr::mutate(island = dplyr::case_when(lat >= 17.25 ~ "Saint Kitts",
                                              .default = "Nevis")) |> 
      dplyr::select(site, island, dplyr::everything())
  }
  
  return(q)
  
}


fm_licence <- function(key) {
  fm_tbl(table = "licenseV", key)
}
#' @export
fm_licence_f <- function(key) {
  fm_tbl(table = "licenseF", key)
}

#' @export
fm_location <- function(key) {
  fm_tbl(table == "locationD", key)
}
#' @export
fm_species <- function(key) {
  fm_tbl(table = "specieD", key) |> 
    janitor::clean_names() |> 
    dplyr::rename(species = friendly_name) |> 
    dplyr::mutate(species = stringr::str_squish(species))
}

#' @export
fm_survey_date <- function(key) {
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
#' @export
fm_tentant <- function(key) {
  fm_tbl(table = "tenantD", key)
}

fm_vessel <- function(key) {
  fm_tbl(table = "vesselD", key) |> 
    janitor::clean_names()
}
#' @export
fm_vessel_F <- function(key) {
  fm_tbl(table = "vesselF", key) |> 
    janitor::clean_names()
}

fm_vessel_class <- function(key) {
  fm_tbl(table = "vesselclassD", key)
}
#' @export
fm_party <- function(key) {
  fm_tbl(table = "partyV", key)
}
