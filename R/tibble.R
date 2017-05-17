#' Convert a Raster to a tibble. 
#'
#' 
#' @param x a RasterLayer, RasterStack or RasterBrick
#' @param cell logical to include explicit cell number
#' @param dim logical to include slice index 
#' @param split_date logical to split date into components
#' @param ... unused
#'
#' @return a tibble
#' @export
#'
#' @examples
#' as_tibble(raster::raster(volcano))
#' 
#' as_tibble(setZ(raster::raster(volcano), Sys.Date()), cell = TRUE)
#' @importFrom tibble as_tibble tibble
#' @importFrom dplyr mutate
#' @importFrom raster getZ nlayers values ncell
#' @name as_tibble
as_tibble.BasicRaster <- function(x, cell = TRUE, dim = TRUE, split_date = TRUE, ...) {
  dimindex <- raster::getZ(x)
  
  if (is.null(dimindex)) {
    dimindex <- seq(raster::nlayers(x))
    if (split_date) {
      e <- try(as.Date(dimindex), silent = TRUE)
      if (inherits(e, "try-error") | any(is.na(range(e)))) {
        split_date <- FALSE
      }
    }
  } 
  
  d <- tibble(cellvalue = as.vector(raster::values(x)))
  if (cell) d <- dplyr::mutate(d, cellindex = rep(seq(raster::ncell(x)), raster::nlayers(x)))
  if (dim) {
    dimindex <- rep(dimindex, each = ncell(x))
    if (split_date) {
      d <- mutate(d, year = as.integer(format(dimindex, "%Y")), 
                                month = as.integer(format(dimindex, "%m")), 
                                day = as.integer(format(dimindex, "%d")))
      
    } else {
      d[["dimindex"]] <- dimindex
    }
  }
  d
}

