# Write a PRIMER-ready CSV (samples, variables, factors, optional indicators)

Layout:

1.  First column: sample names (blank header)

2.  Variable columns (numeric)

3.  Blank separator column (blank header)

4.  Factor columns (sample metadata)

5.  Optional: a blank row, then one row per Indicator (variable
    metadata)

## Usage

``` r
write_primer_csv(
  data,
  file,
  sample_col,
  factors = NULL,
  variables = NULL,
  na_to_zero = FALSE,
  indicators = NULL,
  indicators_var_col = "variable"
)
```

## Arguments

- data:

  Data frame with at least a sample ID column and variable columns.

- file:

  Output CSV path.

- sample_col:

  Name of the column in `data` containing sample IDs.

- factors:

  Character vector of factor (sample metadata) columns (optional).

- variables:

  Character vector of variable (taxon) columns. If NULL, all columns not
  in `sample_col` or `factors` are treated as variables.

- na_to_zero:

  If TRUE, replace NA in variable columns with 0.

- indicators:

  Optional data frame of variable-level metadata to append. Must contain
  a column named by `indicators_var_col` listing variable names; all
  other columns are indicator fields (each becomes one output row).

- indicators_var_col:

  Name of the variable-name column in `indicators`.

## Value

(invisibly) a character matrix of the written data (without header).

## Details

By default, when `variables` is NULL, all columns other than
`sample_col` and `factors` are treated as taxon/variable columns. Any
such columns must be coercible to numeric; otherwise the function will
error and you should move those columns into `factors`.
