## create a nested raster in a single row with all metadata and attribute table
## the idea was born from thinking about a single row table, 
## representing a single cell that is the entire extent
## with recursively nested tables that store progressing detailed versions

## this could easily be flattened into a single table, with cell, level, value - as in Eonfusion
## but the ability to store an entire ecosystem of rasters in a single table is interesting

#' library(raster)
#' library(maptools)
#' library(tibble)
#' library(dplyr)
#' data(wrld_simpl)
#' r <- rasterize(wrld_simpl, raster(nrow = 256, ncol = 512))
#' x <- rastertab(r)
#' plot(x, 6)

## buffer out to whole multiples of 2
datatab <- function(x) {
  tibble(val = values(x))
}
celltab <- function(x) {
  tibble(cell = seq(ncell(x)))
}

rasterfrom1row <- function(x) {
  do.call(raster, x[, c("xmn", "xmx", "ymn", "ymx", "nrow", "ncol", "crs")])
}
#rastertab <- function(x, ...) UseMethod("rastertab")
#rastertab.RasterLayer <- function(x) {
# x <- tibble(xmn = xmin(x), xmx = xmax(x), 
#                    ymn = ymin(x), ymx = ymax(x), 
#                    nrow = nrow(x), ncol = ncol(x), 
#                    crs = projection(x), 
#                    metadata = levels(x), 
#                    cells = list(dplyr::bind_cols(datatab(x), celltab(x)) %>% filter(!is.na(val)))


 #class(x) <- c("rastertab", class(x))

# x
#}
plot.rastertab <- function(x, y = 1, ...) {
  stopifnot(length(y) == 1)
  x <- x[1L, ]
  actualraster <- rasterfrom1row(x)
  acells <- x$cells[[1]]
  actualraster[acells$cell] <- x$metadata[[1]][acells$val , y]
  plot(actualraster, ...)
}


