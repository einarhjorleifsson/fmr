# vessels ----------------------------------------------------------------------
#' Vessel fact table (vesselF)
#'
#' @param key your FM API key
#'
#' @return a tibble
fm_vesselF <- function(key) {
  fm_tbl(table = "vesselF", key) |> 
    janitor::clean_names()
}

#' Vessel table (vesselD)
#'
#' @param key your FM API key
#'
#' @return a tibble
fm_vesselD <- function(key) {
  fm_tbl(table = "vesselD", key) |> 
    janitor::clean_names()
}

#' Vessel table
#'
#' For the time being simple, only 3 variables returned
#'
#' @param key your FM API
#'
#' @return a tibble
#' @export
fm_vessel <- function(key) {
  # simple for the time being
  fm_vesselD(key) |> 
    dplyr::select(vessel_id,
                  vessel_name,
                  registration_no)
}

#' Vessel class table (vesselclassD)
#'
#' @param key your FM API
#'
#' @return a tibble
#' @export
fm_vessel_class <- function(key) {
  fm_tbl(table = "vesselclassD", key)
}
