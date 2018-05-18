context("test-lines.R")

library(tabularaster)
library(raster)
library(dplyr)
data("rastercano")
data("polycano")
#cells <- cellnumbers(rastercano, polycano[4:5, ])



test_that("multiplication works", {
  cells <- cellnumbers(rastercano, as(polycano[4:5, ], "SpatialLinesDataFrame"))
  expect_s3_class(cells, "tbl_df")
})
