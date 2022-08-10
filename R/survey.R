#
#' @export
ft_landings <- function(con) {
  ft_tbl(con, "datistica1.landings_view")
}
#' @export
ft_landingsf <- function(con) {
  ft_tbl(con, "datistica1.fact_landings") |>
    dplyr::filter(tenant_id == 100) |>
    dplyr::select(-tenant_id)
}
#' @export
ft_gear <- function(con) {
  ft_tbl(con, "datistica1.gear") |>
    dplyr::filter(tenant_id == 100) |>
    dplyr::select(gear_id:isscfg_id)
}
#' @export
ft_isscfg <- function(con) {
  ft_tbl(con, "datistica1.z_isscfg") |>
    dplyr::select(isscfg_id, gear = isscfg_code_en,
                  gclass = code, gclass_en = gear_l1_name_en)
}
#' @export
ft_sur <- function(con) {
  ft_tbl(con, "datistica1.survey")
}
#' @export
ft_sur_item <- function(con) {
  ft_tbl(con, "datistica1.survey_item")
}
#' @export
ft_sur_item_dtl <- function(con) {
  ft_tbl(con, "datistica1.survey_item_dtl")
}
