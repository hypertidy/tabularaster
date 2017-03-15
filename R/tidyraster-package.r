#' tidyraster.
#'
#' @name tidyraster
#' @docType package
NULL

#' The raster volcano.
#'
#' See data-raw/rastercano.r in the source repository.
#' @format A \link[raster]{raster} created from the \code{\link[datasets]{volcano}} data.
"rastercano"

#' The raster volcano as polygons.
#'
#' See data-raw/rastercano.r in the source repository.
#'
#' @format A \link[sp]{SpatialPolygonsDataFrame} with variables: \code{volcano_elevation}.
"polycano"

#' Sharkcano, the shark and the volcano.
#'
#' This is just a free image off the internetz.
#' The image was read in and all non-essential items dropped. The dimensions in \code{\link[raster]{raster}} terms is stored in \code{attr(sharkcano, "rasterdim")}.
#' @references This is the small version from here, see script in data-raw/sharkcano.r http://www.freestockphotos.biz/stockphoto/16214
#'Thanks to @jennybc for pointers on finding free stuff: https://github.com/jennybc/free-photos
#' @format A data frame with 117843 rows and 2 variables:
#' \describe{
#'   \item{\code{cell_}}{integer, cell index}
#'   \item{\code{byte}}{integer, byte value of shark image pixels}
#' }
#' These are cell values on a grid that is 648x958.
#' @examples
#' library(raster)
#' rd <- attr(sharkcano, "rasterdim")
#' rastershark <- raster(matrix(NA_integer_, rd[1], rd[2]))
#' rastershark[sharkcano$cell_] <- sharkcano$byte  ## byte, heh
#' ## I present to you, Sharkcano!  (Just wait for the 3D version, Quadshark).
#' plot(rastercano)
#' contour(rastershark, add = TRUE, labels = FALSE)
#' plot(rastershark, col = "black")
#' ## another way
#' plot(rastercano)
#' points(xyFromCell(rastershark, sharkcano$cell_), pch = ".")
"sharkcano"
