#' Convert a Raster to a data frame. 
#'
#' Generate a data frame version of any raster object. Use the arguments
#' 'cell', 'dim', 'split_date' and 'value' to control the columns that
#' are included in the output.
#' 
#' If the raster has only one layer, the slice index is not added. Use 'dim = FALSE' to not include
#' the slice index value. 
#'
#' @param x a RasterLayer, RasterStack or RasterBrick
#' @param cell logical to include explicit cell number
#' @param dim logical to include slice index 
#' @param split_date logical to split date into components
#' @param value logical to return the values as a column or not
#' @param ... unused
#'
#' @return a data frame ('tbl_df'/'tibble' form)
#' @export
#'
#' @examples
#' #library(tabularaster)
#' #library(tibble)
#' #as_tibble(raster::raster(volcano))
#' #as_tibble(raster::setZ(raster::raster(volcano), Sys.Date()), cell = TRUE)
#' @importFrom tibble as_tibble tibble
#' @export as_tibble
#' @importFrom dplyr bind_cols mutate
#' @importFrom raster getZ nlayers values ncell
#' @name as_tibble
as_tibble.BasicRaster <- function(x, cell = TRUE, dim = nlayers(x) > 1L, value = TRUE, split_date = FALSE, ...) {
  dimindex <- raster::getZ(x)
  
  if (is.null(dimindex)) {
    dimindex <- seq(raster::nlayers(x))
    if (split_date) {
      e1 <- try(as.Date(dimindex), silent = TRUE)
      e2 <- try(as.POSIXct(dimindex, tz = "GMT"), silent = TRUE)
      if ((inherits(e1, "try-error") & inherits(e2, "try-error")) | any(is.na(range(e1)))) {
        warning("cannot 'split_date', convert 'getZ(x)' not convertible to a Date or POSIXct")
        split_date <- FALSE
      }
    }
  } 
  cellvalue <- cellindex <-  NULL
  if (value) cellvalue <- as.vector(values(x))
  if (cell) cellindex <-  rep(seq(raster::ncell(x)), raster::nlayers(x))
  d <- dplyr::bind_cols(cellvalue = cellvalue, cellindex = cellindex)
  if (dim) {
    dimindex <- rep(dimindex, each = ncell(x))
    if (split_date) {
      d <- dplyr::mutate(d, year = as.integer(format(dimindex, "%Y")), 
                                month = as.integer(format(dimindex, "%m")), 
                                day = as.integer(format(dimindex, "%d")))
      
    } else {
      d[["dimindex"]] <- dimindex
    }
  }
  d
}

