#' Whole cell buffer for an extent
#'
#' Ensure a raster extent aligns to whole parts.
#' @param e1 input \code{\link[raster]{extent}}
#' @param e2 grain size
#' @examples
#' library(raster)
#' bufext(extent(0.1, 2.2, 0, 3), 2)
#' @importFrom raster extent xmin xmax ymin ymax
#' @export
bufext <- function(e1, e2) {
  e1 <- extent(e1)
  if (e2 == 0) return(e1)
  num0 <- as.double(e1)
  extent((num0 %/% e2) * e2 + c(0, e2, 0, e2))
}

#' Atomic vector extent
#'
#' Coerce a \code{\link[raster]{extent}} to an atomic vector of \code{c(xmin(x), xmax(x), ymin(x), ymax(x))}.
#'
#' Note that \code{as.integer} results in truncation, see rasterOps for positive buffering.
#' @rdname extent-numeric
#' @param x a \code{\link[raster]{extent}}
#' @param ... unused
#'
#' @return numeric vector
#' @export
#' @seealso base::as.double
#' @examples
#' as.double(extent(0, 1, 0, 1))
#' as.numeric(extent(0, 1, 0, 1))
#' as.integer(extent(0, 1, 0, 1) + c(2.5, 27.877, 100, 999.1))
as.double.Extent <- function(x, ...) {
  c(xmin(x), xmax(x), ymin(x), ymax(x))
}

#' @export
#' @rdname extent-numeric
as.integer.Extent <- function(x, ...) {
  as.integer(as.double(x))
}
