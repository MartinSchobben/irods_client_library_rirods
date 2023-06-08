#' Remove data objects or collections in iRODS.
#'
#' This is the equivalent of `file.remove()`, but applied to an item inside iRODS.
#'
#' @param logical_path Path to the data object or collection to remove.
#' @param force Whether the data object or collection should be deleted
#'    permanently. If `FALSE`, it is sent to the trash collection. Defaults to
#'   `TRUE`.
#' @param recursive If a collection is provided, whether its contents should also be
#'    removed. If a collection is not empty and `recursive` is `FALSE`, it cannot
#'    be deleted. Defaults to `FALSE`.
#' @param verbose Whether information should be printed about the HTTP request
#'    and response. Defaults to `FALSE`.
#'
#' @return Invisibly the HTTP call.
#' @export
#'
#' @examples
#' # demonstration server (requires Bash, Docker and Docker-compose)
#' irods_demo <- try(use_irods_demo())
#'
#' if (!inherits(irods_demo, "try-error")) {
#'
#'   # move to temporary directory and save old working directory
#'   old_dir <- getwd()
#'   tmp <- tempdir()
#'   setwd(tmp)
#'
#'   # connect project to server
#'   create_irods("http://localhost/irods-rest/0.9.3", "/tempZone/home", overwrite = TRUE)
#'
#'   # authenticate
#'   iauth("rods", "rods")
#'
#'   # some data
#'   foo <- data.frame(x = c(1, 8, 9), y = c("x", "y", "z"))
#'
#'   # store
#'   isaveRDS(foo, "foo.rds")
#'
#'   # check if file is stored
#'   ils()
#'
#'   # delete object
#'   irm("foo.rds", force = TRUE)
#'
#'   # check if file is deleted
#'   ils()
#'
#'   stop_irods_demo()
#'
#'   # back to previous directory
#'   setwd(old_dir)
#' }
irm <- function(logical_path, force = TRUE, recursive = FALSE,
                verbose = FALSE) {

  # expand logical path to absolute logical path
  logical_path <- get_absolute_lpath(logical_path, open = "read")

  # flags to curl call
  args <- list(
    `logical-path` = logical_path,
    `no-trash` = as.integer(force),
    recursive = as.integer(recursive)
  )

  # http call
  out <- irods_rest_call("logicalpath", "DELETE", args, verbose)

  # response
  invisible(out)
}

#' Create a new collection in iRODS
#'
#' This is the equivalent to `dir.create()`, but creating a collection in iRODS
#' instead of a local directory.
#'
#' @param logical_path Path to the collection to create, relative to the current
#'   working directory (see `ipwd()`).
#' @param create_parent_collections Whether parent collections should be created
#'   when necessary. Defaults to `FALSE`.
#' @param verbose Whether information about the HTTP request and response
#'  should be printed. Defaults to `FALSE`.
#'
#' @return Invisibly the HTTP request.
#' @export
#'
#' @examples
#' # demonstration server (requires Bash, Docker and Docker-compose)
#' irods_demo <- try(use_irods_demo())
#'
#' if (!inherits(irods_demo, "try-error")) {
#'
#'   # move to temporary directory and save old working directory
#'   old_dir <- getwd()
#'   tmp <- tempdir()
#'   setwd(tmp)
#'
#'   # connect project to server
#'   create_irods("http://localhost/irods-rest/0.9.3", "/tempZone/home", overwrite = TRUE)
#'
#'   # authentication
#'   iauth("rods", "rods")
#'
#'   # list all object and collection in the current collection of iRODS
#'   ils()
#'
#'   # create a new collection
#'   imkdir("new_collection")
#'
#'   # check if it is there
#'   ils()
#'
#'   # and move to the new directory
#'   icd("new_collection")
#'
#'   stop_irods_demo()
#'
#'   # back to previous directory
#'   setwd(old_dir)
#' }
imkdir <- function(logical_path, create_parent_collections = FALSE, verbose = FALSE) {

  # expand logical path to absolute logical path
  logical_path <- get_absolute_lpath(logical_path)

  # flags to curl call
  # `imkdir()` will call this API end-point with collection is 1 to create new
  # collection, 0 does have no affect currently
  # https://github.com/irods/irods_client_rest_cpp/issues/185
  args <- list(
    `logical-path` = logical_path,
    collection = 1,
    `create-parent-collections` = as.integer(create_parent_collections)
  )

  # http call
  out <- irods_rest_call("logicalpath", "POST", args, verbose)

  # response
  invisible(out)
}
