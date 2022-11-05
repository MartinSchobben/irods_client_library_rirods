with_mock_dir("irods-rest-call", {
  test_that("irods rest call works", {

    # flags to curl call
    args <- list(
      `logical-path` = paste0(Sys.getenv("DEV_ZONE_PATH_IRODS") , "/", Sys.getenv("DEV_USER")),
      stat = 1,
      permissions = 1,
      metadata = 1,
      offset = 0,
      limit = 100
    )

    # with a httr response
    expect_s3_class(
      irods_rest_call("list", "GET", args, FALSE),
      "httr2_response"
    )

  })
})

with_mock_dir("object-helpers", {
  test_that("irods object helpers work", {

    # path exists
    expect_true(path_exists(paste0(
      Sys.getenv("DEV_ZONE_PATH_IRODS"), "/", Sys.getenv("DEV_USER")
    )))
    expect_false(path_exists(paste0(
      Sys.getenv("DEV_ZONE_PATH_IRODS"), "/frank"
    )))

    # collection exists
    expect_true(is_collection(paste0(
      Sys.getenv("DEV_ZONE_PATH_IRODS"), "/", Sys.getenv("DEV_USER")
    ))) # is a collection
    expect_false(is_collection(paste0(
      Sys.getenv("DEV_ZONE_PATH_IRODS"), "/", Sys.getenv("DEV_USER"), "/test"
    ))) # is a data object
    expect_error(is_collection(paste0(
      Sys.getenv("DEV_ZONE_PATH_IRODS"), "/frank"
    ))) # does not exist at all

    # object exists
    expect_true(is_object(paste0(
      Sys.getenv("DEV_ZONE_PATH_IRODS"), "/", Sys.getenv("DEV_USER"), "/test"
    ))) # is a data object
    expect_false(is_object(paste0(
      Sys.getenv("DEV_ZONE_PATH_IRODS"), "/", Sys.getenv("DEV_USER")
    ))) # is a collection
    expect_error(is_object(paste0(
      Sys.getenv("DEV_ZONE_PATH_IRODS"), "/frank/test"
    ))) # does not exist at all
  })
},
simplify = FALSE
)
