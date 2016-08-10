f <- "http://eoimages.gsfc.nasa.gov/images/imagerecords/73000/73909/world.topo.bathy.200412.3x5400x2700.png"
lfile <- file.path("data-raw/bluemarble", basename(f))
if (!file.exists(lfile)) download.file(f, lfile, mode = "wb")
library(raster)
bluemarble0 <- setExtent(brick(lfile), extent(-180, 180, -90, 90))
projection(bluemarble0) <- "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs +towgs84=0,0,0"
dummy <- raster(bluemarble0); res(dummy) <- res(dummy) * 10
decimate <- function(x, smash) {dim(x) <- dim(x)/smash; x}
bluemarble <- decimate(bluemarble0, smash = 5)
bluemarble <- setValues(bluemarble, extract(bluemarble0, coordinates(bluemarble)))

writeRaster(bluemarble, "inst/extdata/bluemarble.tif", options = "COMPRESS=LZW", overwrite = TRUE)


qm <- gris::quadmeshFromRaster(bm)

#qm <- gris::quadmeshFromRaster(r)
segquad <- function(ib) {
  m <- matrix(ib[rep(c(1, 2, 2, 3, 3, 4, 4, 1) , ncol(ib)) + rep(seq(ncol(ib))-1, each = 8) * 4], ncol = 2, byrow = TRUE)
  m[!duplicated(m), ]
}

clamp <- function(x, min, max) {x[x < min] <- min; x[x > max] <- max; x}
qm$vb[1,] <- clamp(qm$vb[1,], -179.9, 179.9)
qm$vb[2,] <- clamp(qm$vb[2,], -89.9, 89.9)

ps <- pslg(t(qm$vb[1:2, ]), S = segquad(qm$ib) )
tri <- RTriangle::triangulate(ps)

plot(tri$P, type = "n")
cents <- t(apply(tri$T, 1, function(x) apply(tri$P[x, ], 2, mean)))
cols <- extract(bluemarble, cents)
col <- apply(cols, 1, function(x) rgb(x[1], x[2], x[3], max = 256))


laeaverts <- rgdal::project(tri$P, "+proj=laea +ellps=WGS84")

 plot(laeaverts, type = "n")
# for (i in seq(nrow(tri$T))) polypath(laeaverts[tri$T[i, ], ], col = col[i], border = NA)
 for (i in seq(nrow(tri$T))) polypath(laeaverts[tri$T[i, ], ], border = col[i])
 
