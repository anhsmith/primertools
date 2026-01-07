# Read a PRIMER SIMPER text output file (one-way)

Parses PRIMER SIMPER output into:

- metadata:

  Named list of header fields found in the file.

- within:

  Named list of data.frames, one per group (within-group similarities).

- between:

  Named list of data.frames, one per pair (between-group
  dissimilarities).

## Usage

``` r
read_simper(path)
```

## Arguments

- path:

  Path to a PRIMER SIMPER text output file.

## Value

A named list with elements `metadata`, `within`, `between`.

## Details

This reader targets the one-way SIMPER layout where within-group blocks
start with lines like "Group A" and between-group blocks start with
lines like "Groups A & B".

## Examples

``` r
f <- system.file("extdata", "SIMPER1.txt", package = "primertools")
x <- read_simper(f)
names(x$within)
#> [1] "B" "A" "H" "L"
names(x$between)
#> [1] "B vs A" "B vs H" "A vs H" "B vs L" "A vs L" "H vs L"
head(x$within[[1]])
#>                     species av_abund av_sim sim_sd contrib   cum group
#> 1   Trichomusculus barbatus     5.05   6.33   1.00   21.75 21.75     B
#> 2          Hiatella arctica     3.70   4.59   1.31   15.76 37.51     B
#> 3    Eatoniella roseocincta     5.35   3.32   0.70   11.42 48.93     B
#> 4 Pisinna olivacea impressa     3.65   2.50   0.74    8.61 57.53     B
#> 5       Borniola reniformis     5.20   2.20   0.53    7.55 65.08     B
#> 6  Eatoniella albocolumella     2.00   2.12   0.67    7.29 72.38     B
#>   avg_similarity
#> 1           29.1
#> 2           29.1
#> 3           29.1
#> 4           29.1
#> 5           29.1
#> 6           29.1
head(x$between[[1]])
#>                   species av_abund_1 av_abund_2 av_diss diss_sd contrib   cum
#> 1        Hiatella arctica       3.70      16.70   12.55    1.14   16.11 16.11
#> 2       Chlamys zelandiae       0.85       8.80    7.46    1.03    9.57 25.68
#> 3     Borniola reniformis       5.20       3.00    4.62    0.95    5.92 31.60
#> 4  Eatoniella roseocincta       5.35       1.45    4.47    0.88    5.73 37.34
#> 5 Trichomusculus barbatus       5.05       2.65    4.11    0.90    5.28 42.61
#> 6      Lamellaria ophione       0.45       3.85    4.10    0.85    5.26 47.87
#>   group1 group2 avg_dissimilarity
#> 1      B      A             77.93
#> 2      B      A             77.93
#> 3      B      A             77.93
#> 4      B      A             77.93
#> 5      B      A             77.93
#> 6      B      A             77.93
```
