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
#' @param xy logical to include the x and y centre coordinate of each cell
#' @param ... unused
#'
#' @return a data frame (tibble) with columns: 
#' 
#' * `cellvalue` the actual value of the raster cell
#' * `cellindex` the index of the cell (numbered from 1 to `ncell()` in the raster way). 
#' 
#' Columns `cellindex` or `cellvalue` may be omitted if either or both of `cell` and/or `value` are `FALSE`, respectively
#' 
#' Other columns might be included depending on the properties of the raster and
#' the arguments to the function: 
#' 
#' * `year`,`month`,`day` if `split_date` is `TRUE`
#' * `x`,`y` if `xy` is `TRUE`
#' * `dimindex` if the input has more than 1 layer and `dim` is `TRUE`. 
#' 
#' 
#' @export
#'
#' @examples
#' ## basic data frame version of a basic raster
#' as_tibble(raster::raster(volcano))
#' 
#' ## data frame with time column since raster has that set
#' r <- raster::raster(volcano)
#' br <- raster::brick(r, r)
#' as_tibble(raster::setZ(br, Sys.Date() + 1:2), cell = TRUE)
#' @importFrom tibble as_tibble tibble
#' @export as_tibble
#' @importFrom dplyr bind_cols mutate
#' @importFrom raster getZ nlayers values ncell
#' @name as_tibble
as_tibble.BasicRaster <- function(x, cell = TRUE, dim = nlayers(x) > 1L, value = TRUE, split_date = FALSE, xy = FALSE,  ...) {
  dimindex <- raster::getZ(x)
  
  if (is.null(dimindex)) {
    dimindex <- seq(raster::nlayers(x))
    if (split_date) {
      e1 <- try(as.Date(dimindex), silent = TRUE)
      e2 <- try(as.POSIXct(dimindex, tz = "GMT"), silent = TRUE)
      if ((inherits(e1, "try-error") & inherits(e2, "try-error")) | any(is.na(range(e1)))) {
        message("cannot 'split_date', convert 'getZ(x)' not convertible to a Date or POSIXct")
        split_date <- FALSE
      }
    }
  } 
  
  cellvalue <- cellindex <-  NULL
  if (value) cellvalue <- as.vector(raster::values(x))
  cellindex <-  rep(seq(raster::ncell(x)), raster::nlayers(x))
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
  if (xy) {
    xy <- raster::xyFromCell(x, seq_len(raster::ncell(x)))
    colnames(xy) <- c("x", "y")
    if (nlayers(x) > 1) xy <- xy[rep(seq_len(ncell(x)), nlayers(x)), ]
    d <- dplyr::bind_cols(d, tibble::as_tibble(xy))
  }
  if (!cell) d[["cellindex"]] <- NULL
  d
}

