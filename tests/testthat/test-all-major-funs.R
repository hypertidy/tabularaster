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
psf <- polygonize(aggregate(r, fact = 4)) %>% 
  mutate(int = as.integer(layer) %/% 16) %>% 
  group_by(int) %>% 
  summarize() %>% 
  st_cast()


#csf <- ct_triangulate(psf, a = .0001)


context("there are features defined in tests here, install properly!")
extent.sf <- function(x, ...) {
  raster::extent(attr(x[[attr(x, "sf_column")]], "bbox")[c(1, 3, 2, 4)])
}
setMethod(f = "extent", signature = "sf", definition = extent.sf)
spex.sf <- function(x, crs, ...) {
  spex(extent(x), attr(x[[attr(x, "sf_column")]], "crs")$proj4string)
}
extract.sf <- function(x, y, ...) {
  cn <- cellnumbers(x, y)
  if (nrow(cn) > length(unique(cn$object_))) {
    out <- split(extract(x, cn$cell_), cn$object_)
  } else {
    out <- extract(x, cn$cell_)
  }
  out
}
setMethod(f = "extract", signature = c("BasicRaster", "sf"), definition = extract.sf)
context('new idioms')
test_that("extent of sf works", {
  extent(psf)
})

test_that("spex sf works", {
  spex(psf)
})

test_that("extract of sf works", {
  cellnumbers(r, psf)
  extract(r, psf)
  ## it's not the same, yet
  extract(r, as(psf, "Spatial"))
})
