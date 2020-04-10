r <- raster::raster(volcano)
test_that("emoji works", {
  expect_equal(dim(decimate(r)), c(9, 6, 1))
  expect_equal(dim(decimate(r, 3)), c(29, 20, 1))
  
})
