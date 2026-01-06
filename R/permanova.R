#' Read PRIMER PERMANOVA "table of results" from a text output file
#'
#' Parses the **PERMANOVA table of results** section from a PRIMER PERMANOVA
#' text output file into a data frame.
#'
#' PRIMER prints the label for the permutations column across two lines
#' (i.e., `Unique` on one line and `perms` on the next) but they can
#' sometimes be misaligned in plain-text exports.
#' This function ignores the line with just `Unique` and simply
#' renames the `perms` column to `Unique perms` later for clarity.
#'
#' @param path Path to a PRIMER PERMANOVA text output file.
#' @param encoding File encoding passed to [readLines()]. Default `"UTF-8"`.
#'
#' @return A data frame containing the PERMANOVA results table.
#' @export
#'
#' @examples
#' f <- system.file("extdata", "PERMANOVA1.txt", package = "primertools")
#' if (file.exists(f)) {
#'   tab  <- read_permanova_results_table(f)
#'   covs <- read_permanova_components_of_variation(f)
#' }


read_permanova_results_table <- function(path, encoding = "UTF-8") {
  if (!file.exists(path)) stop("File not found: ", path, call. = FALSE)
  lines <- readLines(path, warn = FALSE, encoding = encoding)

  block <- .extract_section_block(lines, "^PERMANOVA table of results\\s*$")
  if (length(block) == 0) return(data.frame())

  df <- .parse_primer_table_block(block)

  # Rename perms -> Unique perms, if present
  if ("perms" %in% names(df)) {
    names(df)[names(df) == "perms"] <- "Unique perms"
  }

  df
}

#' Read PRIMER PERMANOVA "Estimates of components of variation" from a text output file
#'
#' Parses the **Estimates of components of variation** section from a PRIMER
#' PERMANOVA text output file into a data frame.
#'
#' @param path Path to a PRIMER PERMANOVA text output file.
#' @param encoding File encoding passed to [readLines()]. Default `"UTF-8"`.
#'
#' @return A data frame containing estimates of components of variation.
#' @export
#'
#' @examples
#' \dontrun{
#' covs <- read_permanova_components_of_variation("PM_SiteCycle.txt")
#' covs
#' }
read_permanova_components_of_variation <- function(path, encoding = "UTF-8") {
  if (!file.exists(path)) stop("File not found: ", path, call. = FALSE)
  lines <- readLines(path, warn = FALSE, encoding = encoding)

  block <- .extract_section_block(lines, "^Estimates of components of variation\\s*$")
  if (length(block) == 0) return(data.frame())

  .parse_primer_table_block(block)
}

.extract_section_block <- function(lines, header_pattern) {
  i0 <- grep(header_pattern, lines, perl = TRUE)
  if (length(i0) == 0) {
    stop(sprintf("Couldn't find section header matching pattern: %s", header_pattern), call. = FALSE)
  }
  i0 <- i0[1]

  i1 <- i0 + 1L
  while (i1 <= length(lines) && grepl("^\\s*$", lines[i1])) i1 <- i1 + 1L
  if (i1 > length(lines)) return(character())

  major_headers <- c(
    "^PERMANOVA table of results\\s*$",
    "^Estimates of components of variation\\s*$",
    "^Details of the expected mean squares",
    "^Construction of Pseudo-F ratio"
  )
  next_major <- rep(Inf, length(major_headers))
  for (k in seq_along(major_headers)) {
    hits <- grep(major_headers[k], lines, perl = TRUE)
    hits <- hits[hits > i0]
    if (length(hits)) next_major[k] <- hits[1]
  }
  i_major_end <- min(next_major)

  blank_after_start <- grep("^\\s*$", lines[i1:length(lines)])
  i_blank_end <- if (length(blank_after_start)) (i1 + blank_after_start[1] - 2L) else length(lines)

  i2 <- min(i_blank_end, i_major_end - 1L, na.rm = TRUE)
  if (!is.finite(i2) || i2 < i1) return(character())

  lines[i1:i2]
}

.parse_primer_table_block <- function(block_lines) {
  block_lines <- block_lines[!grepl("^\\s*$", block_lines)]

  i_hdr <- grep("^\\s*Source\\b", block_lines)
  if (length(i_hdr) == 0) stop("Couldn't find a header line starting with 'Source'.", call. = FALSE)
  block_lines <- block_lines[i_hdr[1]:length(block_lines)]

  block_lines <- gsub("\t", " ", block_lines)
  block_lines <- gsub("\\s+", " ", trimws(block_lines))

  df <- utils::read.table(
    text = paste(block_lines, collapse = "\n"),
    header = TRUE,
    sep = "",
    fill = TRUE,
    stringsAsFactors = FALSE,
    check.names = FALSE,
    comment.char = "",
    quote = ""
  )

  for (nm in names(df)) {
    if (nm == "Source") next
    x <- suppressWarnings(as.numeric(df[[nm]]))
    if (!all(is.na(x))) df[[nm]] <- x
  }

  df
}
