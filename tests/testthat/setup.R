library(httptest2)

tk <- try({

  # write an gitignore file
  cat(
    "**/*.R",
    file = ".gitignore",
    sep = "\n"
  )

  # switch to new irods project
  create_irods(Sys.getenv("DEV_HOST_IRODS"), Sys.getenv("DEV_ZONE_PATH_IRODS"), overwrite = TRUE)
  withr::defer(unlink("testthat.irods"), teardown_env())

  # some data
  foo <- data.frame(x = c(1, 8, 9), y = c("x", "y", "z"))

  # creates a csv file of foo
  readr::write_csv(foo, "foo.csv")
  withr::defer(unlink("foo.csv"), teardown_env())

  # authenticate
  iauth(Sys.getenv("DEV_USER"), Sys.getenv("DEV_PASS"), "rodsuser")

  # test object
  test <- 1
  iput(test, path = paste0(Sys.getenv("DEV_ZONE_PATH_IRODS"), "/", Sys.getenv("DEV_USER")), overwrite = TRUE)

  # token
  get_token(paste(Sys.getenv("DEV_USER"), Sys.getenv("DEV_PASS"), sep = ":"), find_irods_file("host"))
},
silent = TRUE
)

# fool the tests if no token is available (offline mode)
if (inherits(tk, "try-error")) {
  # set home dir
  # check path formatting, does it end with "/"? If not, then add it.
  if (!grepl("/$", find_irods_file("zone_path")))
    zone_path <- paste0(find_irods_file("zone_path"), "/")
  .rirods$current_dir <- paste0(zone_path, Sys.getenv("DEV_USER"))
  # store token
  assign("token", "secret", envir = .rirods)
}
