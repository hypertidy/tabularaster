scl <- function(x) {
  rg <- range(x, na.rm = TRUE);
  (x - rg[1])/diff(rg)
}

meshplot_discrete <- function(x, col = NULL, ...) {
  UseMethod("meshplot_discrete")
}
meshplot_discrete.BasicRaster <- function(x, col = NULL, crs = NULL, ...) {
  print("converting to single RasterLayer")
  meshplot_discrete(x[[1]])
}
meshplot_discrete.RasterLayer <- function(x, col = NULL, crs = NULL, ...) {
  qm <- quadmesh(x, na.rm = FALSE)
  ib <- qm$ib
  xy <- t(qm$vb[1:2, ])
  rm(qm)
  if (!is.null(crs) ) {
    if (!raster::isLonLat(x)) {
      xy <- rgdal::project(xy, raster::projection(x), inv = TRUE)
    }
    if (!raster::isLonLat(crs)) xy <- rgdal::project(xy, crs)
  }
  ## we have to remove any infinite vertices
  ## as this affects the entire thing
  bad <- !is.finite(xy[,1]) | !is.finite(xy[,2])
  ## but we must identify the bad xy in the index
  if (any(bad)) ib <- ib[,-which(bad)]
  ## the scale function must not propagate NA
  xx <- scl(xy[c(ib),1])
  yy <- scl(xy[c(ib),2])
  ## we need a identifier grouping for each 4-vertex polygon
  id <- rep(seq_len(ncol(ib)), each  = nrow(ib))
  grid::grid.newpage()

  ## we also have to deal with any values that are NA
  ## because they propagate to destroy the id
  cols <- viridis::viridis(100)[scl(values(x)) * 99 + 1]
  if (any(is.na(cols))) {
  colsna <- rep(cols, each = nrow(ib))
  bad2 <- is.na(colsna)
  xx <- xx[!bad2]
  yy <- yy[!bad2]
  id <- id[!bad2]
  cols <- cols[!is.na(cols)]
  }
  ## turn off col to avoid plotting pixel boundaries
  grid::grid.polygon(xx, yy, id,
               gp = grid::gpar(col = NA, fill = cols))

}

sst <- readsst(Sys.Date() - (10:1))
e <- projectExtent(crop(sst, extent(120, 150, -80, 10)), "+proj=ortho +lon_0=147 +lat_0=-42 +datum=WGS84")
plot(sst[[1]])
a <- crop(sst, sp::spTransform(spex::spex(e), projection(sst)))
for (i in seq_len(nlayers(a))) {
meshplot_discrete(a[[i]], crs = "+proj=laea +lon_0=147 +lat_0=-42 +datum=WGS84")
}


meshplot_discrete(a[[1]], crs = "+proj=laea +lon_0=147 +lat_0=-42 +datum=WGS84")

