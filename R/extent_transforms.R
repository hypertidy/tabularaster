

## from angstroms
set_indextent <- function (x) {
  raster::setExtent(x, raster::extent(0, ncol(x), 0, nrow(x)))
}


#' Index extent
#' 
#' Extent in index space. 
#' 
#' Convert a geographic extent into purely index space. 
#' @param x raster layer
#' @param ex extent 
#'
#' @return  extent object
#' @export
#'
index_extent <- function(x, ex) {
  raster::extentFromCells(set_indextent(x), raster::cellsFromExtent(x, ex))
}