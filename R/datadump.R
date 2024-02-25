#' Dump a FM table as rds
#'
#' @param table FM table name
#' @param key your FM API key 
#' @param dump_pth pth to your 
#'
#' @return NULL
#' @export
#'
fm_dump <- function(table, key, dump_pth) {
  
  if(!dir.exists(dump_pth)) {
    stop(paste0("Dump path: ", dump_pth, " does not exist")) 
  }
  
  fm_tbl(table = table, key, clean = FALSE) |> 
    readr::write_rds(paste0(dump_pth, "/", table, ".rds"))
}


#' Fisheries manager datadump
#' 
#' Dumps all available API data from Fisheries Manager as a R rds-file
#' to the path specified.
#'
#' @param key your FM API key 
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
  
  
  purrr::map(tables, fm_dump, key, dump_pth)
  
}