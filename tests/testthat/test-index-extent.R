context("index-extent")

library(raster)
r <- setExtent(raster(volcano), extent(100, 150, -80, -30))
test_that("multiplication works", {
  index_extent(r, extent(120, 130, -50, -40))
})
