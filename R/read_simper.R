#' Read a PRIMER SIMPER text output file (one-way)
#'
#' Parses PRIMER SIMPER output into:
#' \describe{
#'   \item{metadata}{Named list of header fields found in the file.}
#'   \item{within}{Named list of data.frames, one per group (within-group similarities).}
#'   \item{between}{Named list of data.frames, one per pair (between-group dissimilarities).}
#' }
#'
#' This reader targets the one-way SIMPER layout where within-group blocks start
#' with lines like "Group A" and between-group blocks start with lines like
#' "Groups A & B".
#'
#' @param path Path to a PRIMER SIMPER text output file.
#'
#' @return A named list with elements `metadata`, `within`, `between`.
#' @export
#'
#' @examples
#' f <- system.file("extdata", "SIMPER1.txt", package = "primertools")
#' x <- read_simper(f)
#' names(x$within)
#' names(x$between)
#' head(x$within[[1]])
#' head(x$between[[1]])
read_simper <- function(path) {
  lines <- readLines(path, warn = FALSE, encoding = "UTF-8")

  trim <- function(x) trimws(x)

  # ---- metadata (safe if fields absent) ---------------------------------
  metadata <- list(
    resemblance = trim(grep("^Resemblance:", lines, value = TRUE)),
    cutoff      = trim(grep("^Cut off", lines, value = TRUE)),
    data_name   = trim(grep("^Name:", lines, value = TRUE)),
    data_type   = trim(grep("^Data type:", lines, value = TRUE)),
    analysis    = trim(grep("^One-Way Analysis", lines, value = TRUE))
  )

  # ---- helpers ----------------------------------------------------------
  to_num <- function(x) suppressWarnings(as.numeric(gsub("%", "", x)))

  # Parse a data row by taking the LAST n numeric-ish tokens as columns;
  # everything before that is species (so species names can contain spaces).
  parse_line_last_numeric <- function(line, n_numeric) {
    line <- trim(line)
    if (!nzchar(line)) return(NULL)

    # skip header-ish rows
    if (grepl("^Species\\s+", line)) return(NULL)
    if (grepl("^Group(s)?\\b", line)) return(NULL)
    if (grepl("^Average\\s+(dis)?similarity", line)) return(NULL)

    parts <- strsplit(line, "\\s+")[[1]]
    if (length(parts) < (n_numeric + 1)) return(NULL)

    nums <- utils::tail(parts, n_numeric)
    sp   <- paste(utils::head(parts, length(parts) - n_numeric), collapse = " ")

    c(species = sp, nums)
  }

  # Starting from a block header line index (Group ... or Groups ...),
  # find the subsequent "Species ..." header row and return all table
  # lines until the next block or EOF.
  grab_table_lines <- function(start_idx) {
    if (start_idx >= length(lines)) return(character())

    # find header row "Species ..."
    hdr_rel <- which(grepl("^\\s*Species\\s+", lines[(start_idx + 1):length(lines)]))
    if (!length(hdr_rel)) return(character())
    hdr_idx <- start_idx + hdr_rel[1]

    data_start <- hdr_idx + 1L
    if (data_start > length(lines)) return(character())

    # stop at next "Group ..." OR "Groups ..."
    next_block_rel <- which(grepl("^\\s*Group\\b|^\\s*Groups\\b", lines[data_start:length(lines)]))
    data_end <- if (length(next_block_rel)) (data_start + next_block_rel[1] - 2L) else length(lines)

    if (data_end < data_start) return(character())
    lines[data_start:data_end]
  }

  # ---- detect blocks (CRITICAL FIX HERE) --------------------------------
  # Within-group blocks are ONLY lines like: "Group A" (single token group label).
  within_starts  <- grep("^\\s*Group\\s+\\S+\\s*$", lines)

  # Between-group blocks are lines like: "Groups A & B"
  between_starts <- grep("^\\s*Groups\\s+.+\\s+&\\s+.+\\s*$", lines)

  # ---- parse within blocks ----------------------------------------------
  within <- list()

  for (i in within_starts) {
    grp <- trim(sub("^\\s*Group\\s+", "", lines[i]))

    # find "Average similarity:" in the next few lines
    avg_window <- lines[(i + 1):min(length(lines), i + 10)]
    avg_window <- avg_window[nzchar(trimws(avg_window))]
    avg_line <- avg_window[grep("^Average similarity:", avg_window)][1]
    avg_sim <- to_num(sub(".*:\\s*", "", avg_line))

    tbl_lines <- grab_table_lines(i)
    rows <- lapply(tbl_lines, parse_line_last_numeric, n_numeric = 5)
    rows <- Filter(Negate(is.null), rows)

    if (!length(rows)) {
      within[[grp]] <- data.frame()
      next
    }

    mat <- do.call(rbind, rows)

    df <- data.frame(
      species  = mat[, "species"],
      av_abund = to_num(mat[, 2]),
      av_sim   = to_num(mat[, 3]),
      sim_sd   = to_num(mat[, 4]),
      contrib  = to_num(mat[, 5]),
      cum      = to_num(mat[, 6]),
      group = grp,
      avg_similarity = avg_sim,
      stringsAsFactors = FALSE
    )

    within[[grp]] <- df
  }

  # ---- parse between blocks ---------------------------------------------
  between <- list()

  for (i in between_starts) {
    grp_line <- trim(sub("^\\s*Groups\\s+", "", lines[i]))
    grps <- strsplit(grp_line, "\\s+&\\s+")[[1]]
    grps <- trimws(grps)
    g1 <- grps[1]
    g2 <- grps[2]

    # find "Average dissimilarity =" in the next few lines
    avg_window <- lines[(i + 1):min(length(lines), i + 10)]
    avg_window <- avg_window[nzchar(trimws(avg_window))]
    avg_line <- avg_window[grep("^Average dissimilarity", avg_window)][1]
    avg_diss <- to_num(sub(".*=\\s*", "", avg_line))

    tbl_lines <- grab_table_lines(i)
    rows <- lapply(tbl_lines, parse_line_last_numeric, n_numeric = 6)
    rows <- Filter(Negate(is.null), rows)

    key <- paste(g1, g2, sep = " vs ")

    if (!length(rows)) {
      between[[key]] <- data.frame()
      next
    }

    mat <- do.call(rbind, rows)

    df <- data.frame(
      species    = mat[, "species"],
      av_abund_1 = to_num(mat[, 2]),
      av_abund_2 = to_num(mat[, 3]),
      av_diss    = to_num(mat[, 4]),
      diss_sd    = to_num(mat[, 5]),
      contrib    = to_num(mat[, 6]),
      cum        = to_num(mat[, 7]),
      group1 = g1,
      group2 = g2,
      avg_dissimilarity = avg_diss,
      stringsAsFactors = FALSE
    )

    between[[key]] <- df
  }

  list(
    metadata = metadata,
    within = within,
    between = between
  )
}
