
#' Sites table
#' 
#' In a catch-sampling cse this constitutes a landings site table
#'
#' @param key string, your API key to FTM
#' @param std boolean (default TRUE) determining naming convention
#' @param trim boolean (default TRUE), only return "essential" variables
#'
#' @return A tibble
#' @export
#'
fm_site <- function(key, std = TRUE, trim = TRUE) {
  
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
      dplyr::rename(dplyr::any_of(vocabulary)) |> 
      dplyr::select(site, island, lon, lat, party_id, dplyr::everything())
  }
  
  if(trim) {
    d <-
      d |> 
      dplyr::select(site:party_id)
  }
  
  return(d)
  
}
