#' Extract cell numbers from a Raster object.
#'
#' Currently only for single layer objects.
#' @param object Raster object
#' @param ... arguments passed on
#' @param p Spatial polygons object
#' @return tbl_df data frame
#' @export
#' @importFrom dplyr bind_rows
#' @importFrom raster extract
#' @examples
cellnumbers <- function(x, query, ...) {

  if (inherits(query, "SpatialPolygons")) {
    a <- cellFromPolygon(x, query, ...)
  }
  if (inherits(query, "SpatialLines")) {
    a <- cellFromLine(x, query, ...)
  }
  if (is.matrix(query) | inherits(query, "SpatialPoints")) {
    a <- cellFromXY(x, query)
  }
  d <- dplyr::bind_rows(lapply(a, mat2d_f), .id = "i_")
  d

}


## general extarct?

# args <- list(...)
# args$cellnumbers <- TRUE
# if (inherits(x, "RasterLayer")) x <- brick(x)
# args$x <- x
# a <- do.call(raster::extract, args)
#
#

## doesn't seem to make any difference
# @rdname cellnumbers
# @export
#' pcellnumbers <- function(x, p) {
#'   if (inherits(x, "RasterLayer")) x <- brick(x)
#'   a <- raster::cellFromPolygon(x, p)
#'   dplyr::bind_rows(lapply(a, mat2d_f), .id = "i_")
#' }
#'
# #' @rdname cellnumbers
# #' @export
#' pwcellnumbers <- function(x, p) {
#'   if (inherits(x, "RasterLayer")) x <- brick(x)
#'   a <- raster::cellFromPolygon(x, p, weights = TRUE)
#'   dplyr::bind_rows(lapply(a, mat2d_f), .id = "i_")
#' }
