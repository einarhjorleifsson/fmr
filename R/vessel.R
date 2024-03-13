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
                  registration_date = lubridate::as_date(registration_date)) |> 
    dplyr::distinct()
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


#' Vessel informations
#'
#' @param key your FM API key
#' @param std boolean, if TRUE (default) variables are renamed according to 
#' {fmr} convention
#' @param trim boolean, if TRUE (default) only essential (standard) variables
#' are returned. Only active if arguement std is set to TRUE.
#' @param remove_empty  boolean, if TRUE (default) drops variables composed 
#' entirely of NA values
#' @param add_owner boolean, if TRUE (default) adds owner name (first, middle and last name)
#' as a single string
#' @param add_operator boolean, if TRUE (default) adds operator name (first, middle and last 
#' name) as a single string
#'
#' @return a tibble
#' @export
#'
fm_vessel <- function(key, std = TRUE, trim = TRUE, remove_empty = TRUE, add_owner = FALSE, add_operator = FALSE) {
  
  d <- fm_vesselF(key = key)
  
  if(std) {
    d <- 
      d |> 
      dplyr::rename(dplyr::any_of(vocabulary))
    
    if(trim) {
      
    }
  }
  
  if(add_owner) {
    d <-
      d |> 
      dplyr::left_join(fm_partyV(key) |> 
                         tidyr::unite("owner", first_name:last_name,
                                      na.rm = TRUE, sep = " ") |> 
                         dplyr::select(party_id,
                                       owner),
                       by = dplyr::join_by(owner_id == party_id)) |> 
      dplyr::select(-owner_id)
  }
  
  if(add_operator) {
    d <- 
      d |> 
      dplyr::left_join(fm_partyV(key) |> 
                         tidyr::unite("operator", first_name:last_name, 
                                      na.rm = TRUE, sep = " ") |> 
                         dplyr::select(party_id,
                                       operator),
                       by = dplyr::join_by(operator_id == party_id)) |> 
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
