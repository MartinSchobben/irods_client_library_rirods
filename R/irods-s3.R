#' Coerce to a Data Frame
#'
#' Coerce iRODS Zone information class to `data.frame()`. Note that possible
#' columns of metadata consists of a list of data frames, and status_information
#' and permission_information consist of data frames.
#'
#' @param x `irods_df` class object.
#' @param ... Currently not implemented
#'
#' @return Returns a `data.frame`
#' @export
#' @keywords internal
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
#'   # store data in iRODS
#'   isaveRDS(foo, "foo.rds")
#'
#'   # add some metadata
#'
#'   imeta(
#'     "foo.rds",
#'     "data_object",
#'     operations =
#'       data.frame(operation = "add", attribute = "foo", value = "bar",
#'         units = "baz")
#'    )
#'
#'   # iRODS Zone with metadata
#'   irods_zone <- ils(metadata = TRUE)
#'
#'   # check class
#'   class(irods_zone)
#'
#'   # coerce into `data.frame` and extract metadata of "foo.rds"
#'   irods_zone <- as.data.frame(irods_zone)
#'   irods_zone[basename(irods_zone$logical_path) == "foo.rds", "metadata"]
#'
#'   stop_irods_demo()
#'
#'   # back to previous directory
#'   setwd(old_dir)
#' }
as.data.frame.irods_df <- function(x, ...) {
  class(x) <- "data.frame"
  x
}
#' iRODS Zone information class
#'
#' @keywords internal
#' @param x list with iRODS Zone information.
#'
#' @return `irods_df` class object.
new_irods_df <- function(x = list()) {
  validate_irods_df(x)
  structure(x, class = "irods_df")
}

# helpers to validate the `irods_df` class
validate_irods_df <- function(x) {

  if (!is.list(x))
    stop("iRODS class should inherit from `data.frame`.")

  irods_attributes <-
    c("logical_path",
      "metadata",
      "permission_information",
      "status_information",
      "type")
  data_values <- c("data_object", "collection")
  status_information_attributes <- c("last_write_time", "size")
  permission_information_values <- "own"
  metadata_attributes <- c("attribute", "value", "units")

  if (!all(names(x) %in% irods_attributes))
    stop("Column names of `data.frame` are unknown iRODS attributes.",
         call. = FALSE)

  if (!all(x$type %in% data_values))
    stop("Values of `type` are unknown iRODS attributes.", call. = FALSE)

  # optional attributes
  if (!is.null(x$status_information)) {
    if (!is.data.frame(x$status_information) ||
        !all(names(x$status_information) %in% status_information_attributes))
      stop("Column names of `status_information` are unknown iRODS attributes.",
           call. = FALSE)
  }

  if (!is.null(x$permission_information)) {
    if (!all(is.data.frame(x$permission_information)))
      stop("Values of `permission_information` are unknown iRODS attributes.",
           call. = FALSE)
  }

  if (!is.null(x$metadata)) {
    if (!all(is_nested_dataframe(x$metadata)) ||
        !all(get_nested_names(x$metadata) %in% metadata_attributes))
      stop("Column names of `metadata` are unknown iRODS attributes.",
           call. = FALSE)
  }
  x
}

is_nested_dataframe <- function(x) {
  vapply(x, function(x) is.data.frame(x) | length(x) == 0, logical(1))
}

get_nested_names <- function(x) {
  unique(unlist(lapply(x, names)))
}
