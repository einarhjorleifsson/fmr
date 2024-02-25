

# Choice -----------------------------------------------------------------------

#' choice table (choiceD)
#'
#' @param key your FM API key
#' @param std boolean, if TRUE (default) returns shorter names
#'
#' @return a tibble
fm_choice <- function(key, std = TRUE) {
  d <- 
    fm_tbl(table = "choiceD", key) |> 
    dplyr::mutate(table_name = stringr::str_to_lower(table_name),
                  column_name = stringr::str_to_lower(column_name)) |> 
    dplyr::arrange(table_name, column_name)
  if(std) {
    d <- 
      d |> 
      dplyr::rename(table = table_name,
                    variable = column_name)
  }
  
  return(d)
  
}