# Reading PRIMER SIMPER outputs

``` r
library(primertools)
```

## Overview

This vignette shows how to read a PRIMER SIMPER text output file into a
structured list of within-group and between-group contribution tables.

## Read an example file shipped with the package

``` r
simper_path <- system.file("extdata", "SIMPER1.txt", package = "primertools")
simper_path
```

    [1] "/home/runner/work/_temp/Library/primertools/extdata/SIMPER1.txt"

``` r
x <- read_simper(simper_path)

names(x)
```

    [1] "metadata" "within"   "between" 

``` r
names(x$within)
```

    [1] "B" "A" "H" "L"

``` r
names(x$between)
```

    [1] "B vs A" "B vs H" "A vs H" "B vs L" "A vs L" "H vs L"

## Within-group contributions

``` r
x$within$A
```

                      species av_abund av_sim sim_sd contrib   cum group
    1        Hiatella arctica    16.70  12.75   1.34   33.80 33.80     A
    2       Chlamys zelandiae     8.80   6.43   1.18   17.04 50.84     A
    3      Lamellaria ophione     3.85   3.40   0.82    9.01 59.85     A
    4         Xymene pusillus     4.35   3.22   1.36    8.54 68.38     A
    5 Trichomusculus barbatus     2.65   1.97   0.97    5.21 73.60     A
      avg_similarity
    1          37.72
    2          37.72
    3          37.72
    4          37.72
    5          37.72

## Between-group contributions

``` r
x$between$`A vs H`
```

                         species av_abund_1 av_abund_2 av_diss diss_sd contrib
    1           Hiatella arctica      16.70      13.20   10.18    1.07   14.76
    2          Chlamys zelandiae       8.80       7.75    6.11    1.05    8.86
    3    Trichomusculus barbatus       2.65       6.25    3.29    1.18    4.77
    4         Lamellaria ophione       3.85       0.80    3.27    0.77    4.75
    5            Xymene pusillus       4.35       1.50    3.18    1.12    4.62
    6  Pisinna olivacea impressa       2.40       4.25    3.06    0.98    4.44
    7        Borniola reniformis       3.00       3.70    2.91    1.10    4.22
    8            Eatonina micans       0.85       3.20    2.18    0.80    3.16
    9      Cantharidus purpureus       0.30       2.85    1.99    1.12    2.88
    10    Eatoniella roseocincta       1.45       2.05    1.86    0.75    2.70
    11         Crepidula costata       2.25       0.10    1.80    0.94    2.62
    12             Curveulima sp       1.95       0.60    1.67    0.66    2.42
    13    Onithochiton neglectus       2.00       1.55    1.60    0.96    2.32
    14      Fictonoba rufolactea       0.65       1.80    1.46    0.57    2.11
    15         Asteracmea suteri       1.90       0.15    1.40    0.82    2.03
    16        Modiolarca impacta       1.65       0.50    1.33    0.52    1.94
    17              Onoba fumata       1.50       0.25    1.20    0.69    1.75
         cum group1 group2 avg_dissimilarity
    1  14.76      A      H             68.94
    2  23.62      A      H             68.94
    3  28.40      A      H             68.94
    4  33.14      A      H             68.94
    5  37.76      A      H             68.94
    6  42.20      A      H             68.94
    7  46.42      A      H             68.94
    8  49.58      A      H             68.94
    9  52.46      A      H             68.94
    10 55.16      A      H             68.94
    11 57.78      A      H             68.94
    12 60.19      A      H             68.94
    13 62.52      A      H             68.94
    14 64.63      A      H             68.94
    15 66.66      A      H             68.94
    16 68.59      A      H             68.94
    17 70.34      A      H             68.94
