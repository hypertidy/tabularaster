context("index-extent")

library(raster)
r <- setExtent(raster(volcano), extent(100, 150, -80, -30))
test_that("multiplication works", {
  expect_equal(index_extent(r, extent(120, 130, -50, -40)), 
               new("Extent", xmin = 24, xmax = 37, ymin = 52, ymax = 70))
})
