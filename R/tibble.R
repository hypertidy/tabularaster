#' Convert a Raster to a tibble. 
#'
#' 
#' @param x a RasterLayer, RasterStack or RasterBrick
#'
#' @return a tibble
#' @export
#'
#' @examples
#' as_tibble(raster::raster(volcano))
#' 
#' as_tibble(setZ(raster::raster(volcano), Sys.Date()), cell = TRUE)
#' @importFrom tibble tibble
as_tibble.BasicRaster <- function(x, cell = TRUE, dim = TRUE, split_date = TRUE, ...) {
  dimindex <- getZ(x)
  
  if (is.null(dimindex)) {
    dimindex <- seq(nlayers(x))
    if (split_date) {
      e <- try(as.Date(dimindex))
      if (inherits(e, "try-error") | any(is.na(range(e)))) {
        split_date <- FALSE
      }
    }
  } 
  
  d <- tibble(cellvalue = as.vector(values(x)))
  if (cell) d <- mutate(d, cellindex = rep(seq(ncell(x)), nlayers(x)))
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

