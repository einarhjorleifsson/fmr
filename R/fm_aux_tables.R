# site table -------------------------------------------------------------------

#' (Landing) sites
#'
#' @param key string, your API key to FTM
#' @param std boolean (default TRUE) determining naming convention
#' @param trim boolean (default TRUE), only return "essential" variables
#'
#' @return A tibble
#' @export
#'
fm_site <- function(key, std = TRUE, trim = TRUE) {
  
  # To be setup generically, naming_key will be an object in {fmr}
  old_names <- c('longitude', 'latitude')
  new_names <- c('lon', 'lat')
  naming_key <- stats::setNames(object = old_names, nm = new_names)
  
  d <- 
    fm_tbl(table = "siteD", key) |> 
    dplyr::select(site, longitude, latitude, dplyr::everything())
  
  # possibly temporary, specify islands
  .tid = d$tenant_id |> unique()
  if(length(.tid) == 1 & .tid == 103) {
    d <- 
      d |> 
      dplyr::mutate(island = dplyr::case_when(latitude >= 17.25 ~ "Saint Kitts",
                                              .default = "Nevis"),
                    .after = site)
  }
  
  if(std) {
    d <-
      d |> 
      dplyr::rename(dplyr::any_of(naming_key)) |> 
      dplyr::select(site, island, lon, lat, party_id, dplyr::everything())
  }
  
  if(trim) {
    d <-
      d |> 
      dplyr::select(site:party_id)
  }
  
  return(d)
  
}

# vessels ----------------------------------------------------------------------
fm_vesselF <- function(key) {
  fm_tbl(table = "vesselF", key) |> 
    janitor::clean_names()
}

fm_vesselD <- function(key) {
  fm_tbl(table = "vesselD", key) |> 
    janitor::clean_names()
}

#' Vessel table
#'
#' For the time being simple, only 3 variables returned
#'
#' @param key your FM API
#'
#' @return a tibble
#' @export
fm_vessel <- function(key) {
  # simple for the time being
  fm_vesselD(key) |> 
    dplyr::select(vessel_id,
                  vessel_name,
                  registration_no)
}

fm_vessel_class <- function(key) {
  fm_tbl(table = "vesselclassD", key)
}

# gear stuff -------------------------------------------------------------------

#' Gear table
#'
#' @param key string, your API key to FTM
#' @param std boolean (default TRUE) determining naming convention
#' @param trim boolean (default TRUE), if only "essential" variables
#'
#' @return a tibble

fm_gear <- function(key, std = TRUE, trim = TRUE) {
  d <- 
    fm_tbl(table = "gearD", key) |> 
    janitor::clean_names() |> 
    dplyr::mutate(friendly_name = stringr::str_squish(friendly_name))
  if(std) {
  }
  if(trim) {
    
  }
  
  return(d)
}

fm_licence <- function(key, std = TRUE, trim = TRUE) {
  fm_tbl(table = "licenseV", key)
}


fm_choice <- function(key) {
  fm_tbl(table == "choiceD", key)
}

fm_coordinates <- function(key) {
  fm_tbl(table == "coordinateD", key)
}


fm_country <- function(key) {
  fm_tbl(table == "countryD", key)
}

fm_licence <- function(key) {
  fm_tbl(table = "licenseV", key)
}

fm_licence_f <- function(key) {
  fm_tbl(table = "licenseF", key)
}

fm_location <- function(key) {
  fm_tbl(table == "locationD", key)
}

fm_species <- function(key) {
  fm_tbl(table = "specieD", key) |> 
    janitor::clean_names() |> 
    dplyr::rename(species = friendly_name) |> 
    dplyr::mutate(species = stringr::str_squish(species))
}

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

fm_tentant <- function(key) {
  fm_tbl(table = "tenantD", key)
}








fm_party <- function(key) {
  fm_tbl(table = "partyV", key)
}
