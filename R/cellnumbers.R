#' Extract cell numbers from a Raster object.
#'
#' Provide the 'cellnumbers' capability of [raster::extract] and friends
#' directly, returning a data frame of query-object identifiers 'object_' 
#' and the cell number. 
#' 
#' Raster data is inherently 2-dimensional, with a time or 'level' dimension
#' treated like a layers of these 2D forms. The 'raster' package cell number
#' is counted from 1 at the top-left, across the rows and down. This corresponds
#' the the standard "raster graphics" convention used by 'GDAL' and the 'sp' 
#' package, and many other implementations. Note that this is different to the
#' convention used by the [graphics::image] function. 
#' 
#' Currently this function only operats as if the input is a single layer objects, it's not clear if adding
#' an extra level of grouping for layers would be sensible.   
#' 
#' The dots argument can be used to set weights=TRUE for the polygon case, this is otherwise ignored. 
#' @param x Raster object
#' @param ... arguments passed on to [raster::cellFromPolygon] for polygon input
#' @param query Spatial object or matrix of coordinates
#' @return tbl_df data frame
#' @export
#' @importFrom dplyr bind_rows
#' @importFrom raster cellFromPolygon cellFromLine cellFromXY projection
#' @examples
#' library(raster)
#' r <- raster(volcano) %>% aggregate(fact = 4)
#' cellnumbers(r, rasterToContour(r, level = 120))
#' #library(dplyr)
#' 
#' #cr <- cut(r,  pretty(values(r)))
#' #p <- raster::rasterToPolygons(cr, dissolve = TRUE)
#' #p <- spex::qm_rasterToPolygons_sp(cr)
#' #tt <- cellnumbers(cr, p)
#' #library(dplyr)
#' #tt %>% mutate(v = extract(r, cell_)) %>% 
#' #group_by(object_) %>% 
#' #summarize(mean(v)) 
#' #head(pretty(values(r)), -1)
cellnumbers <- function(x, query, ...) {
  ## TODO rebuild as Spatial collection
  ## if (inherits(query, "sf")) query <- sf::as(query, "Spatial")
  if (inherits(query, "sf")) {
    tab <- as.data.frame(query)
    if (attr(query, "sf_column") %in% names(tab)) tab[[attr(query, "sf_column")]] <- NULL
    map <- spbabel::sptable(query)
    crs <- attr(query[[attr(query, "sf_column")]], "crs")$proj4string
    query <- spbabel::sp(map, tab, crs)
  }
  if (is.na(projection(x)) || is.na(projection(query)) || projection(x) != projection(query)) {
    warning(sprintf("projections not the same \n    x: %s\nquery: %s", projection(x), projection(query)), call. = FALSE)
  }
  if (inherits(query, "SpatialPolygons")) {
    a <- cellFromPolygon(x, query, ...)
  }
  if (inherits(query, "SpatialLines")) {
    a <- cellFromLine(x, query)
  }
  
  if (is.matrix(query) | inherits(query, "SpatialPoints")) {
    a <- list(cellFromXY(x, query))
  }
  if (inherits(query, "SpatialMultiPoints")) {
    #ind <- dplyr::bind_rows(lapply(query@coords, tibble::as_tibble), .id = "feature")
    a <- lapply(query@coords, function(xymat) cellFromXY(x, xymat))
    ## yikes the old [unique(id)] trick to avoid split lexo sorting
    #a <- split(cellFromXY(x, as.matrix(ind[, -1])), ind$feature)[unique(ind$feature)]
  }
  d <- dplyr::bind_rows(lapply(a, mat2d_f), .id = "object_")
  d[["object_"]] <- as.integer(d[["object_"]])
  if (ncol(d) == 2L) names(d) <- c("object_", "cell_")
  if (ncol(d) == 3L) names(d) <- c("object_", "cell_", "weight_")
  d

}


## general extract?

# args <- list(...)
# args$cellnumbers <- TRUE
# if (inherits(x, "RasterLayer")) x <- brick(x)
# args$x <- x
# a <- do.call(raster::extract, args)
#
#

## doesn't seem to make any difference
# @rdname cellnumbers
# @export
#' pcellnumbers <- function(x, p) {
#'   if (inherits(x, "RasterLayer")) x <- brick(x)
#'   a <- raster::cellFromPolygon(x, p)
#'   dplyr::bind_rows(lapply(a, mat2d_f), .id = "i_")
#' }
#'
# #' @rdname cellnumbers
# #' @export
#' pwcellnumbers <- function(x, p) {
#'   if (inherits(x, "RasterLayer")) x <- brick(x)
#'   a <- raster::cellFromPolygon(x, p, weights = TRUE)
#'   dplyr::bind_rows(lapply(a, mat2d_f), .id = "i_")
#' }
