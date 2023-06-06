#' Print method for iRODS dataframe class
#'
#' @param x An object of class `irods_df`.
#' @param ... Currently not implemented
#'
#' @return
#' @export
#'
#' @examples
print.irods_df <- function (x, ...) {
    n <- length(row.names(x))
    if (length(x) == 0L) {
      cat("This collection does not contain any objects or collections.")
    } else {
      extract_df(x, "metadata")
      extract_df(x, "permission_information")
      cat(paste0(
        "\n",
        strrep("=", 10),
        "\n",
        "iRODS Zone",
        "\n",
        strrep("=", 10),
        "\n"
      ))
      df <- data.frame(
        logical_path = x$logical_path,
        type = x$type
      )
      if (!is.null(x$status_information)) {
        df$last_write_time <- x$status_information$last_write_time
        df$size <- x$status_information$size
      }
      print(df,row.names = FALSE)
      x
    }
    invisible(x)
}

extract_df <- function(df, var) {
  if (!is.null(df[[var]])) {
    extract <- df[[var]]
    names(extract) <- df$logical_path
    print_extract(extract, var, row.names = FALSE)
  }
}

print_extract <- function(x, var, ...) {
  nn <- names(x)
  ll <- length(x)

  cat(paste0(
    "\n",
    strrep("=", nchar(var)),
    "\n",
    var,
    "\n",
    strrep("=", nchar(var)),
    "\n"
  ))
  for (i in seq_len(ll)) {
    cat(nn[i], ":\n")
    print(x[[i]], ...)
    cat("\n")
  }
}
