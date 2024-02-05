# vessels ----------------------------------------------------------------------
#' Vessel fact table (vesselF)
#'
#' @param key your FM API key
#'
#' @return a tibble
#' @export
fm_vesselF <- function(key) {
  fm_tbl(table = "vesselF", key) |> 
    janitor::clean_names() |> 
    dplyr::mutate(registration_date = lubridate::ymd_hms(registration_date),
                  registration_date = lubridate::as_date(registration_date))
}

#' Vessel table (vesselD)
#'
#' @param key your FM API key
#'
#' @return a tibble
#' @export
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



#' Title
#'
#' @param key your FM API key
#' @param std boolean, if TRUE (default) variables are renamed according to 
#' {fmr} convention
#' @param trim boolean, if TRUE (default) only essential (standard) variables
#' are returned. Only active if arguement std is set to TRUE.
#' @param remove_empty  boolean, if TRUE (default) drops variables composed 
#' entirely of NA values
#' @param owner boolean, if TRUE adds owner name (first, middle and last name)
#' as a single string
#' @param operator boolean, if TRUE adds operator name (first, middle and last 
#' name) as a single string
#'
#' @return
#' @export
#'
#' @examples
fm_vessel <- function(key, std = TRUE, trim = TRUE, remove_empty = TRUE, owner = FALSE, operator = FALSE) {
  d <- 
    fm_vesselF()
  
  if(std) {
    d <- 
      d |> 
      dplyr::rename(dplyr::any_of(vocabulary))
    
    if(trim) {
      
    }
  }
  
  if(owner) {
    d <-
      d |> 
      dplyr::left_join(fm_partyV(key) |> 
                         tidyr::unite("owner", first_name:last_name,
                                      na.rm = TRUE, sep = " ") |> 
                         dplyr::select(owner_id = party_id,
                                       owner)) |> 
      dplyr::select(-owner_id)
  }
  
  if(operator) {
    d <- 
      d |> 
      dplyr::left_join(fm_partyV(key) |> 
                         tidyr::unite("operator", first_name:last_name, 
                                      na.rm = TRUE, sep = " ") |> 
                         dplyr::select(operator_id = party_id,
                                       operator)) |> 
      dplyr::select(-operator_id)
  }
  
  if(remove_empty) {
    d <-
      d |> 
      janitor::remove_empty(which = "cols")
  }
  
  return(d)
  
}


#' Vessel class table (vesselclassD)
#'
#' @param key your FM API
#'
#' @return a tibble
#' @export
fm_vesselclassD <- function(key) {
  fm_tbl(table = "vesselclassD", key)
}
