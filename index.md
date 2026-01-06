# primertools

[![](https://img.shields.io/badge/docs-pkgdown-blue.svg)](https://anhsmith.github.io/primertools/)

This packages contains some helper functions for preparing datasets for
import into **[PRIMER-e](https://www.primer-e.com)** software, and for
reading common PRIMER output files (e.g., PERMANOVA results) for
downstream analysis in R.

## About PRIMER

PRIMER is a widely used software package for multivariate analysis of
ecological community data. Although there are some packages in R that
provide similar functionality, PRIMER software is the authoritative tool
for the routines it provides.

- [PRIMER-e website](https://www.primer-e.com)
- [PRIMER-e learning hub](https://learninghub.primer-e.com/books)
- [Should I use PRIMER or
  R?](https://learninghub.primer-e.com/books/should-i-use-primer-or-r)

## Scope

`primertools` is designed to support reproducible workflows that combine
PRIMER with R.  
It does **not** reimplement PRIMER analyses, but focuses on:

- writing PRIMER-ready data files from R
- reading and tidying PRIMER output for further analysis, plotting, or
  reporting

## Installation

You can install the development version of **primertools** from GitHub
with:

``` r
# install.packages("remotes")
remotes::install_github("anhsmith/primertools")
```

``` r
library(primertools)
# example usage here
```
