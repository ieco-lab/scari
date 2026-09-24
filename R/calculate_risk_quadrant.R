#'Calculate placement of point-wise suitability values on risk quadrant plot
#'
#'@description This function categorizes the risk of establishment by Lycorma
#'delicatula according to our risk quadrant framework, which is the intersection
#'between predictions made by the global and regional-scale models. It will return
#' which quadrant a suitability value will fall into on an xy-scatter.
#'
#'@param suit.x Suitability values comprising the x-axis. Global-scale model is
#'usually placed along the x-axis. Should be a vector of values or the column
#'in a data frame/tibble.
#'
#'@param suit.y Suitability values comprising the y-axis. Regional-scale ensemble
#'model is usually placed along the x-axis. Should be a vector of values or the column
#'in a data frame/tibble.
#'
#'@param thresh.x The threshold for suitability accompanying the x-axis model
#'values.
#'
#'@param thresh.y The threshold for suitability accompanying the y-axis model
#'values.
#'
#'@details
#'
#'#'The function requires the packages 'dplyr' and 'cli'.
#'
#'Input data formats:
#'* param "suit" = matrix of suitability values
#'* param "thresh" = numeric
#'
#'Input suitability data can be created using the function `predict_xy_suitability`,
#'or extracted from a raster using `terra::extract()`, as needed.
#'
#'@return
#'
#'Returns a data frame. Values will be one of: "extreme", "high", "moderate",
#'or "low". These correspond with our interpretation of the risk quadrant plots we have created:
#'
#'* extreme risk = quadrant 4 (upper right)
#'* high risk = quadrant 3 (upper left)
#'* moderate risk = quadrant 2 (bottom right)
#'* low risk = quadrant 1 (bottom left)
#'
#'@examples
#'
#'# I typically use it with `dplyr::mutate()` to create a new column in a data frame.
#'
#'```R
#'
#'IVR_locations_risk <- dplyr::mutate(IVR_locations_risk, risk_1995 = scari::calculate_risk_quadrant(
#'  suit.x = IVR_locations_joined$xy_global_1995_rescaled,
#'  suit.y = IVR_locations_joined$xy_regional_ensemble_1995_rescaled,
#'  thresh.x = global_MTSS, # this threshold remains the same
#'  thresh.y = regional_ensemble_MTSS_1995
#'  ))
#'
#'```
#'
#'@export
calculate_risk_quadrant <- function(suit.x, suit.y, thresh.x, thresh.y) {

  ## error checks---------------------------------------------------------------

  # ensure objects are numeric type
  if (is.numeric(thresh.x) == FALSE) {
    cli::cli_abort("Parameter 'thresh.x' must be of type 'numeric'")
    stop()
  }

  if (is.numeric(thresh.y) == FALSE) {
    cli::cli_abort("Parameter 'thresh.y' must be of type 'numeric'")
    stop()
  }

  ## import settings------------------------------------------------------------

  # coerces a suitability input (file path, vector, matrix, data frame/tibble,
  # or list) into a plain numeric vector. This is required so that the
  # comparisons below (ex: `suit_x >= thresh.x`) always return a logical
  # vector rather than a logical matrix/data frame, which `dplyr::case_when()`
  # cannot accept.
  coerce_suit_to_vector <- function(suit) {

    # read in from file, if applicable
    if (is.character(suit) && length(suit) == 1 && file.exists(suit)) {
      suit <- read.csv(suit, stringsAsFactors = FALSE)
    }

    # for matrices and data frames/tibbles, isolate the suitability values:
    # a single column is used as-is, while multiple columns (ex: the "ID" +
    # value columns returned alongside each other by `terra::extract()`) are
    # assumed to end with the suitability values in the last column
    if (is.matrix(suit) || is.data.frame(suit)) {
      suit <- if (ncol(suit) == 1) suit[, 1] else suit[, ncol(suit)]
    }

    # flatten anything remaining (ex: lists) and force to a numeric vector
    as.numeric(unlist(suit, use.names = FALSE))
  }

  # suit.x
  suit_x <- coerce_suit_to_vector(suit.x)

  # suit.y
  suit_y <- coerce_suit_to_vector(suit.y)


  ## function-------------------------------------------------------------------

  # apply case_when
  risk_output <- dplyr::case_when(
    suit_x >= thresh.x & suit_y >= thresh.y ~ "extreme",
    suit_x < thresh.x & suit_y >= thresh.y  ~ "high",
    suit_x >= thresh.x & suit_y < thresh.y  ~ "moderate",
    suit_x < thresh.x & suit_y < thresh.y   ~ "low"
  )

  # convert to df
  risk_output <- as.list(risk_output)

  # return
  return(risk_output)
}
