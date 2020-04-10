
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
#' Currently this function only operates as if the input is a single layer objects, it's not clear if adding
#' an extra level of grouping for layers would be sensible.   
#' 
#' @param x Raster object
#' @param ... unused
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
  UseMethod("cellnumbers", object = query)
}
#' @name cellnumbers
#' @export
cellnumbers.default <- function(x, query, ...) {
  a <- NULL ## allow a basic check for not understanding "query"
  if (inherits(query, "sf")) {
    ## we need this for points, mpoints
    pth <- silicate::sc_path(query)
 
    tab <- tibble(object_ = rep(as.integer(factor(pth$object_)), pth$ncoords_), 
                  cell_ = raster::cellFromXY(x, as.matrix(silicate::sc_coord(query)[c("x_" , "y_")])))
    return(tab)
                  
 }
  if (is.na(projection(x)) || is.na(projection(query)) || projection(x) != projection(query)) {
    warning(sprintf("projections not the same \n    x: %s\nquery: %s", projection(x), projection(query)), call. = FALSE)
  }
  if (inherits(query, "SpatialPolygons")) {
    warning("cellnumbers is very slow for SpatialPolygons, consider conversion with 'sf::st_as_sf'", immediate. = TRUE)
    a <- cellFromPolygon(x, query)
  }
  if (is.matrix(query) | inherits(query, "SpatialPoints")) {
    if (is.matrix(query)) stopifnot(ncol(query) >= 2)
    a <- list(cellFromXY(x, query))
  }
  if (inherits(query, "SpatialMultiPoints")) {
    a <- lapply(query@coords, function(xymat) cellFromXY(x, xymat))
  }
  if (is.null(a)) stop(sprintf("no method for 'query' of type %s", class(query)[1L]))
  d <- dplyr::bind_rows(lapply(a, mat2d_f), .id = "object_")
  d[["object_"]] <- as.integer(d[["object_"]])
  if (ncol(d) == 2L) names(d) <- c("object_", "cell_")
  if (ncol(d) == 3L) names(d) <- c("object_", "cell_", "weight_")
  d
  
}
#' @name cellnumbers
#' @export
cellnumbers.SpatialLines <- function(x, query, ...) {
  line_cellnumbers(query, x)
}
#' @name cellnumbers
#' @export
cellnumbers.sfc <- function(x,  query, ...) {
  if (!"list" %in% class(query)) {
    class(query) <- c(class(query), "list")
  }

   sf1 <- tibble::tibble(geometry = query)
   cellnumbers(x, structure(sf1, sf_column = "geometry", agr = NULL, class = c("sf", "data.frame")))
}
#' @name cellnumbers
#' @export
cellnumbers.sf <- function(x, query, ...) {
  g <- query[[attr(query, "sf_column")]]
  if (inherits(g, "sfc_GEOMETRY")) stop("GEOMETRY and GEOMETRYCOLLECTION not supported")
  if (inherits(g, "sfc_LINESTRING") || inherits(g, "sfc_MULTILINESTRING")) {
    return(line_cellnumbers(query, x))
  }
  
  if (inherits(g, "sfc_POLYGON") || inherits(g, "sfc_MULTIPOLYGON")) {
    query$polygon <- seq_len(nrow(query))
    rast <- fasterize::fasterize(query, x, field = "polygon")
    v <- values(rast)
    ok <- !is.na(v)
    return(tibble::tibble(object_ = v[ok], cell_ = which(ok)))
  }

  cellnumbers.default(x, query)  ## needed for points to pass through
  #   stop(sprintf("%x not supported", class(x)))
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
  spatstat::owin(c(raster::xmin(W), raster::xmax(W)), c(raster::ymin(W), raster::ymax(W)), mask = msk)
}
pix <- function(psp, ras) {
  spatstat::pixellate(psp, as.owin(ras), weights = 1)   
}

line_cellnumbers <- function(x, r) {
  sc <- silicate::SC0(x)
  xy <- as.matrix(silicate::sc_vertex(sc)[c("x_", "y_")])
  l <- vector("list", nrow(silicate::sc_object(sc)))
  ow <- spatstat::owin(range(xy[,1]), range(xy[,2]))
  for (i in seq_along(l)) {
    segs <- as.matrix(do.call(rbind, sc$object$topology_[i])[c(".vx0", ".vx1")])
    pspii <- spatstat::psp(xy[segs[,1L],1L], xy[segs[,1L],2L], 
                           xy[segs[,2L],1L], xy[segs[,2L],2L], window = ow)
    
      im <- (raster(pix(pspii, r)) > 0)
    l[[i]] <- tibble(object_ = i, cell_ =   which(raster::values(im) > 0))    
  }
  dplyr::bind_rows(l)
} 
# .line_cellnumbers0 <- function(ln, r) {
#   x <- vertex_edge_path(ln)
#   im <- setValues(r, 0)
#   l <- vector("list", nrow(silicate::sc_object(sc)))
#   ow <- spatstat::owin(range(xy[,1], range(coord$y_)))
#   for (i in seq_along(l)) {
#     im <- (raster(pix(psp_i(x, i = i), r)) > 0)
#     l[[i]] <- tibble(object_ = i, cell_ =   which(values(im) > 0))    
#   }
#   dplyr::bind_rows(l)
# }
