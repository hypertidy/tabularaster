#' Tabular tools for raster
#' 
#' Extract and index with raster tidy tools for raster.
#' 
#' 
#' @name tabularaster
#' @docType package
#' @details Tabularaster includes these main functions.  
#' \tabular{ll}{
#'  \code{\link{as_tibble}} \tab convert raster data to data frame form, with control over output and form of dimension/coordinate columns \cr
#'  \code{\link{cellnumbers}} \tab extract a data frame of query identifiers and cell,pixel index numbers \cr
#'  \code{\link{decimate}} \tab fast and loose resizing of a raster to coarser resolution \cr
#'  \code{\link{index_extent}} \tab build an extent in row column form, as opposed to coordinate value form \cr
#'  }
NULL


#' Sea surface temperature data. 
#' 
#' A smoothed subset of GHRSST. 
#'
#' See "data-raw/ghrsst.R" and "data-raw/ghrsst-readme.txt" for
#' details. 
#' 
#' `sst_regions` is a simple polygon region layer to sit over the SST data.
#' @examples 
#' \donttest{
#' library(raster)
#' plot(ghrsst, col = hcl.colors(12, "YlOrRd", rev = TRUE))
#' plot(sst_regions, add = TRUE, col = NA)
#' cellnumbers(ghrsst, sst_regions) 
#' }
#' @format A raster created GHRSST data and raster smoothing.
#' @name ghrsst
#' @aliases sst_regions
NULL



#' Optimally interpolated SST in near-native form.
#'
#' See data-raw/oisst.R in the source repository.  The file was
#' avhrr-only-v2.20170729.nc, its extent -180, 180, -90, 90 with
#' dimensions 1440x720 in the usual raster configuration. 
#' @format A data frame of sst values created from OISST data.
#' @name oisst
#' @examples
#' oisst
NULL

#' The raster volcano.
#'
#' See data-raw/rastercano.r in the source repository.
#' @format A raster created from the \code{\link[datasets]{volcano}} data.
#' @name rastercano
#' @examples 
#' library(raster)
#' plot(rastercano)
NULL

#' The raster volcano as polygons.
#'
#' See data-raw/rastercano.r in the source repository.
#'
#' @format A `sp::SpatialPolygonsDataFrame` with variables: \code{volcano_elevation}.
#' @name polycano
#' @examples 
#' exists("polycano")
NULL

#' Sharkcano, the shark and the volcano.
#'
#' This is just a free image off the internet.
#' The image was read in and all non-essential items dropped. The dimensions in `raster::raster` terms is stored in
#'  \code{attr(sharkcano, "rasterdim")}.
#' @references This is the small version from here, see script in data-raw/sharkcano.r 
#' http://www.freestockphotos.biz/stockphoto/16214
#' Thanks to @jennybc for pointers on finding free stuff: https://github.com/jennybc/free-photos
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
#' @name sharkcano
NULL