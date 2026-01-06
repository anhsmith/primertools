# AIC-like criterion for PERMANOVA models

Computes an AIC-style criterion using the residual sum-of-squares,
sample size, and number of fitted terms/parameters (v).

## Usage

``` r
aic_permanova(SS_res, N, v, round_n = 1)
```

## Arguments

- SS_res:

  Residual sum-of-squares (numeric scalar).

- N:

  Number of observations (numeric/integer scalar).

- v:

  Model complexity term (numeric/integer scalar).

- round_n:

  Round to.

## Value

A numeric scalar rounded to `round_n` decimal place.

## Examples

``` r
aic_permanova(SS_res = 130060, N = 281, v = 26)
#> [1] 1776.6
aic_permanova(SS_res = 130060, N = 281, v = 26, round_n = 2)
#> [1] 1776.61
```
