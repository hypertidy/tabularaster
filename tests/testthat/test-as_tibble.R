context("as_tibble")

test_that("multiplication works", {
   as_tibble(raster::raster(volcano))
   
   as_tibble(setZ(raster::raster(volcano), Sys.Date()), cell = TRUE)
   
   as_tibble(setZ(brick(raster::raster(volcano), raster::raster(volcano)), Sys.Date() + 1:2), cell = TRUE)
   
})
