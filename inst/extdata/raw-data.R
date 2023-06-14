# path to external files
pt <- system.file("extdata", package = "rirods")

# creates a csv file of foo
foo <- data.frame(x = c(1, 8, 9), y = c("x", "y", "z"))
readr::write_csv(foo, file.path(pt, "foo.csv"))

# small file
dfr <- data.frame(a = c("a", "b", "c"), b = 1:3, c = 6:8)
readr::write_csv(dfr, file.path(pt, "dfr.csv"))

# large file
mt <- data.frame(x = 1:1000)
readr::write_csv(as.data.frame(mt), file.path(pt, "mt.csv"))
