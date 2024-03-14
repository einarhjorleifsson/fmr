#' Get GADM shapefile for a country
#'
#' @param country_code country 3 letter ISO code
#'
#' @return a tiblle
#' @export
#'
fm_read_country <- function(country_code = "KNA") { 
  pth <- paste0("https://geodata.ucdavis.edu/gadm/gadm4.1/gpkg/gadm41_",
                country_code,
                ".gpkg")
  suppressWarnings(sf::read_sf(pth))
}