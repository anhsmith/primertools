#' Write a PRIMER-ready CSV (samples, variables, factors, optional indicators)
#'
#' Layout:
#'   1) First column: sample names (blank header)
#'   2) Variable columns (numeric)
#'   3) Blank separator column (blank header)
#'   4) Factor columns (sample metadata)
#'   5) Optional: a blank row, then one row per Indicator (variable metadata)
#'
#' @param data Data frame with at least a sample ID column and variable columns.
#' @param file Output CSV path.
#' @param sample_col Name of the column in `data` containing sample IDs.
#' @param factors Character vector of factor (sample metadata) columns (optional).
#' @param variables Character vector of variable (taxon) columns. If NULL,
#'   all columns not in `sample_col` or `factors` are treated as variables.
#' @param na_to_zero If TRUE, replace NA in variable columns with 0.
#' @param indicators Optional data frame of variable-level metadata to append.
#'   Must contain a column named by `indicators_var_col` listing variable names;
#'   all other columns are indicator fields (each becomes one output row).
#' @param indicators_var_col Name of the variable-name column in `indicators`.
#' @return (invisibly) a character matrix of the written data (without header).
#' @details
#' By default, when `variables` is NULL, all columns other than `sample_col`
#' and `factors` are treated as taxon/variable columns. Any such columns must
#' be coercible to numeric; otherwise the function will error and you should
#' move those columns into `factors`.

#' @export
write_primer_csv <- function(
    data,
    file,
    sample_col,
    factors = NULL,
    variables = NULL,
    na_to_zero = FALSE,
    indicators = NULL,
    indicators_var_col = "variable"
) {
  stopifnot(is.data.frame(data), sample_col %in% names(data))
  df <- data

  # Normalize factors to character (labels)
  if (is.null(factors)) factors <- character(0) else {
    miss_f <- setdiff(factors, names(df))
    if (length(miss_f)) stop("Missing factor columns: ", paste(miss_f, collapse = ", "))
    df[factors] <- lapply(df[factors], function(x) as.character(if (is.factor(x)) as.character(x) else x))
  }

  # Determine variables (all non-sample, non-factor columns if not supplied)
  if (is.null(variables)) {
    # By default, assume any column that is not the sample ID and not a factor
    # is a taxon/variable column.
    variables <- setdiff(names(df), c(sample_col, factors))
  } else {
    miss_v <- setdiff(variables, names(df))
    if (length(miss_v)) stop("Missing variable columns: ", paste(miss_v, collapse = ", "))
  }

  if (!length(variables)) {
    stop(
      "No variable columns found. Either:\n",
      "  * supply `variables =` explicitly, or\n",
      "  * ensure there are columns other than `sample_col` and `factors`."
    )
  }

  # Coerce variables to numeric
  df[variables] <- lapply(df[variables], function(x) {
    if (is.numeric(x)) return(x)
    y <- suppressWarnings(as.numeric(x))
    if (any(is.na(y) & !is.na(x))) stop("Non-numeric values in a variable column after coercion.")
    y
  })

  # Build header vector (what PRIMER/Excel should see)
  header <- c(
    "",                              # blank header for samples
    variables,                       # variables
    if (length(factors)) c("", factors) else character(0)  # blank sep + factors
  )

  # Column indices in the matrix
  has_factors <- length(factors) > 0
  n_vars <- length(variables)
  sample_col_idx <- 1L
  var_col_idx <- if (n_vars) (2L):(1L + n_vars) else integer(0)
  sep_col_idx <- if (has_factors) 1L + n_vars + 1L else integer(0)
  fact_col_idx <- if (has_factors) (sep_col_idx + 1L):(sep_col_idx + length(factors)) else integer(0)

  # Core rows count
  n_core <- nrow(df)

  # Prepare the core matrix (character)
  n_cols <- length(header)
  core_mat <- matrix("", nrow = n_core, ncol = n_cols)
  colnames(core_mat) <- header  # includes the two blanks

  # Fill sample IDs
  core_mat[, sample_col_idx] <- as.character(df[[sample_col]])

  # Fill variables (NA -> "" or "0")
  for (j in seq_len(n_vars)) {
    v <- df[[variables[j]]]
    if (na_to_zero) {
      v[is.na(v)] <- 0
    }
    core_mat[, var_col_idx[j]] <- as.character(v)
  }

  # Fill factors
  if (has_factors) {
    # separator column remains "" (already)
    for (k in seq_along(factors)) {
      core_mat[, fact_col_idx[k]] <- as.character(df[[factors[k]]])
    }
  }

  # Indicators block
  ind_mat <- NULL
  if (!is.null(indicators)) {
    stopifnot(is.data.frame(indicators))
    if (!(indicators_var_col %in% names(indicators))) {
      stop("`indicators_var_col` ('", indicators_var_col, "') not found in `indicators`.")
    }
    ind_cols <- setdiff(names(indicators), indicators_var_col)
    if (!length(ind_cols)) stop("`indicators` must contain at least one indicator column.")

    # Align indicators to variable order
    idx <- match(variables, indicators[[indicators_var_col]])
    aligned <- indicators[idx, ind_cols, drop = FALSE]

    # Build (1 blank row + one per indicator field)
    n_ind_rows <- 1L + length(ind_cols)
    ind_mat <- matrix("", nrow = n_ind_rows, ncol = n_cols)
    colnames(ind_mat) <- header

    # Row 1 is blank separator row (already "")

    # Subsequent rows: indicator name in first column; values under variable cols
    for (r in seq_along(ind_cols)) {
      ind_name <- ind_cols[r]
      row_i <- 1L + r
      ind_mat[row_i, sample_col_idx] <- ind_name
      vals <- as.character(aligned[[ind_name]])
      vals[is.na(vals)] <- ""
      if (length(vals) != n_vars) {
        # pad or trim to n_vars defensively
        length(vals) <- n_vars
        vals[is.na(vals)] <- ""
      }
      ind_mat[row_i, var_col_idx] <- vals
      # sep + factor columns remain ""
    }
  }

  # Combine
  out_mat <- if (is.null(ind_mat)) core_mat else rbind(core_mat, ind_mat)

  # Write: manual header, then matrix without column names
  con <- file(file, open = "wb")
  on.exit(close(con), add = TRUE)
  cat(paste(header, collapse = ","), "\n", file = con, sep = "")
  utils::write.table(
    out_mat, file = con, sep = ",",
    row.names = FALSE, col.names = FALSE,
    na = "", quote = FALSE, qmethod = "double"
  )

  message("Wrote PRIMER-ready CSV: ", file)
  invisible(out_mat)
}
