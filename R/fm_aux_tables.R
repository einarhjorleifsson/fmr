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
#' Vessel fact table (vesselF)
#'
#' @param key your FM API key
#'
#' @return a tibble
fm_vesselF <- function(key) {
  fm_tbl(table = "vesselF", key) |> 
    janitor::clean_names()
}

#' Vessel table (vesselD)
#'
#' @param key your FM API key
#'
#' @return a tibble
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

#' Vessel class table (vesselclassD)
#'
#' @param key your FM API
#'
#' @return a tibble
#' @export
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

# License ----------------------------------------------------------------------

#' license fact table (licenseF)
#'
#' @param key your FM API key
#'
#' @return a tibble
fm_licenseF <- function(key) {
  fm_tbl(table = "licenseF", key)
}

#' license view table (licenseV)
#'
#' @param key your FM API key
#'
#' @return a tibble
fm_licenseV <- function(key) {
  fm_tbl(table = "licenseV", key)
}

# Choice -----------------------------------------------------------------------

#' choice table (choiceD)
#'
#' @param key your FM API key
#'
#' @return a tibble
fm_choice <- function(key) {
  fm_tbl(table == "choiceD", key)
}

# Species table ----------------------------------------------------------------
#' species table (specieD)
#'
#' @param key your FM API key
#'
#' @return a tibble
fm_speciesD <- function(key) {
  fm_tbl(table = "specieD", key) |> 
    janitor::clean_names()
}


# Any other table --------------------------------------------------------------
#' coordinate table (coordinateD)
#'
#' @param key your FM API key
#'
#' @return a tibble
fm_coordinateD <- function(key) {
  fm_tbl(table == "coordinateD", key)
}

#' country table (countryD)
#'
#' @param key your FM API key
#'
#' @return a tibble
fm_countryD <- function(key) {
  fm_tbl(table == "countryD", key)
}


#' location table (locationD)
#'
#' @param key your FM API key
#'
#' @return a tibble
fm_location <- function(key) {
  fm_tbl(table == "locationD", key)
}

#' surveydate table (surveydateD)
#'
#' @param key your FM API key
#'
#' @return a tibble
fm_surveydateD <- function(key) {
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

#' tenant table (tenantD)
#'
#' @param key your FM API key
#'
#' @return a tibble
fm_tentantD <- function(key) {
  fm_tbl(table = "tenantD", key)
}


#' party table (partyV)
#'
#' @param key your FM API key
#'
#' @return a tibble
fm_partyV <- function(key) {
  fm_tbl(table = "partyV", key)
}
