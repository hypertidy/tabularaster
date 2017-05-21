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

test_that("decimate is available", {
  decimate(r, 10) %>% expect_s4_class("RasterLayer")
})

library(spex)
library(raster)
library(dplyr, warn.conflicts = FALSE, quietly = TRUE)
library(sf, quietly = TRUE, verbose = FALSE)
psf <- polygonize(aggregate(r, fact = 16)) 

#csf <- ct_triangulate(psf, a = .0001)

context('new idioms')
test_that("extent of sf works", {
  extent(psf) %>% expect_s4_class("Extent")
})

test_that("spex sf works", {
  spex(psf) %>% expect_s4_class("SpatialPolygonsDataFrame")
})


mp <- st_sf(a = 1:2, geometry = st_sfc(st_multipoint(cbind(0, 1:2)), st_multipoint(cbind(0, 1:4))))
r2 <- setExtent(raster(volcano), extent(-2, 10, -5, 14))

test_that("extract of sf works", {
  cellnumbers(r, psf[c(1, 10), ]) %>% expect_named(c("object_", "cell_")) 
  ll <- extract(r, psf) %>% expect_length(24) %>% lengths()
  expect_that(sum(ll), equals(5307))
  extract(r, as(psf, "Spatial")) %>% lengths()
  ## awaiting fix in spbabel https://github.com/r-gris/tabularaster/issues/8
  ##cellnumbers(r2, mp)
})
