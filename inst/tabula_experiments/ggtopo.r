#' Return a table version of a raster. 
#'
#' Return a table for a built-in raster for a given extent at a given resolution. 
#' 
#' The \code{mapres} defaults to 1, and cannot be lower than the native resolution, see \code{etopo2$temp}. 
#' @param ex Extent or vector c(xmin, xmax, ymin, ymax) see \code{\link[raster]{extent}}
#' @param mapres resolution in pixel size of desired map
#'
#' @return data frame with columns
#' @export
#'
#' @examples
#' topotab()
#' tab <- topotab(extent(120, 160, -70, -30), mapres = 0.5)
#' ## avoid land?
#' tab <- dplyr::mutate(tab, topo = ifelse(topo < 0, topo, NA))
#' ggplot(tab)  + aes(x = x, y = y, fill = topo, width = width, height = height) +
#' scale_fill_gradient(low = "black", high = "white") + geom_raster()
#' 
#' g <- ggplot(tab)  + aes(x = x, y = y, fill = topo, width = width, height = height) + geom_raster()
#' g + scale_fill_gradient(low = "black", high = "white") 
#' g + scale_fill_gradientn(colours = topo.colors(100))
#' 
topotab <- function(ex, mapres = 1) {

 # tab  <- read_feather(system.file("extdata/etopo2.feather", package = "gtopo"))
 # temp <- read_feather((system.file("extdata/etopo2_template.feather", package = "gtopo")))
 tab <- etopo2$topo
 temp <- etopo2$template
 if (missing (ex)) ex <- extent(temp$xmin, temp$xmax, temp$ymin, temp$ymax)
   template <- raster(nrow = temp$nrow, ncol = temp$ncol, crs = temp$crs, 
                     xmn = temp$xmin, xmx = temp$xmax, ymn = temp$ymin, ymx = temp$ymax)
  r <- crop(template, ex)
  if (mapres < min(res(r))) stop(sprintf("mapres cannot be lower than %f", min(res(r))))
  res(r) <- mapres
cls <- cellFromXY(template, coordinates(r))
  tb <- dplyr::slice(tab, cls) 
  xy <- xyFromCell(template, cls)
  tb$x <- xy[,1]
  tb$y <- xy[,2]
  #tb <- rename(tb, fill = topo) 
  tb <- mutate(tb, width = mapres/2, height = mapres/2)
  ##ggplot(tb)  + aes(x = x, y = y, fill = topo, width = mapres/2, height = mapres / 2)  + geom_raster()
  tb
}

#library(RSQLite)
#db <- src_sqlite("etopo2.sqlite3", create = TRUE)
#copy_to(db, tab)
#Contact GitHub 
