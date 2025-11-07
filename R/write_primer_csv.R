#' Write a PRIMER-ready CSV
#'
#' First column = samples (no header), then taxa, then a blank column, then factors.
#'
#' @param data Data frame.
#' @param file Output path to CSV.
#' @param sample_col Column name for sample IDs.
#' @param factors Character vector of factor/metadata columns.
#' @param taxa Character vector of taxa columns (if NULL, auto-detect numeric).
#' @param na_to_zero Logical; replace NA in taxa with 0.
#' @return Invisibly, the data frame written.
#' @export
write_primer_csv <- function(
    data,
    file,
    sample_col,
    factors = NULL,
    taxa = NULL,
    na_to_zero = FALSE
) {
  stopifnot(is.data.frame(data), sample_col %in% names(data))
  df <- data

  # Ensure sample names are character
  df[[sample_col]] <- as.character(df[[sample_col]])

  # Validate factors
  if (is.null(factors)) factors <- character(0)
  miss_f <- setdiff(factors, names(df))
  if (length(miss_f)) stop("Missing factor columns: ", paste(miss_f, collapse = ", "))

  # Work out taxa columns if not provided: numeric columns that aren't sample/factors
  if (is.null(taxa)) {
    candidates <- setdiff(names(df), c(sample_col, factors))
    numerics <- vapply(df[candidates], is.numeric, logical(1))
    taxa <- candidates[numerics]
  }
  miss_t <- setdiff(taxa, names(df))
  if (length(miss_t)) stop("Missing taxa columns: ", paste(miss_t, collapse = ", "))

  # Coerce taxa to numeric (error if not coercible)
  df[taxa] <- lapply(df[taxa], function(x) {
    if (!is.numeric(x)) {
      y <- suppressWarnings(as.numeric(x))
      if (any(is.na(y) & !is.na(x))) {
        stop("Non-numeric values found in taxa column after coercion.")
      }
      return(y)
    }
    x
  })

  # Optional: replace NA in taxa with zeros
  if (na_to_zero) {
    for (tt in taxa) df[[tt]][is.na(df[[tt]])] <- 0
  }

  # Build output: sample (placeholder header), taxa
  out <- data.frame(SAMPLE_ID = df[[sample_col]], df[taxa], check.names = FALSE)

  # Add separator + factors (use a placeholder name here)
  if (length(factors)) {
    blank_col <- rep("", nrow(df))
    out <- data.frame(out, BLANK_SEP__PLACEHOLDER = blank_col, df[factors], check.names = FALSE)
  }

  # Now set the headers PRIMER expects
  names(out)[1] <- ""  # sample column no header
  if (length(factors)) {
    blank_idx <- 1 + length(taxa) + 1  # after sample + taxa
    names(out)[blank_idx] <- ""        # blank separator header
  }

  # Write CSV
  utils::write.csv(out, file = file, row.names = FALSE, na = "")

  invisible(out)
}
