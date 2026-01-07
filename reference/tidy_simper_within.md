# Tidy a SIMPER object (within-group tables)

Convert a `primertools` SIMPER object into a single tibble for
within-group results, optionally truncating by cumulative contribution.

## Usage

``` r
tidy_simper_within(simper_obj, cum_max = 70)
```

## Arguments

- simper_obj:

  A SIMPER object produced by `primertools` (must contain `$within`).

- cum_max:

  Cumulative cutoff (percent). Keep rows with `cum <= cum_max`.

## Value

A tibble with one row per taxon per group.

## Examples

``` r
# d_within <- tidy_simper_within(simper_site_cp, cum_max = 70)
```
