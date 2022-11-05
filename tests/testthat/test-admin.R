test_that("compare shell with R solution", {

  # this can not be accommodated by httptest2
  skip_if_offline()
  skip_if(inherits(tk, "try-error"))

  # curl in shell
  shell <- system2(
    system.file(package = "rirods", "bash", "iadmin.sh"),
    c(
      Sys.getenv("DEV_USER"),
      Sys.getenv("DEV_PASS"),
      Sys.getenv("DEV_HOST_IRODS"),
      Sys.getenv("DEV_ZONE_PATH_IRODS"),
      "add",
      "user",
      "bobby",
      "rodsuser"
    ),
    stdout = TRUE,
    stderr = FALSE
  ) |>
    jsonlite::fromJSON()

  # curl in R
  iadmin(action = "add", target = "user", arg2 = "bobby", arg3 = "rodsuser")
  R <- ils(path = Sys.getenv("DEV_ZONE_PATH_IRODS"))

  # compare list output
  expect_equal(R, shell$`_embedded`)

  # remove user bobby
  iadmin(action = "remove", target = "user", arg2 = "bobby")
})

