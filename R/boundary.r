#' Create a boundary polygon by tracking around coordinates stored in a RasterStack
#' 
#' The first layer is treated as the X coordinate, second as Y. 
#' @param cds two-layer Raster
#'
#' @importFrom sp SpatialPolygons Polygons Polygon
#' @importFrom raster as.matrix cellFromRow cellFromCol xmin xmax ymin ymax trim setExtent setValues raster extract flip extent 
#' @export
boundary <- function(cds) {
  left <- cellFromCol(cds, 1)
  bottom <- cellFromRow(cds, nrow(cds))
  right <- rev(cellFromCol(cds, ncol(cds)))
  top <- rev(cellFromRow(cds, 1))
  ## need XYFromCell method
  SpatialPolygons(list(Polygons(list(Polygon(raster::as.matrix(cds)[unique(c(left, bottom, right, top)), ])), "1")))
}