# stop overwriting
stop_local_overwrite <- function(overwrite, x) {
  if (isFALSE(overwrite)) {
    if (file.exists(x)) {
      stop(
        "Local file aready exists.",
        " Set `overwrite = TRUE` to explicitly overwrite the file.",
        call. = FALSE
      )
    }
  }
}

# chunk object (this needs to be a raw vector -> use serialize(x, NULL) for R
# object and readBIN for other file types)
chunk_object <- function(object, count) {

  # chunk sizes
  size <- length(object)
  x <- calc_chunk_size(size, count)

  # chunk data
  object_splits <- split(object, x[[1]])

  list(object_splits, x[[2]], x[[3]])
}

# fuse object after chunking (this will be a raw vector from irods)
fuse_object <- function(x) {
  Reduce(append, x)
}

# calculate chunk sizes
calc_chunk_size <- function (object_size, count) {
  # try to find the number of chunks
  n <- object_size %/% count
  st <- sort(1:object_size %% n)
  # count
  ct <- as.integer(table(st))
  # offset
  of <- c(0, cumsum(ct)[1:length(ct)-1])
  list(st, of, ct)
}
