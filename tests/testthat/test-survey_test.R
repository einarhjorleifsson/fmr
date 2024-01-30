test_that("rows of survey components should be the same as landingF", {
  s <- fm_sF()
  si <- fm_siF()
  sid <- fm_sidF()
  l <- 
    s |> 
    dplyr::left_join(si) |> 
    dplyr::left_join(sid)
  l2 <- fm_tbl("landingF")
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
