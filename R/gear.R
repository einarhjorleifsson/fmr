
#' Gear table
#'
#' @param key string, your API key to FTM
#' @param std boolean (default TRUE) determining naming convention
#' @param trim boolean (default TRUE), if only "essential" variables
#'
#' @return a tibble

fm_gear <- function(key, std = TRUE, trim = TRUE) {
  d <- 
    fm_tbl(table = "gearD", key) |> 
    janitor::clean_names() |> 
    dplyr::mutate(friendly_name = stringr::str_squish(friendly_name),
                  gear = dplyr::case_when(is.na(friendly_name)  & !is.na(gear_code_en) ~ gear_code_en,
                                          is.na(friendly_name)  &  is.na(gear_code_en) ~ code,
                                          .default = friendly_name))
  if(std) {
  }
  if(trim) {
    d <- 
      d |> 
      dplyr::select(gear_id, gear)
  }
  
  return(d)
}
