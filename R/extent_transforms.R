
#' Extent from cells
#'
#' Use cell numbers to obtain their extent from a raster. 
#' 
#' This is a missing funciton in the raster package for cell abstraction. 
#' @param x raster
#' @param cells cell numbers, relative to x
#'
#' @return raster extent
#' @export
#'
extentFromCells <- function(x, cells) {
  dx_r <- res(x)[1] * c(-1, 1) * 0.5
  dy_r <- res(x)[2] * c(-1, 1) * 0.5
  raster::extent(range(raster::xFromCell(x, cells)) + dx_r, range(raster::yFromCell(x, cells)) + dy_r)
}


## from angstroms
set_indextent <- function (x) {
  setExtent(x, extent(0, ncol(x), 0, nrow(x)))
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
  extentFromCells(set_indextent(x), raster::cellsFromExtent(x, ex))
}