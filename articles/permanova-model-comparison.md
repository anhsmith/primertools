# Comparing PRIMER PERMANOVA models with an AIC-like criterion

``` r
library(primertools)
```

## Overview

PRIMER PERMANOVA is commonly used to assess the relative importance of
space, time, and their interactions in multivariate community data.

This vignette demonstrates how to use two helper functions in
**primertools** to compute an AIC-like criterion for PERMANOVA models:

- [`aic_permanova()`](https://anhsmith.github.io/primertools/reference/aic_permanova.md)
  — computes the criterion from summary quantities
- [`get_permanova_aic()`](https://anhsmith.github.io/primertools/reference/get_permanova_aic.md)
  — extracts those quantities directly from a PRIMER PERMANOVA results
  table

The intent is **model comparison**, not hypothesis testing.

## Background

An AIC-style score for PERMANOVA models can be computed as:

$${AIC} = N\log\left( SS_{\text{res}}/N \right) + 2\nu$$

where:

- $N$ is the number of observations
- $SS_{res}$ is the residual sum of squares
- $\nu$ is the effective number of fitted terms, computed as  
  `Total df − Residual df`

Lower values indicate better-supported models, conditional on the same
response data and distance measure.

## Example PRIMER PERMANOVA output

The package ships with a small example PERMANOVA output file:

``` r
f <- system.file("extdata", "PERMANOVA1.txt", package = "primertools")
```

## Read the PERMANOVA results table

We first extract the PERMANOVA table of results.

``` r
tab <- read_permanova_results_table(f)
tab
```

          Source df     SS      MS Pseudo-F P(perm) Unique perms
    1         Lo  3  35564 11855.0   2.8086  0.0093          105
    2     Si(Lo)  4  16883  4220.8   1.3564  0.0381         9849
    3 Ar(Si(Lo))  8  24895  3111.8   1.2320  0.0076         9716
    4        Res 64 161650  2525.7       NA      NA           NA
    5      Total 79 238990      NA       NA      NA           NA

This table must contain, at minimum:

- a `Source` column
- degrees of freedom (`df`)
- sums of squares (`SS`)
- rows labelled `Total` and `Res`

## Compute an AIC-like score directly

In PRIMER outputs, the number of observations (N) is typically
`Total df + 1`.

``` r
N <- tab$df[tab$Source == "Total"] + 1

get_permanova_aic(tab, N = N)
```

    # A tibble: 1 × 4
      Model SS_residual    nu   AIC
      <chr>       <dbl> <dbl> <dbl>
    1 tab        161650    15  639.

The returned tibble contains:

- `Model` — the object name (or user-supplied label)
- `SS_residual` — residual sum of squares
- `nu` — effective model complexity
- `AIC` — AIC-like score (rounded by default)

## Manual computation (optional)

If you already know the relevant quantities, you can call
[`aic_permanova()`](https://anhsmith.github.io/primertools/reference/aic_permanova.md)
directly:

``` r
SS_res <- tab$SS[tab$Source == "Res"]
nu     <- tab$df[tab$Source == "Total"] - tab$df[tab$Source == "Res"]

aic_permanova(SS_res, N = N, v = nu)
```

    [1] 638.9

## Comparing multiple models

These helpers are designed to be used across *multiple PERMANOVA models*
fitted to the same data.

In practice, users typically:

1.  Fit several alternative PERMANOVA models in PRIMER
2.  Export each PERMANOVA table
3.  Read each table into R
4.  Combine results into a single comparison table

This structure should work naturally with
[`purrr::map_dfr()`](https://purrr.tidyverse.org/reference/map_dfr.html).

## Notes and cautions

- This criterion is intended for **relative model comparison**, not
  formal inference.
- Models must be fitted to the **same response data** using the **same
  distance measure**.
- Absolute AIC values are not meaningful—only differences between
  models.

## See also

- The vignette *“Reading PRIMER PERMANOVA outputs”* for details on
  parsing PRIMER text files.
- [`?aic_permanova`](https://anhsmith.github.io/primertools/reference/aic_permanova.md)
- [`?get_permanova_aic`](https://anhsmith.github.io/primertools/reference/get_permanova_aic.md)
