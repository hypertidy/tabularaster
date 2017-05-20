setOldClass("sf")
extent.sf <- function(x, ...) {
  raster::extent(attr(x[[attr(x, "sf_column")]], "bbox")[c(1, 3, 2, 4)])
}

#' @importFrom methods setMethod
setMethod(f = "extent", signature = "sf", definition = extent.sf)


spex.sf <- function(x, crs, ...) {
  spex(extent(x), attr(x[[attr(x, "sf_column")]], "crs")$proj4string)
}


extract.sf <- function(x, y, ...) {
  cn <- cellnumbers(x, y)
  if (nrow(cn) > length(unique(cn$object_))) {
    out <- split(extract(x, cn$cell_), cn$object_)[unique(cn$object_)]
  } else {
    out <- extract(x, cn$cell_)
  }
  out
}
setMethod(f = "extract", signature = c("BasicRaster", "sf"), definition = extract.sf)
# 
# multi_type <- function(x) {
#   type <- type_of_thing(x)
#   mp <- "MULTIPOLYGON"
#   ml <- "MULTILINESTRING"
#   mp <- "MULTIPOINT"
#   mtype <- c(POLYGON = mp, MULTIPOLYGON = mp,
#     LINESTRING = ml, MULTILINESTRING = ml, 
#     POINT = mp, MULTIPOINT = mp)[type]
#   if (is.na(mtype)) stop(sprintf("type %x not supported", type))
#   mtype
# }
# 
# sp_from_sf <- function(x) {
#   tab <- as.data.frame(x)
#   if (attr(x, "sf_column") %in% names(tab)) tab[[attr(x, "sf_column")]] <- NULL
#   map <- spbabel::sptable(x)
#   crs <- attr(x[[attr(x, "sf_column")]], "crs")$proj4string
#   sf_to_sp_type(map, multi_type(x))
# }
# sf_to_sf_type <- function(tab, type) {
#   if (type == "MULTIPOLYGON") {
#     split()
#   }
# }
# type_of_thing <- function(x) {
#   gsub("sfc_", "", rev(class(psf[[attr(psf, "sf_column")]]))[2L])
# }