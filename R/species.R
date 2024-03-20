# Species table ----------------------------------------------------------------
#' species table (specieD)
#'
#' @param key your FM API key
#' @param std boolean (default TRUE) determining naming convention
#' @param trim boolean (default TRUE), if only "essential" variables
#'
#' @return a tibble
#' @export
fm_species <- function(key, std = TRUE, trim = TRUE) {
  d <- 
    fm_tbl(table = "specieD", key) |> 
    janitor::clean_names() |> 
    dplyr::mutate(species = dplyr::case_when(is.na(friendly_name)  & !is.na(english_name) ~ english_name,
                                             is.na(friendly_name)  &  is.na(english_name) ~ scientific_name,
                                             .default = friendly_name),
                  species = stringr::str_trim(species))
  if(trim) {
    d <-
      d |> 
      dplyr::select(species_id, species)
  }
  
  return(d)
}
