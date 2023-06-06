new_irods_df <- function(x = data.frame()) {
  validate_irods_df(x)
  structure(x, class = "irods_df")
}

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
