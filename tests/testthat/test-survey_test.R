test_that("rows of survey components should be the same as landingF", {
  key <- Sys.getenv("fm_key")
  s <- fm_sF(key)
  si <- fm_siF(key)
  sid <- fm_sidF(key)
  l <- 
    s |> 
    dplyr::left_join(si) |> 
    dplyr::left_join(sid)
  l2 <- fm_tbl("landingF", key)
  expect_equal(nrow(l), nrow(l2))
})

# test_that(".sid is unique for (landing) site and date", {
#   n_sid <- 
#     fm_survey() |> 
#     dplyr::group_by(site, date) |> 
#     dplyr::summarise(n_sid = dplyr::n_distinct(survey_id),
#               .groups = "drop") |> 
#     dplyr::pull(n_sid) |> 
#     max()
#   expect_equal(n_sid, 1)
# })
