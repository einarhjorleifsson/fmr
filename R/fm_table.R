
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
      dplyr::rename(dplyr::any_of(vocabulary)) |> 
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
