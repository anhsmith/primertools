# Extract PERMANOVA AIC components from a PRIMER PERMANOVA table

Convenience wrapper to pull residual SS and \\\nu\\ (nu) from a PRIMER
PERMANOVA table (with columns including `Source`, `SS`, `df`), and
compute an AIC-like score.

## Usage

``` r
get_permanova_aic(x, model_name = NULL, N)
```

## Arguments

- x:

  A data frame/tibble with a `Source` column and at least `SS` and `df`.
  Must contain rows named `Res` and `Total` in `Source`.

- model_name:

  Optional model label. If `NULL`, uses the name of `x`.

- N:

  Number of observations (Total df + 1 in most PRIMER contexts).

## Value

A tibble with columns `Model`, `SS_residual`, `nu`, `AIC`.

## See also

[`aic_permanova()`](https://anhsmith.github.io/primertools/reference/aic_permanova.md)
