rastercano <- raster(volcano)
polycano <- rasterToPolygons(r %/% 15, dissolve = TRUE)
names(polycano) <- "volcano_elevation"
devtools::use_data(rastercano, compress = "bzip2", overwrite = TRUE)
devtools::use_data(polycano,compress = "xz", overwrite = TRUE)
