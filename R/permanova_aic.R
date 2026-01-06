#' AIC-like criterion for PERMANOVA models
#'
#' Computes an AIC-style criterion using the residual sum-of-squares,
#' sample size, and number of fitted terms/parameters (v).
#'
#' @param SS_res Residual sum-of-squares (numeric scalar).
#' @param N Number of observations (numeric/integer scalar).
#' @param v Model complexity term (numeric/integer scalar).
#' @param round_n Round to.
#'
#' @return A numeric scalar rounded to `round_n` decimal place.
#' @export
#'
#' @examples
#' aic_permanova(SS_res = 130060, N = 281, v = 26)
#' aic_permanova(SS_res = 130060, N = 281, v = 26, round_n = 2)
aic_permanova <- function(SS_res, N, v, round_n = 1) {
  round(N * log(SS_res / N) + 2 * v, round_n)
}

#' Extract PERMANOVA AIC components from a PRIMER PERMANOVA table
#'
#' Convenience wrapper to pull residual SS and \eqn{\nu} (nu) from a PRIMER
#' PERMANOVA table (with columns including `Source`, `SS`, `df`), and compute
#' an AIC-like score.
#'
#' @seealso [aic_permanova()]
#' @param x A data frame/tibble with a `Source` column and at least `SS` and `df`.
#'   Must contain rows named `Res` and `Total` in `Source`.
#' @param model_name Optional model label. If `NULL`, uses the name of `x`.
#' @param N Number of observations (Total df + 1 in most PRIMER contexts).
#'
#' @return A tibble with columns `Model`, `SS_residual`, `nu`, `AIC`.
#' @export
get_permanova_aic <- function(x, model_name = NULL, N) {

  if (is.null(model_name)) {
    model_name <- deparse(substitute(x))
  }

  x <- x |>
    tibble::column_to_rownames("Source")

  SS_res <- x["Res", "SS"]
  nu     <- x["Total", "df"] - x["Res", "df"]

  tibble::tibble(
    Model       = model_name,
    SS_residual = SS_res,
    nu          = nu,
    AIC         = aic_permanova(SS_res, N, nu)
  )
}
