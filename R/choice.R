

# Choice -----------------------------------------------------------------------

#' choice table (choiceD)
#'
#' @param key your FM API key
#'
#' @return a tibble
fm_choice <- function(key) {
  fm_tbl(table = "choiceD", key)
}