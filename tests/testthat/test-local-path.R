test_that("warm about potential overwrite", {
  expect_error(stop_local_overwrite(FALSE, "testthat.irods"))
})

test_that("files can be chunked", {

  # test object to be split
  x <- matrix(1:100)

  # chunk object from raw vector
  chunks <- chunk_object(serialize(x, NULL), 10L)

  # reversed operation
  xc <- fuse_object(chunks[[1]])
  y <- unserialize(xc)

  expect_equal(x, y)
})

test_that("chunk size can be calculated",{
  expect_snapshot(calc_chunk_size(39, 10L))
})
