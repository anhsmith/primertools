# primertools


[![](https://img.shields.io/badge/docs-pkgdown-blue.svg)](https://anhsmith.github.io/primertools/)

The `primertools` package provides helper functions for preparing
datasets for import into  
**[PRIMER-e](https://www.primer-e.com)** software, and for reading
common PRIMER output files  
(e.g. PERMANOVA results) for downstream analysis in R.

`primertools` is designed to support reproducible workflows that combine
PRIMER with R.  
It does **not** reimplement PRIMER analyses.

## About PRIMER

PRIMER is a widely used software package (made by PRIMER-e) for
multivariate analysis of ecological community data.  
Although R provides packages with overlapping functionality, PRIMER
software is the authoritative implementation for the routines it
provides.

- [PRIMER-e website](https://www.primer-e.com)
- [PRIMER-e learning hub](https://learninghub.primer-e.com/books)
- [Should I use PRIMER or
  R?](https://learninghub.primer-e.com/books/should-i-use-primer-or-r)

## Installation

You can install the development version of **primertools** from GitHub
with:

``` r
# install.packages("remotes")
remotes::install_github("anhsmith/primertools")
```

``` r
library(primertools)
```
