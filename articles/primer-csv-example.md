# Creating a PRIMER-ready CSV

``` r
# install.packages("remotes")
# remotes::install_github("anhsmith/primertools")

library(primertools)
```

This vignette demonstrates how to create a PRIMER-ready CSV file using
[`write_primer_csv()`](https://anhsmith.github.io/primertools/reference/write_primer_csv.md).

## 1 Writing a PRIMER-ready CSV with factors only

### 1.1 Make example data

``` r
dat <- data.frame(
  Sample = c("S1", "S2", "S3"),
  Site   = c("A", "A", "B"),
  Depth  = c(5, 10, 5),
  SpA    = c(10, 0, 3),
  SpB    = c(2, 5, NA_real_)
)
```

### 1.2 Display example data

``` r
dat
```

      Sample Site Depth SpA SpB
    1     S1    A     5  10   2
    2     S2    A    10   0   5
    3     S3    B     5   3  NA

### 1.3 Create a temporary file to write the CSV to

``` r
tmpfile <- "forprimer.csv"
```

### 1.4 Write the PRIMER-ready CSV

``` r
write_primer_csv(
  data = dat,
  file = tmpfile,
  sample_col = "Sample",
  factors = c("Site", "Depth"),
  variables = c("SpA", "SpB"),
  na_to_zero = TRUE
)
```

    Wrote PRIMER-ready CSV: forprimer.csv

### 1.5 Display the contents of the written CSV file

``` r
cat(readLines(tmpfile), sep = "\n")
```

    ,SpA,SpB,,Site,Depth
    S1,10,2,,A,5
    S2,0,5,,A,10
    S3,3,0,,B,5

### 1.6 Show output as a table

``` r
out <- read.csv(tmpfile, check.names = FALSE, as.is = TRUE)
out
```

         SpA SpB    Site Depth
    1 S1  10   2 NA    A     5
    2 S2   0   5 NA    A    10
    3 S3   3   0 NA    B     5

## 2 Writing a PRIMER-ready CSV with factors and indicators

### 2.1 Define indicators for the variables

``` r
inds <- data.frame(
  variable = c("SpA", "SpB"),
  Trophic  = c("Carnivore", "Omnivore"),
  Guild    = c("Reef", "Reef")
)
```

### 2.2 Show indicators

``` r
inds
```

      variable   Trophic Guild
    1      SpA Carnivore  Reef
    2      SpB  Omnivore  Reef

### 2.3 Create a temporary file to write the CSV to

``` r
tmpfile <- "forprimer_ind.csv"
```

### 2.4 Write the PRIMER-ready CSV

``` r
write_primer_csv(
  data = dat,
  file = tmpfile,
  sample_col = "Sample",
  factors = c("Site", "Depth"),
  variables = c("SpA", "SpB"),
  na_to_zero = TRUE,
  indicators = inds,
  indicators_var_col = "variable"
)
```

    Wrote PRIMER-ready CSV: forprimer_ind.csv

### 2.5 Display the contents of the written CSV file

``` r
cat(readLines(tmpfile), sep = "\n")
```

    ,SpA,SpB,,Site,Depth
    S1,10,2,,A,5
    S2,0,5,,A,10
    S3,3,0,,B,5
    ,,,,,
    Trophic,Carnivore,Omnivore,,,
    Guild,Reef,Reef,,,

### 2.6 Show output as a table

``` r
out <- read.csv(tmpfile, check.names = FALSE, as.is = TRUE)
out
```

                    SpA      SpB    Site Depth
    1      S1        10        2 NA    A     5
    2      S2         0        5 NA    A    10
    3      S3         3        0 NA    B     5
    4                            NA         NA
    5 Trophic Carnivore Omnivore NA         NA
    6   Guild      Reef     Reef NA         NA

## 3 Notes

- `na_to_zero = TRUE` replaces missing values with 0.
- The output has a blank first column header and a blank separator
  column.
- Indicators are added below, aligned with variable columns.
