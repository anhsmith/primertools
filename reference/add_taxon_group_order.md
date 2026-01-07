# Add a within-facet ordering variable for SIMPER plots

ggplot2 orders factors globally, so faceted SIMPER plots need a
plotting-only factor that is ordered within each group. This function
adds `taxon_group`.

## Usage

``` r
add_taxon_group_order(
  d_within,
  group_var = "group",
  taxon_var = "taxon",
  order_var = "contrib",
  decreasing = TRUE
)
```

## Arguments

- d_within:

  A tibble from
  [`tidy_simper_within()`](https://anhsmith.github.io/primertools/reference/tidy_simper_within.md).

- group_var:

  Column name giving the facet/group (default `group`).

- taxon_var:

  Column name giving the taxon label (default `taxon`).

- order_var:

  Column used to order taxa within group (default `contrib`).

- decreasing:

  If TRUE (default), order from largest to smallest.

## Value

The same tibble with an additional factor column `taxon_group`.

## Examples

``` r
# d_within <- tidy_simper_within(simper_site_cp)
# d_within <- add_taxon_group_order(d_within)
```
