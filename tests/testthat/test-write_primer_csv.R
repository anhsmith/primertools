test_that("write_primer_csv: basic layout without indicators", {
  dat <- data.frame(
    Sample = c("S1","S2","S3"),
    Site   = c("A","A","B"),
    Depth  = c(5,10,5),
    SpA    = c(10, 0, 3),
    SpB    = c(2,  5, NA_real_)
  )

  tmp <- tempfile(fileext = ".csv")

  invisible(write_primer_csv(
    data = dat,
    file = tmp,
    sample_col = "Sample",
    factors = c("Site","Depth"),
    variables = c("SpA","SpB"),
    na_to_zero = FALSE
  ))

  # Header must literally be: ",SpA,SpB,,Site,Depth"
  hdr <- readLines(tmp, n = 1)
  expect_identical(hdr, ",SpA,SpB,,Site,Depth")

  # Read the DATA ONLY (skip header row)
  raw <- read.csv(tmp, header = FALSE, stringsAsFactors = FALSE, skip = 1)

  # first col = samples
  expect_identical(raw[1:3, 1], c("S1","S2","S3"))

  # variables SpA/SpB are columns 2 and 3
  expect_equal(as.numeric(raw[1, 2:3]), c(10, 2))
  expect_equal(as.numeric(raw[3, 2:3]), c(3, NA_real_))

  # factors: Site (col 5), Depth (col 6)
  expect_identical(raw[1, 5], "A")
  expect_true(raw[1, 6] %in% c("5", 5))
})


test_that("write_primer_csv: basic layout without indicators", {
  dat <- data.frame(
    Sample = c("S1","S2","S3"),
    Site   = c("A","A","B"),
    Depth  = c(5,10,5),
    SpA    = c(10, 0, 3),
    SpB    = c(2,  5, NA_real_)
  )

  tmp <- tempfile(fileext = ".csv")

  invisible(write_primer_csv(
    data = dat,
    file = tmp,
    sample_col = "Sample",
    factors = c("Site","Depth"),
    variables = c("SpA","SpB"),
    na_to_zero = TRUE
  ))

  # Header must literally be: ",SpA,SpB,,Site,Depth"
  hdr <- readLines(tmp, n = 1)
  expect_identical(hdr, ",SpA,SpB,,Site,Depth")

  # Read the DATA ONLY (skip header row)
  raw <- read.csv(tmp, header = FALSE, stringsAsFactors = FALSE, skip = 1)

  # first col = samples
  expect_identical(raw[1:3, 1], c("S1","S2","S3"))

  # variables SpA/SpB are columns 2 and 3
  expect_equal(as.numeric(raw[1, 2:3]), c(10, 2))
  expect_equal(as.numeric(raw[3, 2:3]), c(3, 0))

  # factors: Site (col 5), Depth (col 6)
  expect_identical(raw[1, 5], "A")
  expect_true(raw[1, 6] %in% c("5", 5))
})



test_that("write_primer_csv: indicators appended and aligned", {
  dat <- data.frame(
    Sample = c("S1","S2","S3"),
    Site   = c("A","A","B"),
    Depth  = c(5,10,5),
    SpA    = c(10, 0, 3),
    SpB    = c(2,  5, NA_real_)
  )
  inds <- data.frame(
    variable = c("SpA","SpB"),
    Trophic  = c("Carnivore","Omnivore"),
    Guild    = c("Reef","Reef")
  )

  tmp <- tempfile(fileext = ".csv")

  invisible(write_primer_csv(
    data = dat,
    file = tmp,
    sample_col = "Sample",
    factors = c("Site","Depth"),
    variables = c("SpA","SpB"),
    na_to_zero = TRUE,
    indicators = inds
  ))

  hdr <- readLines(tmp, n = 1)
  expect_identical(hdr, ",SpA,SpB,,Site,Depth")

  # 3 samples + 1 blank + 2 indicators = 6 rows of DATA (skip the header)
  raw <- read.csv(tmp, header = FALSE, stringsAsFactors = FALSE, skip = 1)
  expect_equal(nrow(raw), 6)

  # Row 4 is the blank separator row
  r4 <- unlist(raw[4, ])
  expect_true(all(is.na(r4) | r4 == ""))

  # Indicator labels in first column
  expect_identical(raw[5, 1], "Trophic")
  expect_identical(raw[6, 1], "Guild")

  # Indicator values under variable columns (2 and 3)
  expect_identical(unname(unlist(raw[5, 2:3])), c("Carnivore", "Omnivore"))
  expect_identical(unname(unlist(raw[6, 2:3])), c("Reef", "Reef"))

  # Right-hand cells under indicators are blank/NA (sep + factors)
  expect_true(all(is.na(raw[5, 4:6]) | raw[5, 4:6] == ""))
  expect_true(all(is.na(raw[6, 4:6]) | raw[6, 4:6] == ""))
})
