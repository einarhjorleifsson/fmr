#' Fisheries manager table connection
#'
#' @param table string, see what is currently available at: https://fimsehf.atlassian.net/wiki/spaces/FT/pages/3255894017/.REST+API+for+reporting+endpoint
#' @param key string
#'
#' @return a tibble
#' @export
#'
fm_tbl <- function(table = "siteD", key, clean = TRUE) {
  
  if(missing(key)) key <- Sys.getenv("fm_key")
  
  url <- 
    paste0("https://datistica.is/datistica/api/v1.0/public/",
           table, 
           "?key=", 
           key)
  d <- 
    jsonlite::fromJSON(url)$result |> 
    tibble::as_tibble()
  
  if(clean) {
    d <- 
      d |> 
      janitor::clean_names()
  }
  
  return(d)
  
}
