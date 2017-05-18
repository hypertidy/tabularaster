context("all-major-funs")

r <- rastercano
raster::projection(r) <- "+proj=lcc +lon_0=10 +lat_0=-10 +lat_1=0 +lat_2=4 +ellps=sphere"

p <- polycano[5:7, ]
raster::projection(p) <- "+proj=lcc +lon_0=10 +lat_0=-10 +lat_1=0 +lat_2=4 +ellps=sphere"

test_that("cellnumber extraction is available", {
  cellnumbers(r, p)
})

test_that("decimate is available", {
  decimate(r, 10)
})

library(spex)
library(raster)
library(dplyr, warn.conflicts = FALSE, quietly = TRUE)
library(sf, quietly = TRUE, verbose = FALSE)
psf <- polygonize(aggregate(r, fact = 16)) 

#csf <- ct_triangulate(psf, a = .0001)

context('new idioms')
test_that("extent of sf works", {
  extent(psf)
})

test_that("spex sf works", {
  spex(psf)
})

test_that("extract of sf works", {
  #cellnumbers(r, psf)
  #extract(r, psf) %>% lengths()
  ## it's not the same, yet
  #extract(r, as(psf, "Spatial")) %>% lengths()
})
