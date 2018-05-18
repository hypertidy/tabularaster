library(testthat)
context("all-major-funs")

r <- rastercano
raster::projection(r) <- "+proj=lcc +lon_0=10 +lat_0=-10 +lat_1=0 +lat_2=4 +ellps=sphere"

p <- polycano[5:7, ]
raster::projection(p) <- "+proj=lcc +lon_0=10 +lat_0=-10 +lat_1=0 +lat_2=4 +ellps=sphere"

test_that("cellnumber extraction is available", {
  tib <- cellnumbers(r, p[1, ]) %>% expect_named(c("object_", "cell_")) %>% expect_s3_class("tbl_df") 
  expect_that(nrow(tib), equals(917L))
})



library(spex)
library(raster)
library(dplyr, warn.conflicts = FALSE, quietly = TRUE)
#library(sf, quietly = TRUE, verbose = FALSE)
psf <- polygonize(aggregate(r, fact = 16)) 

#csf <- ct_triangulate(psf, a = .0001)

context('new idioms')
test_that("extent of sf works", {
  extent(psf) %>% expect_s4_class("Extent")
})

test_that("spex sf works", {
  spex(psf) %>% expect_s4_class("SpatialPolygonsDataFrame")
})


#mp <- st_sf(a = 1:2, geometry = st_sfc(st_multipoint(cbind(0, 1:2)), st_multipoint(cbind(0, 1:4))))
mp <- structure(list(a = 1:2, geometry = structure(list(structure(c(0, 
                                                                    0, 1, 2), .Dim = c(2L, 2L), class = c("XY", "MULTIPOINT", "sfg"
                                                                    )), structure(c(0, 0, 0, 0, 1, 2, 3, 4), .Dim = c(4L, 2L), class = c("XY", 
                                                                                                                                         "MULTIPOINT", "sfg"))), n_empty = 0L, class = c("sfc_MULTIPOINT", 
                                                                                                                                                                                         "sfc"), precision = 0, crs = structure(list(epsg = NA_integer_, 
                                                                                                                                                                                                                                     proj4string = NA_character_), .Names = c("epsg", "proj4string"
                                                                                                                                                                                                                                     ), class = "crs"), bbox = structure(c(0, 1, 0, 4), .Names = c("xmin", 
                                                                                                                                                                                                                                                                                                   "ymin", "xmax", "ymax")))), .Names = c("a", "geometry"), row.names = 1:2, class = c("sf", 
                                                                                                                                                                                                                                                                                                                                                                                       "data.frame"), sf_column = "geometry", agr = structure(NA_integer_, class = "factor", .Label = c("constant", 
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        "aggregate", "identity"), .Names = "a"))


r2 <- setExtent(raster(volcano), extent(-2, 10, -5, 14))
library(sf)
test_that("extract of sf works", {
  cellnumbers(r, psf[c(1, 10), ]) %>% expect_named(c("object_", "cell_")) 
  ll <- extract(r, psf[1:5, ]) %>% expect_length(5) %>% lengths()
  expect_that(sum(ll), equals(1232))
  e <- extract(r, as(psf, "Spatial")[1:6, ]) %>% lengths()
  expect_equal(e, c(256L, 256L, 256L, 208L, 256L, 256L))
  ## awaiting fix in spbabel https://github.com/r-gris/tabularaster/issues/8
  cellnumbers(r2, mp) %>% expect_named(c("object_", "cell_"))
})

