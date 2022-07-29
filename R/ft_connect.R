# https://guillaumepressiat.github.io/blog/2019/11/oraclyr

#' @title Connect to Fisheries Technology Mangager Oracle Database
#'
#' @description This function is the mother of all mothers that all other ft_ functions rely on. If not you are doomed.
#'
#' @param username your username
#' @param password your password
#' @param DBQ your path to the database
#' @param use_odbc A boolean (default TRUE) controlling if connection via odbc or ROracle.
#' The latter is generally faster but more difficult to setup.
#'
#' @return a database connection
#'
#' @export

ft_connect <- function(username, password, DBQ, use_odbc = TRUE) {

  if(use_odbc) {
    con <-
      DBI::dbConnect(odbc::odbc(),
                     Driver = "Oracle",
                     Port = 1521,
                     UID = username,
                     PWD = password,
                     DBQ = DBQ,
                     timeout = 20)
  }

  return(con)
}


#' @title Access a table
#'
#' @param con A oracle connection
#' @param tbl A string containing schema and table, separated by a dot
#'
#' @export
ft_tbl <- function (con, tbl) {
  if (packageVersion("dbplyr") == "1.4.4") {
    x <- strsplit(tbl, "\\.") |> unlist()
  }
  else {
    x <- strsplit(tbl, "\\.") |> unlist() |> purrr::map_if(!grepl("\"",
                                                                    .), toupper) |> gsub("\"", "", .)
  }
  dplyr::tbl(con, dbplyr::in_schema(x[1], x[2])) |> dplyr::select_all(tolower)
}

#' @title Get overview of all tables in FTM
#'
#' @param con A oracle connection
#'
#' @export
ft_tables <- function(con) {
  ft_tbl(con, "sys.all_tables")
}

#' @title Get overview of all views in FTM
#'
#' @param con A oracle connection
#'
#' @export
ft_views <- function(con) {
  ft_tbl(con, "sys.all_views")
}

#' @title Vessel table
#'
#' @param con A oracle connection
#'
#' @export
ft_vessels <- function(con) {
  ft_tbl(con, "datistica1.vessels") |>
    dplyr::select(-c(image:image_content_type, created_by:updated_time))
}


#' @title FAO ASFIS table
#'
#' @param con A oracle connection
#'
#' @export
ft_asfis <- function(con) {
  ft_tbl(con, "datistica1.z_asfis") |>
    dplyr::select(-c(stats_data, image_name, image_content_type, image))
}

#' @title Local species table
#'
#' @param con A oracle connection
#'
#' @export
ft_species <- function(con) {
  ft_tbl(con, "datistica1.species") |>
    dplyr::select(species_id, friendly_name, asfis_id)
}
