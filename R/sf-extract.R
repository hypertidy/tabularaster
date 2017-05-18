setOldClass("sf")
extent.sf <- function(x, ...) {
  raster::extent(attr(x[[attr(x, "sf_column")]], "bbox")[c(1, 3, 2, 4)])
}

setMethod(f = "extent", signature = "sf", definition = extent.sf)


spex.sf <- function(x, crs, ...) {
  spex(extent(x), attr(x[[attr(x, "sf_column")]], "crs")$proj4string)
}


extract.sf <- function(x, y, ...) {
  cn <- cellnumbers(x, y)
  if (nrow(cn) > length(unique(cn$object_))) {
    out <- split(extract(x, cn$cell_), cn$object_)
  } else {
    out <- extract(x, cn$cell_)
  }
  out
}
setMethod(f = "extract", signature = c("BasicRaster", "sf"), definition = extract.sf)
