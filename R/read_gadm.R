read_gadm <- function(country_code = "KNA") { 
  pth <- paste0("https://geodata.ucdavis.edu/gadm/gadm4.1/gpkg/gadm41_",
                country_code,
                ".gpkg")
  suppressWarnings(sf::read_sf(pth))
}