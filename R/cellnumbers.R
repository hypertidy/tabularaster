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
#' library(dplyr)
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
#' @export
cellnumbers <- function(x, query, ...) {
  UseMethod("cellnumbers")
}
#' @name cellnumbers
#' @export
cellnumbers.default <- function(x, query, ...) {
  
  if (inherits(query, "sf")) {
    g <- query[[attr(query, "sf_column")]]
    if (inherits(g, "sfc_LINESTRING") || inherits(g, "sfc_MULTILINESTRING")) {
      return(line_cellnumbers(query, x))
    }
  }
  
  if (inherits(query, "SpatialLines")) {
    return(line_cellnumbers(query, x))
  }
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


psp_i <- function(x, i = 1) {
  g <- rep(seq_len(nrow(x$geometry)), x$geometry$nrow)
  coord <- x$coord
  idx <- which(g == i) 
  segment <- x$segment[x$segment$.vx0 %in% idx & x$segment$.vx1 %in% idx, ]
  spatstat::psp(x0 = coord$x_[segment$.vx0],
                y0 = coord$y_[segment$.vx0],  
                x1 = coord$x_[segment$.vx1], 
                y1 = coord$y_[segment$.vx1], 
                window = spatstat::owin(range(coord$x_), range(coord$y_)))
}
#' @importFrom spatstat owin as.owin
as.owin.BasicRaster <- function(W, ...) {
  msk <- matrix(TRUE, nrow(W), ncol(W))
  spatstat::owin(c(xmin(W), xmax(W)), c(ymin(W), ymax(W)), mask = msk)
}
pix <- function(psp, ras) {
  spatstat::pixellate(psp, as.owin(ras), weights = 1)   
}


line_cellnumbers <- function(ln, r) {

  x <- vertex_edge_path(ln)
  
  
  
  im <- setValues(r, 0)
  l <- vector("list", nrow(x$geometry))
  for (i in seq_along(l)) {
    im <- (raster(pix(psp_i(x, i = i), r)) > 0)
    l[[i]] <- tibble(object_ = i, cell_ =   which(values(im) > 0), weight = 1L)    
  }
  
  
  dplyr::bind_rows(l)
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
