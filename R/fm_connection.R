#' Fisheries manager table connection
#'
#' @param table string, see what is currently available at: https://fimsehf.atlassian.net/wiki/spaces/FT/pages/3255894017/.REST+API+for+reporting+endpoint
#' @param key string
#' @param clean boolean (default TRUE) indicating if variable names should be by janitor-convention.
#'
#' @return a tibble
#' @export
#'
fm_tbl <- function(table = "siteD", key, clean = TRUE) {
  
  if(missing(key)) {
    stop("You have to provide a key")
  }
  
  url <- 
    paste0("https://datistica.is/datistica/api/v1.0/public/",
           table, 
           "?key=", 
           key)
  
  js <- jsonlite::fromJSON(url)
  
  if(js$status == "Failure - Invalid Request") {
    stop(paste0("This is an invalid request. Either your key (",
                key,
                ") or the table name (",
                table,
                ") is wrong"))
  }
  
  d <- 
    js$result |> 
    tibble::as_tibble()
  
  if(nrow(d) == 0) {
    
    warning("There seems to be no data in this table")
  }
  
  if(clean) {
    d <- 
      d |> 
      janitor::clean_names()
  }
  
  return(d)
  
}
