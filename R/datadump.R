#' Fisheries manager datadump
#' 
#' Dumps all available API data from Fisheries Manager as a R rds-file
#' to the path specified.
#'
#' @param key 
#' @param pth vector specifying path to were the data is to be stored
#'
#' @return NULL
#' @export
#'
fm_datadump <- function(key, pth = "dump") {
  
  tables <- c("siteD", "vesselD", "vesselF", "partyV",
              "licenseV", "licenseF", "partyV",
              "choiceD", "coordinateD", "countryD",
              "locationD", "surveydateD", "tenantD",
              "gearD", "specieD",
              "landingF", "landingV",
              "survey", "surveyItem", "surveyItemDtl")
  
  fm_dump <- function(table, key) {
    fm_tbl(table = table, key, clean = FALSE) |> 
      readr::write_rds(paste0(pth, "/", table, ".rds"))
  }
  
  purrr::map(tables, fm_dump, key)
  
}