#' @title Connect to Fisheries Technology Database
#'
#'
#' @description This function is the mother of all mothers that all other ft_ functions
#' rely on. If not you are doomed.
#'
#' @param username your username
#' @param password your password
#'
#' @return a database connection
#'
#' @export

ft_connect <- function(username, password) {

  drv <- DBI::dbDriver("Oracle")
  host <- "oracle.hav.fo"   # Needs to be replaced
  port <- 1521
  xe <- "xe"                # This is dbname

  connect.string <- paste(
    "(DESCRIPTION=",
    "(ADDRESS=(PROTOCOL=tcp)(HOST=", host, ")(PORT=", port, "))",
    "(CONNECT_DATA=(SERVICE_NAME=", xe, ")))", sep = "")

  con <- ROracle::dbConnect(drv, username = username, password = password,
                            dbname = connect.string)

  return(con)
}
