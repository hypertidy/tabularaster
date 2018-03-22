#' @name polysaas
#' @export
polysaas <- function(x, ...) {
  UseMethod("polysaas")
}
#' @name polysaas
#' @export
polysaas.BasicRaster <- function(x, ...) {
  polysaas(raster::extent(x), grain = res(x), crs = crs(x))
}
#' @name polysaas
#' @export
polysaas.default <- function(xylim, grain = NULL,  crs = NULL) {
  discr <- raster(xylim, res = grain, crs = crs)
  structure(discretization = discr, class = "polysaas")
}

#' @name slice
#' @importFrom dplyr::slice
#' @export
slice.polysaas <- function(x, ...) {
  xy_centre <- cellFromXY(x$discretization)
}

discretization <- function(xlim, ylim, grain, crs) {
  structure(grain = grain, 
            crs = crs)
}
#' 
#' #' Abstract axis transform. 
#' #' 
#' #' An axis transform 
#' axis_transform <- function(x, ...) {
#'   UseMethod("axis_transform")
#' }
#' axis_transform.default <- function(x, coord = NULL, affine = NULL, ...)  {
#'   
#' }
#' axis_transform.d_axis <- function(x, coord = NULL, affine = NULL, ...) {
#'   if (is.null(coord)) coord <- seq(min(x), max(x), length = length(x))
#'   structure(tibble(index = seq_len(length(x), 
#'                    coord = coord)), class = "axis_transform")
#' }
#' 
#' #' Abstract axis
#' #' 
#' #' Create an axis from inputs `n`umber, `min`imum and `max`imum, and optionally 
#' #' a `name`. The name is intended to be present and unique for downstream use, but in 
#' #' isolation are optional. 
#' #' 
#' #' Continuous axes are supported, but only for some kind of completeness. The 
#' #' intention is for straightforward 1-D discretization and the ability to be continuous is
#' #' probably better supported elsewhere (i.e. the scales package). 
#' #' @param n number of discrete steps in the axis
#' #' @param min the minimum location in the axis (defaults to zero)
#' #' @param max the maximum location in the axis (defaults to `n`)
#' #' @param name a name to apply to the axis
#' #' @name d_axis
#' #' @export
#' d_axis <- function(n, min, max, name) UseMethod("d_axis")
#' #' @name d_axis
#' #' @export
#' d_axis.default <- function(n,  min = 0, max = n, name = NA_character_) {
#'   if (!min < max) stop("minimum position must be less than the maximum")
#'   structure(tibble(n = n, min = min, max = max,  name = name), class = "d_axis")
#' }
#' 
#' print.d_axis <- function(x, ...) {
#'   message(sprint("d_axis  %s", x$name))
#'   message(sprintf("type: %s", axis_type(x)))
#'   message(sprintf("min: %f", min(x)))
#'   message(sprintf("max: %f", max(x)))
#' }
#' length.d_axis <- function(x) x$n
#' min.d_axis <- function(x) x$min
#' max.d_axis <- function(x) x$max
#' axis_type <- function(x) {
#'   if (is.finite(x$n))  "discrete" else "continuous"
#' }
#' 
#' is_continuous <- function(x, ...)  UseMethod("is_continuous")
#' is_continuous.axis <- function(x, ...) axis_type(x) == "continuous"
#' is_discrete <- function(x, ...) UseMethod("is_discrete")
#' is_discrete <- function(x, ...) axis_type(x) == "discrete"
#' 
