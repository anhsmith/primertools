test_that("multiplication works", {
  expect_equal(2 * 2, 4)
})


test_that("write_primer_csv writes a valid PRIMER-style CSV", {
  dat <- data.frame(
    Sample = c("S1","S2","S3"),
    Site   = c("A","A","B"),
    Depth  = c(5,10,5),
    SpA    = c(10, 0, 3),
    SpB    = c(2,  5, NA_real_)
  )

  tmp <- tempfile(fileext = ".csv")

  write_primer_csv(
    data = dat,
    file = tmp,
    sample_col = "Sample",
    factors = c("Site","Depth"),
    taxa = c("SpA","SpB"),
    na_to_zero = TRUE
  )

  expect_true(file.exists(tmp))

  # Read back preserving headers exactly
  out <- read.csv(tmp, check.names = FALSE, stringsAsFactors = FALSE)

  # Headers: sample col blank, taxa, blank sep, factors
  expect_identical(
    names(out),
    c("", "SpA", "SpB", "", "Site", "Depth")
  )

  # Taxa first row as numeric vector
  expect_equal(
    unname(as.numeric(unlist(out[1, c("SpA","SpB")]))),
    c(10, 2)
  )

  # Factors copied correctly
  expect_identical(out$Site[1], "A")
  expect_identical(out$Depth[1], 5L)

  # Sample names survived roundtrip
  # (the first column header is "", so refer by position)
  expect_identical(out[[1]][1:3], c("S1","S2","S3"))
})
