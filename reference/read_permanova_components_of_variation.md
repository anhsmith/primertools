# Read PRIMER PERMANOVA "Estimates of components of variation" from a text output file

Parses the **Estimates of components of variation** section from a
PRIMER PERMANOVA text output file into a data frame.

## Usage

``` r
read_permanova_components_of_variation(path, encoding = "UTF-8")
```

## Arguments

- path:

  Path to a PRIMER PERMANOVA text output file.

- encoding:

  File encoding passed to
  [`readLines()`](https://rdrr.io/r/base/readLines.html). Default
  `"UTF-8"`.

## Value

A data frame containing estimates of components of variation.

## Examples

``` r
if (FALSE) { # \dontrun{
covs <- read_permanova_components_of_variation("PM_SiteCycle.txt")
covs
} # }
```
