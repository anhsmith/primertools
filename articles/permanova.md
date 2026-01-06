# Reading PRIMER PERMANOVA outputs

``` r
library(primertools)
```

## Overview

This vignette demonstrates how to extract key results from a PRIMER
PERMANOVA text output file using `primertools`.

Specifically, we show how to read:

- the *PERMANOVA table of results*
- the *estimates of components of variation*

## Example PERMANOVA file

The package ships with a small example PERMANOVA output file.

``` r
f <- system.file("extdata", "PERMANOVA1.txt", package = "primertools")

cat(readLines(f), sep = "\n")
```

    PERMANOVA
    Permutational MANOVA

    Resemblance worksheet
    Name: Resem1
    Data type: Similarity
    Selection: All
    Resemblance: S7 Jaccard

    Sums of squares type: Type III (partial)
    Fixed effects sum to zero for mixed terms
    Permutation method: Permutation of residuals under a reduced model
    Number of permutations: 9999

    Factors
    Name    Abbrev. Type    Levels
    Location    Lo  Random       4
    Site    Si  Random       8
    Area    Ar  Random      16

    PERMANOVA table of results
                                                    Unique
    Source  df          SS      MS  Pseudo-F    P(perm)  perms
    Lo   3       35564   11855    2.8086     0.0093    105
    Si(Lo)   4       16883  4220.8    1.3564     0.0381   9849
    Ar(Si(Lo))   8       24895  3111.8     1.232     0.0076   9716
    Res 64  1.6165E+05  2525.7
    Total   79  2.3899E+05

    Details of the expected mean squares (EMS) for the model
    Source  EMS
    Lo  1*V(Res) + 5*V(Ar(Si(Lo))) + 10*V(Si(Lo)) + 20*V(Lo)
    Si(Lo)  1*V(Res) + 5*V(Ar(Si(Lo))) + 10*V(Si(Lo))
    Ar(Si(Lo))  1*V(Res) + 5*V(Ar(Si(Lo)))
    Res 1*V(Res)

    Construction of Pseudo-F ratio(s) from mean squares
    Source  Numerator   Denominator Num.df  Den.df
    Lo  1*Lo    1*Si(Lo)         3       4
    Si(Lo)  1*Si(Lo)    1*Ar(Si(Lo))         4       8
    Ar(Si(Lo))  1*Ar(Si(Lo))    1*Res        8      64

    Estimates of components of variation
    Source  Estimate    Sq.root
    V(Lo)     381.69     19.537
    V(Si(Lo))      110.9     10.531
    V(Ar(Si(Lo)))     117.22     10.827
    V(Res)    2525.7     50.257

## PERMANOVA table of results

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

## Components of variation

``` r
covs <- read_permanova_components_of_variation(f)
covs
```

             Source Estimate Sq.root
    1         V(Lo)   381.69  19.537
    2     V(Si(Lo))   110.90  10.531
    3 V(Ar(Si(Lo)))   117.22  10.827
    4        V(Res)  2525.70  50.257

## Notes

- These functions are designed for PRIMER v7–v8 text outputs.
- They ignore auxiliary sections such as EMS tables and pseudo-F
  constructions.
- The word “Unique” is added to the `Unique perms` column manually
  (because the “Unique” is dropped when reading the table).
