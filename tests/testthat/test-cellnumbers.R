library(raster)
library(dplyr)

context("cellnumbers")

sfc <- structure(list(structure(cbind(1, 1), class = c("XY", "POINT", "sfg"))), precision = 0, bbox = structure(c(xmin = 1, ymin = 1, xmax = 1, ymax = 1), class = "bbox"),
                 crs = structure(list(epsg = NA_integer_, proj4string = NA_character_), class = "crs"),
                 n_empty = 0L, class = "sfc")

test_that("cell numbers for points works", {
  qk_mx <- as.matrix(quakes[,2:1])
  hres_ras <- raster(extent(qk_mx) + 1, res = 1, crs = "+init=epsg:4326")
  raster_tib <- tibble(cell_ = cellFromXY(hres_ras, qk_mx))
  expect_message(tabula_tib <- cellnumbers(hres_ras, qk_mx), "projections not the same")
  expect_identical(raster_tib$cell_, tabula_tib$cell_)
  expect_silent(aa <- cellnumbers(ghrsst, sfc)$cell_)
  expect_equal(aa, NA_integer_)
  
  expect_null(mat2d_f(NULL))
})


