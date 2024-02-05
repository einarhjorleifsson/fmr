# Species table ----------------------------------------------------------------
#' species table (specieD)
#'
#' @param key your FM API key
#'
#' @return a tibble
fm_speciesD <- function(key) {
  fm_tbl(table = "specieD", key) |> 
    janitor::clean_names()
}
