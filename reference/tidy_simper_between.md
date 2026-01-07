# Tidy a SIMPER object (between-group tables)

Convert a `primertools` SIMPER object into a single tibble for
between-group results, optionally truncating by cumulative contribution.

## Usage

``` r
tidy_simper_between(simper_obj, cum_max = 70)
```

## Arguments

- simper_obj:

  A SIMPER object produced by `primertools` (must contain `$between`).

- cum_max:

  Cumulative cutoff (percent). Keep rows with `cum <= cum_max`.

## Value

A tibble with one row per taxon per contrast.

## Examples

``` r
# d_between <- tidy_simper_between(simper_site_cp, cum_max = 60)
```
