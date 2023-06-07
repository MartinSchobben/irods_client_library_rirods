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

    if (length(x) == 0L) {
      cat("This collection does not contain any objects or collections.")
    } else {
      df <- extract_df(x, "metadata")
      df <- extract_df(df, "status_information")
      df <- extract_df(df, "permission_information")
      cat(paste0(
        "\n",
        strrep("=", 10),
        "\n",
        "iRODS Zone",
        "\n",
        strrep("=", 10),
        "\n"
      ))
      print(as.data.frame(df), row.names = FALSE)
      x
    }
    invisible(x)
}

extract_df <- function(df, var) {
  if (!is.null(extract <- df[[var]] )) {
    remainder <- df[names(df) != var]
    if (class(extract) == "data.frame") {
      df <- cbind(remainder, extract)
    } else if (class(extract) == "list") {
      names(extract) <- df$logical_path
      print_extract(extract, var, row.names = FALSE)
      df <- remainder
    }
  }
  df
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
