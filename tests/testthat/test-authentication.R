test_that("compare shell with R solution", {

  # this can not be accommodated by httptest2
  skip_if_offline()
  skip_if(inherits(tk, "try-error"))

  # curl in shell
  shell <- system2(
    system.file(package = "rirods", "bash", "iauth.sh"),
    c(
      Sys.getenv("DEV_USER"),
      Sys.getenv("DEV_PASS"),
      Sys.getenv("DEV_HOST_IRODS")
    ),
    stdout = TRUE,
    stderr = FALSE
  )

  # curl in R
  R <- get_token(
    paste0(Sys.getenv("DEV_USER"), ":", Sys.getenv("DEV_PASS")),
    Sys.getenv("DEV_HOST_IRODS")
  )

  expect_equal(nchar(R), nchar(shell))
})
