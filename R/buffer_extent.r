#' Deprected tabularaster function 
#'
#' Ensure a raster extent aligns to whole parts.
#' 
#' This function is deprecated, please use `spex::buffer_extent`. 
#' @param e1 input \code{\link[raster]{extent}}
#' @param e2 grain size
#' @examples
#' library(spex)
#' library(raster)
#' buffer_extent(extent(0.1, 2.2, 0, 3), 2)
#' @importFrom spex buffer_extent spex
#' @export
bufext <- function(e1, e2) {
  .Deprecated(new = "buffer_extent", package = "spex")
  spex::buffer_extent(e1, e2)
}

