#' tidyraster.
#'
#' @name tidyraster
#' @docType package
NULL

#' The raster volcano.
#'
#' See data-raw/rastercano.r in the source repository.
#' @format A \link[raster]{RasterLayer} created from the \code{\link[datasest]{volcano}} data.
"rastercano"

#' The raster volcano as polygons.
#'
#' See data-raw/rastercano.r in the source repository.
#'
#' @format A \link[sp]{SpatialPolygonsDataFrame} with variables: \code{volcano_elevation}.
"polycano"
