with_mock_dir("navigation", {
  test_that("navigation works", {

    def_path <- paste0(Sys.getenv("DEV_ZONE_PATH_IRODS"), "/", Sys.getenv("DEV_USER"))
    pub_path <- paste0(Sys.getenv("DEV_ZONE_PATH_IRODS"), "/public")

    # default dir
    expect_invisible(icd("."))
    expect_equal(ipwd(), def_path)

    # path on the same level
    # expect_invisible(icd("../public"))
    # expect_equal(ipwd(), pub_path)

    # go back on level lower
    expect_invisible(icd(".."))
    expect_equal(ipwd(), Sys.getenv("DEV_ZONE_PATH_IRODS"))

    # relative paths work as well
    expect_invisible(icd(paste0("./", Sys.getenv("DEV_USER"))))
    expect_equal(ipwd(), def_path)

    # error when selecting file instead of collection
    expect_error(icd(paste0(def_path, "/test")))
    # or for typos and permissions errors
    expect_error(icd(paste0(Sys.getenv("DEV_ZONE_PATH_IRODS") , "/frank")))

  })
})

test_that("shell equals R solution", {

  # this can not be accommodated by httptest2
  skip_if_offline()
  skip_if(inherits(tk, "try-error"))

  # curl in shell
  shell <- system2(
    system.file(package = "rirods", "bash", "ils.sh"),
    c(
      Sys.getenv("DEV_USER"),
      Sys.getenv("DEV_PASS"),
      Sys.getenv("DEV_HOST_IRODS"),
      Sys.getenv("DEV_ZONE_PATH_IRODS"),
      0,
      0,
      0,
      0,
      100
    ),
    stdout = TRUE,
    stderr = FALSE
  ) |>
    jsonlite::fromJSON()

  # curl in R
  R <- ils(path = Sys.getenv("DEV_ZONE_PATH_IRODS"))
  expect_equal(R, shell$`_embedded`)
})
