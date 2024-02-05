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