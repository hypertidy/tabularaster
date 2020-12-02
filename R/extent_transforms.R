

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
#' @examples 
#' ## the index extent is the rows/cols
#' index_extent(raster::raster(volcano), raster::extent(0, 1, 0, 1))
#' 
#' index_extent(raster::raster(volcano), raster::extent(0, 1, 0, .5))
#' 
index_extent <- function(x, ex) {
  raster::extentFromCells(set_indextent(x), raster::cellsFromExtent(x, ex))
}