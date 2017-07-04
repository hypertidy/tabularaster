##devtools::install_github("mdsumner/pathological@list_files")
dp <- ""

files <- pathological::list_files(dp, pattern = "tif$", ignore.case = TRUE, recursive = TRUE)
#library(dplyr)
#files %>% distinct(basename(filename))


## here we get the SpatialPolygons extent of every file
library(spex)
exts <- lapply(files$filename, function(x) spex(raster(x)))

## build one layer, in Web Mercator
## todo: get the specific projection loot per file

exts_wm <- do.call(rbind, lapply(exts, function(a) sp::spTransform(a, "+init=epsg:3857")))
exts_wm$filename <- files$filename

## grain buffers
grain <- 500
buf <- 50

## now, tabularaster wasn't enough
## we need: 
## spex:: sparse polygonize (DONE)
## tabularaster: polygons as a service, just generate from cell numbers as needed

#devtools::install_github("hypertidy/tabularaster")
library(tabularaster)
template_grid <- raster(buffer_extent(extent(exts_wm), grain), res = grain)
#template_grid[] <- seq_len(ncell(template_grid))
template_grid[cn$cell_] <- cn$cell_
cn <- cellnumbers(template_grid, exts_wm[1:10, ])

ptile <- spex(extent(rep(c(xyFromCell(template_grid, 1462645)), each = 2) + c(-1, 1, -1, 1) * grain/2), 
     crs = projection(template_grid))
#tmp <- over(SpatialPoints(coordinates(raster(buffer_extent(extent(exts_wm), grain), res = grain)), 
#                   proj4string = CRS(projection(exts_wm))), exts_wm)


#tiles <- qm_rasterToPolygons(raster(buffer_extent(extent(exts_wm), grain), 
#                                       crs = projection(exts_wm), res = grain))
