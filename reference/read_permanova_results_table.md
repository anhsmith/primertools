# Read PRIMER PERMANOVA "table of results" from a text output file

Parses the **PERMANOVA table of results** section from a PRIMER
PERMANOVA text output file into a data frame.

## Usage

``` r
read_permanova_results_table(path, encoding = "UTF-8")
```

## Arguments

- path:

  Path to a PRIMER PERMANOVA text output file.

- encoding:

  File encoding passed to
  [`readLines()`](https://rdrr.io/r/base/readLines.html). Default
  `"UTF-8"`.

## Value

A data frame containing the PERMANOVA results table.

## Details

PRIMER prints the label for the permutations column across two lines
(i.e., `Unique` on one line and `perms` on the next) but they can
sometimes be misaligned in plain-text exports. This function ignores the
line with just `Unique` and simply renames the `perms` column to
`Unique perms` later for clarity.

## Examples

``` r
f <- system.file("extdata", "PERMANOVA1.txt", package = "primertools")
if (file.exists(f)) {
  tab  <- read_permanova_results_table(f)
  covs <- read_permanova_components_of_variation(f)
}
```
