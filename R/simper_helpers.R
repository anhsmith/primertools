# primertools: SIMPER helpers

#' Tidy a SIMPER object (within-group tables)
#'
#' Convert a `primertools` SIMPER object into a single tibble for within-group
#' results, optionally truncating by cumulative contribution.
#'
#' @param simper_obj A SIMPER object produced by `primertools` (must contain `$within`).
#' @param cum_max Cumulative cutoff (percent). Keep rows with `cum <= cum_max`.
#'
#' @return A tibble with one row per taxon per group.
#' @export
#'
#' @examples
#' # d_within <- tidy_simper_within(simper_site_cp, cum_max = 70)
tidy_simper_within <- function(simper_obj, cum_max = 70) {
  if (is.null(simper_obj$within)) {
    stop("`simper_obj$within` is NULL. Is this a primertools SIMPER object?")
  }

  purrr::imap_dfr(simper_obj$within, ~{
    dplyr::as_tibble(.x) |>
      dplyr::rename(taxon = species) |>
      dplyr::mutate(
        group = .y,
        taxon = as.character(taxon)
      ) |>
      dplyr::arrange(dplyr::desc(contrib)) |>
      dplyr::filter(.data$cum <= cum_max)
  })
}

#' Tidy a SIMPER object (between-group tables)
#'
#' Convert a `primertools` SIMPER object into a single tibble for between-group
#' results, optionally truncating by cumulative contribution.
#'
#' @param simper_obj A SIMPER object produced by `primertools` (must contain `$between`).
#' @param cum_max Cumulative cutoff (percent). Keep rows with `cum <= cum_max`.
#'
#' @return A tibble with one row per taxon per contrast.
#' @export
#'
#' @examples
#' # d_between <- tidy_simper_between(simper_site_cp, cum_max = 60)
tidy_simper_between <- function(simper_obj, cum_max = 70) {
  if (is.null(simper_obj$between)) {
    stop("`simper_obj$between` is NULL. Is this a primertools SIMPER object?")
  }

  purrr::imap_dfr(simper_obj$between, ~{
    dplyr::as_tibble(.x) |>
      dplyr::rename(taxon = species) |>
      dplyr::mutate(
        contrast = .y,
        taxon = as.character(taxon),
        delta_abund = .data$av_abund_1 - .data$av_abund_2
      ) |>
      dplyr::arrange(dplyr::desc(contrib)) |>
      dplyr::filter(.data$cum <= cum_max)
  })
}

#' Add a within-facet ordering variable for SIMPER plots
#'
#' ggplot2 orders factors globally, so faceted SIMPER plots need a plotting-only
#' factor that is ordered within each group. This function adds `taxon_group`.
#'
#' @param d_within A tibble from `tidy_simper_within()`.
#' @param group_var Column name giving the facet/group (default `group`).
#' @param taxon_var Column name giving the taxon label (default `taxon`).
#' @param order_var Column used to order taxa within group (default `contrib`).
#' @param decreasing If TRUE (default), order from largest to smallest.
#'
#' @return The same tibble with an additional factor column `taxon_group`.
#' @export
#'
#' @examples
#' # d_within <- tidy_simper_within(simper_site_cp)
#' # d_within <- add_taxon_group_order(d_within)
add_taxon_group_order <- function(d_within,
                                  group_var = "group",
                                  taxon_var = "taxon",
                                  order_var = "contrib",
                                  decreasing = TRUE) {
  if (!requireNamespace("tidytext", quietly = TRUE)) {
    stop("Package 'tidytext' is required for add_taxon_group_order(). Please install it.")
  }

  g <- rlang::sym(group_var)
  t <- rlang::sym(taxon_var)
  o <- rlang::sym(order_var)

  d_within |>
    dplyr::mutate(
      taxon_group = tidytext::reorder_within(
        !!t,
        if (decreasing) -!!o else !!o,
        !!g
      )
    )
}
