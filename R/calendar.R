#' Creates a monthly grid
#'
#' @param d a tibble containing varible date
#'
#' @return a tibble with added parameter .wday, .week, .month and .day
#' @export
#'
fm_grid_calendar <- function(d) {
  
  D1 <- lubridate::floor_date(min(d$date, na.rm = TRUE), "month")
  D2 <- lubridate::ceiling_date(max(d$date, na.rm = TRUE), "month") - 1
  g <- 
    tidyr::expand_grid(date = seq(D1, D2, by = 1),
                site = unique(d$site)) |> 
    dplyr::mutate(.wday = lubridate::wday(date, label = TRUE, locale = "en_GB.utf8", week_start = 1),
                  .week = lubridate::week(date),
                  .month = lubridate::month(date, label = TRUE, abbr = FALSE, locale = "en_GB.utf8"),
                  .day = lubridate::day(date)) |> 
    dplyr::left_join(d) |> 
    dplyr::mutate(survey = tidyr::replace_na(survey, FALSE))
  levels(g$.wday) <- c("Mo", "Tu", "We", "Th", "Fr", "Sa", "Su")
  
  return(g)
}