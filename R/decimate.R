#' Decimate swiftly and ruthlessly
#'
#' Reduce the resolution of a \code{\link[raster]{raster}} by ruthless decimation.
#'
#' This is fast, it's just fast extraction with no care taken for utility purposes when you need
#' to reduce the detail.
#' @param x raster object (single layer).
#' @param dec decimation factor, raw multiplier for the resolution of the output
#'
#' @return raster layer
#' @examples
#' library(raster)
#' plot(decimate(raster(volcano)))
#' contour(raster(volcano), add = TRUE)
#' @export
#' @importFrom raster raster res res<- setValues extract brick xyFromCell ncell
decimate <- function(x, dec = 10) {
  #.Deprecated()
  r <- raster(x); res(r) <- res(x) * dec
  setValues(r, extract(brick(x), xyFromCell(r, seq_len(ncell(r)))))
}
