## some reprojection timing comparisons
scl <- function(x) {
  rg <- range(x, na.rm = TRUE);
  (x - rg[1])/diff(rg)
}

library(quadmesh)
library(raster)
r1 <- setExtent(raster(matrix(oisst$sst, ncol = 1440, byrow = TRUE), crs = "+init=epsg:4326"), 
               extent(-180, 180, -90, 90))

prj <- "+proj=laea +lon_0=130 +lat_0=-90 +ellps=WGS84"
pr <- projectRaster(r1, crs = prj)
# user  system elapsed 
# 9.378   2.345  11.724
system.time(plot(pr, col = viridis::viridis(100)))
# user  system elapsed 
# 2.612   0.012   2.622 

library(grid)
system.time({
qm <- quadmesh(r1)
# user  system elapsed 
# 2.390   0.283   2.674
ib <- qm$ib
xy <- t(qm$vb[1:2, ])
xy <- rgdal::project(xy, prj)
## we have to remove any infinite vertices
## as this affects the entire thing
bad <- !is.finite(xy[,1]) | !is.finite(xy[,2])
## but we can identify the bad xy in the index
if (any(bad)) ib <- ib[,-which(bad)]
## the scale function must not propagate NA
x <- scl(xy[c(ib),1])
y <- scl(xy[c(ib),2])
## we need a identifier grouping for each 4-vertex polygon
id <- rep(seq_len(ncol(ib)), each  = nrow(ib))
grid.newpage()
## turn off col to avoid plotting pixel boundaries
grid.polygon(x, y, id, 
             gp = gpar(col = NA, fill = viridis::viridis(100)[scl(values(r1)) * 99 + 1]))
})
# user  system elapsed 
# 15.594   0.579  16.173

#system.time(p <- spex::polygonize(r1, na.rm = TRUE))
# user  system elapsed 
# 21.707   1.747  23.443 

#library(sf)
#system.time(pp <- st_transform(p, prj))
# user  system elapsed 
# 24.126   0.836  24.941 

#system.time(plot(pp, border = NA))
# user  system elapsed 
# 118.231   7.565 125.746 
