# vocabulary -------------------------------------------------------------------

specs_survey <- 
  read_fwf("inst/ora_tables/survey.txt") |> 
  rename(name = 1, null = 2, type = 3) |> 
  slice(-c(1:2)) |>
  mutate(v = tolower(name), .before = name) |> 
  mutate(table = "survey", .before = v) |> 
  mutate(fmr_variable = case_when(v == "survey_id"         ~  ".s1",
                                  v == "survey_date"       ~ "date",
                                  v == "survey_start_time" ~ "T1",
                                  v == "survey_stop_time"  ~ "T2",
                                  v == "rnk"               ~ "rank",    # typo?
                                  
                                  v == "created_by"        ~ ".cn",
                                  v == "created_time"      ~ ".ct",
                                  v == "updated_by"        ~ ".un",
                                  v == "updated_time"      ~ ".ut",
                                  .default = v),
         .before = v) |> 
  rename(fm_variable = v)
specs_survey_item <- 
  read_fwf("inst/ora_tables/survey_item.txt") |> 
  rename(name = 1, null = 2, type = 3) |> 
  slice(-c(1:2)) |> 
  mutate(v = tolower(name), .before = name) |> 
  mutate(table = "survey_item", .before = v) |> 
  mutate(fmr_variable = case_when(v == "survey_item_id"  ~ ".s2",
                                  v == "survey_id"       ~ ".s1",
                                  v == "dep_location_id" ~ "hid1",
                                  v == "dep_time"        ~ "t1",
                                  v == "arr_location_id" ~ "hid2",
                                  v == "arr_time"        ~ "t2",
                                  v == "vessel_id"       ~ "vid",
                                  
                                  v == "rnk"             ~ "rank",    # typo?
                                  
                                  v == "fuel_used"       ~ "fuel",
                                  
                                  v == "created_by"      ~ ".cn",
                                  v == "created_time"    ~ ".ct",
                                  v == "updated_by"      ~ ".un",
                                  v == "updated_time"    ~ ".ut",
                                  
                                  .default = v),
         .after = table) |> 
  rename(fm_variable = v)
specs_survey_item_dtl <-
  read_fwf("inst/ora_tables/survey_item_dtl.txt") |> 
  rename(name = 1, null = 2, type = 3) |> 
  slice(-c(1:2)) |> 
  mutate(v = tolower(name), .before = name) |> 
  mutate(table = "survey_item_dtl", .before = v) |> 
  mutate(fmr_variable = case_when(v == "survey_item_dtl_id" ~ ".s3",
                                  v == "survey_item_id"     ~ ".s2",
                                  
                                  v == "created_by"      ~ ".cn",
                                  v == "created_time"    ~ ".ct",
                                  v == "updated_by"      ~ ".un",
                                  v == "updated_time"    ~ ".ut",
                                  .default = v),
         .after = table) |> 
  rename(fm_variable = v)

v <- 
  bind_rows(specs_survey,
            specs_survey_item,
            specs_survey_item_dtl) |> 
  filter(fmr_variable != fm_variable) |> 
  select(fmr_variable, fm_variable) |> 
  add_row(fmr_variable = c("lon", "lat"),
          fm_variable = c("longitude", "latitude")) |> 
  add_row(fmr_variable = c(".ct", ".ut", ".un"),
          fm_variable = c("created_date", "last_modified_date", "last_modified_by")) |> 
  distinct()
vocabulary <- stats::setNames(object = v$fm_variable, nm = v$fmr_variable)

usethis::use_data(vocabulary, overwrite = TRUE)
