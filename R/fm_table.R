
#' Fisheries manager table connection
#'
#' @param table string, see what is currently available at: https://fimsehf.atlassian.net/wiki/spaces/FT/pages/3255894017/.REST+API+for+reporting+endpoint
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
  d <- 
    jsonlite::fromJSON(pth)$result |> 
    tibble::as_tibble() |> 
    janitor::clean_names()
  
  return(d)

}


#' Landing sites
#'
#' @param key string, your API key to FTM
#' @param std boolean (default TRUE) determining naming convention
#' @param trim boolean (default TRUE), if only "essential" variables
#'
#' @return A tibble
#' @export
#'
fm_landings_site <- function(key, std = TRUE, trim = TRUE) {
  
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
                                              .default = "Nevis"))
  }
  
  if(std) {
    d <-
      d |> 
      dplyr::rename(dplyr::any_of(naming_key)) |> 
      dplyr::select(site, island, lon, lat, dplyr::everything())
  }
  
  if(trim) {
    d <-
      d |> 
      dplyr::select(site:party_id)
  }

  return(d)
  
}

#' Gear table
#'
#' @param key string, your API key to FTM
#' @param std boolean (default TRUE) determining naming convention
#' @param trim boolean (default TRUE), if only "essential" variables
#'
#' @return a tibble
#' @export
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
#' @export
fm_country <- function(key) {
  fm_tbl(table == "countryD", key)
}

#' @export
fm_landings <- function(key) {
  fm_tbl(table = "landingV", key) |> 
    dplyr::mutate(landing_date = lubridate::ymd_hms(landing_date),
                  landing_date_time_str = lubridate::dmy_hm(landing_date_time_str),
                  created_date_time_str = lubridate::dmy_hm(created_date_time_str))
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
