library(dplyr)
library(sf)
f <- raadfiles::thelist_files("shp", "parcel") %>% 
  slice(1:10)
key_col <- "vertex_"
V_names <- c("x_", "y_")
o <- silicate::PATH(read_sf(f$fullname[1]))
for (i in 2:nrow(f)) {
  o2 <- silicate::PATH(read_sf(f$fullname[i]))
  o <- purrr::map(purrr::transpose(list(o, o2)), bind_rows)
  maindata <- unjoin::unjoin_(o$path_link_vertex %>% inner_join(o$vertex), 
                              V_names, key_col = key_col)
  dd <- maindata[["data"]]
  id <- silicate::sc_uid(n = nrow(dd))
  o$vertex <- dplyr::mutate(maindata[[key_col]], vertex_ = id[maindata[[key_col]][[key_col]]])
  o$path_link_vertex <- dplyr::mutate(maindata[["data"]], vertex_ = id[dd[[key_col]]])
  rm(dd, id)
  print(i)
}





P <- purrr::map(purrr::transpose(P), bind_rows)
v <- P$path_link_vertex %>% inner_join(P$vertex)
key_col <- "vertex_"





library(dplyr)
library(sf)
P <- raadfiles::thelist_files("shp", "parcel") %>% 
  slice(1:10) %>% 
  pull(fullname) %>% 
  purrr::map(function(x) silicate::PATH(read_sf(x)))

P <- purrr::map(purrr::transpose(P), bind_rows)
v <- P$path_link_vertex %>% inner_join(P$vertex)
key_col <- "vertex_"
V_names <- c("x_", "y_")
maindata <- unjoin::unjoin_(v, V_names, key_col = key_col)
dd <- maindata[["data"]]
id <- silicate::sc_uid(n = nrow(dd))
P$vertex <- dplyr::mutate(maindata[[key_col]], vertex_ = id[maindata[[key_col]][[key_col]]])
P$path_link_vertex <- dplyr::mutate(maindata[["data"]], vertex_ = id[dd[[key_col]]])
rm(v, dd)





library(spbabel)
x <- sf::st_as_sf(sp(holey))
library(raster)
library(dplyr)
library(tabularaster)
r <- setValues(raster(extent(x), res = 0.1), NA_real_)

path <- silicate::PATH(x)

mk_vertex_pool <- function(path) {
  function(path_tab) {
    tibble::as_tibble(path_tab) %>% 
      inner_join(path$path_link_vertex) %>% 
      inner_join(path$vertex)
  }
}
vertex_pool <- mk_vertex_pool(path)









library(spbabel)
x <- sf::st_as_sf(sp(holey))
library(raster)
library(dplyr)
library(tabularaster)
r <- setValues(raster(extent(x), res = 0.1), NA_real_)

path <- silicate::PATH(x)



coords <- path$path %>% dplyr::select(path_, ncoords_, object_) %>% 
  inner_join(path$path_link_vertex, "path_") %>% 
  inner_join(path$vertex, "vertex_")
## gmap is the summary per ring
gmap <-  path$path %>% mutate(order = row_number()) %>% dplyr::select(path_, subobject) %>% inner_join(coords %>% 
  group_by(ncoords_,  object_, path_) %>% 
  summarize(xmin = min(x_), xmax = max(x_), ymin = min(y_), ymax = max(y_)) %>% 
  ungroup())
## omap is the summary per object
omap <- gmap %>% group_by(object_) %>% 
  summarize(xmin = min(xmin), xmax = max(xmax), 
            ymin  = min(ymin), ymax = max(ymax))


graster <- function(x, grid) {
  cellsFromExtent(grid, extent(x$xmin, x$xmax, x$ymin, x$ymax))
}
## these are the index 
idxs <- split(gmap, gmap$object_) %>% purrr::map(function(x)   {
  idx <- NULL
  exclude <- c(1, diff(x$subobject)) == 0
  for (irow in seq_len(nrow(x))) {
    if (exclude[irow]) {
      idx <- setdiff(idx, graster(x[irow, ], r))
    }  else {
      idx <- c(idx, graster(x[irow, ], r))
    }
  }

  tibble::tibble(object_ = x$object_[1], cell = idx)
})




## what if we took the silicate idea seriously for point in polygon lookup?

## we would have a function that took points and a ring and returned a value
point_in_polygon <- function(pts, poly) {
  inn <- sp::point.in.polygon(pts[["x_"]], pts[["y_"]], poly[["x_"]], poly[["y_"]])
  tibble::tibble(test = inn)
}


## we would avoid testing rings whose bounding box didn't intersect our points
library(spbabel)
x <- sf::st_as_sf(sp(holey))
path <- silicate::PATH(x)
coords <- path$path %>% 
  inner_join(path$path_link_vertex, "path_") %>% 
  inner_join(path$vertex, "vertex_")
gmap <-  coords %>% 
   group_by(ncoords_, object_, path_) %>% 
   summarize(xmin = min(x_), xmax = max(x_), ymin = min(y_), ymax = max(y_)) %>% 
   ungroup()
coords <- coords %>% dplyr::select(path_, x_, y_) 
library(raster)
library(tabularaster)
r <- setValues(raster(extent(x), res = 0.1), NA_real_)
query <- as_tibble(r , xy = TRUE, na.rm = FALSE) %>% 
   transmute(x_ = x, y_ = y, id = row_number())
system.time({d <- purrr::map_df(purrr::transpose(gmap), 
           function(gm) {
             cds <- query %>% dplyr::filter(between(x_, gm$xmin, gm$xmax), 
                                            between(y_, gm$ymin, gm$ymax)) 
             if (nrow(cds) > 0) {
               ipath <- gm$path_
               polycoords <- coords %>% dplyr::filter(path_ == ipath)
               point_in_polygon(cds, polycoords) %>% mutate(path= ipath, id = cds$id) %>% 
                 filter(test == 1)
             } else {
               
             }
           }
) %>% dplyr::filter(test > 0)})


## all the points in d fall inside a path, so we have to remove any that belong to a hole
holes <- path$path %>% 
  dplyr::filter(subobject > 1L)
a <- d %>% anti_join(holes %>% inner_join(d, c("path_" = "path")), "id")  %>% arrange(test) %>% distinct(id, .keep_all = TRUE)
r[a$id] <- factor(a$path)
plot(r)
library(silicate)






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