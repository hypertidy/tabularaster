x <- sst_regions
coords <- silicate::sc_coord(x) 
gmap <- purrr::transpose(gibble::gibble(sf::st_as_sf(x)) %>% 
                           mutate(start = cumsum(nrow)) %>% 
                           mutate(start = start - min(start)))


cell_point_ring_extent <- function(x, grid) {
  bb <- c(range(x[["x_"]]), range(x[["y_"]]))
  tibble::as_tibble(xyFromCell(grid, cellsFromExtent(grid, extent(bb))))
}


slice_coords <- function(coords, gm) {
  dplyr::slice(coords, seq_len(gm[["nrow"]]) + gm[["start"]])
}
grid_points <- function(coords, grid) {
    cell_point_ring_extent(coords, grid = grid)
}

pip <- function(pts, ring) {
  sp::point.in.polygon(pts[["x"]], pts[["y"]], 
                       ring[["x_"]], ring[["y_"]])
}
pip(grid_points(slice_coords(coords, gmap[[2]]), ghrsst), 
    slice_coords(coords, gmap[[2]]))


do_it <- function(polys, grid) {
  coords <- silicate::sc_coord(polys) 
  gmap <- purrr::transpose(gibble::gibble(sf::st_as_sf(polys)) %>% 
                             mutate(start = cumsum(nrow)) %>% 
                             mutate(start = start - min(start)))
  purrr::map(seq_len(nrow(polys)), 
             function(index) {
               cds <- slice_coords(coords, gmap[[index]])
               pip(grid_points(cds, grid), cds)
  })
  
  
}

system.time(a <- do_it(sst_regions, ghrsst))
library(velox)
system.time({
  vx <- velox(ghrsst)
  vx$rasterize(sst_regions, field = "ghrsst")
  vx$as.RasterLayer()
})

cell_point_in_extent <- function(x, grid) {
  tibble::as_tibble(xyFromCell(grid, cellsFromExtent(grid, extent(bbox(x)))))
}

x <- sst_regions


polys <- x@polygons



#cell_point_in_extent(polys[[1]], ghrsst)
## breadth first
tmp <- purrr::map_df(polys, cell_point_in_extent, grid = ghrsst, 
              .id = "object_")
#tmp <- SpatialPoints(tmp[c("x", "y")], proj4string = CRS(projection(x)))
coordinates(tmp) <- c("x", "y")
projection(tmp) <- projection(ghrsst)

tmp[["keep"]] <- !is.na(over(tmp, geometry(x)))
tmp <- tmp[tmp$keep, ]
library(dplyr)
result <- tibble(object_ = tmp[["object_"]], 
                 cell = cellFromXY(ghrsst, tmp)) %>% 
  distinct(cell_)



purrr::map_df(polys, 
              function(x) 
                tibble::tibble(cell = cellsFromExtent(ghrsst, 
                                                      extent(bbox(x)))), .id = "object_")