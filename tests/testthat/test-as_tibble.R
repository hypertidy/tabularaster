library(testthat)
context("as_tibble")
library(tibble)
library(tabularaster)
library(raster)
test_that("conversion to tibble from raster", {
   as_tibble(raster::raster(volcano)) %>% expect_s3_class("tbl_df") %>% expect_named(c("cellvalue", "cellindex"))
   expect_message(  as_tibble(raster::raster(volcano), dim = TRUE, split_date = TRUE), "not convertible to a Date or POSIXct")
      as_tibble(raster::raster(volcano), dim = TRUE, split_date = FALSE) %>%   expect_named(c("cellvalue", "cellindex", "dimindex"))
      as_tibble(raster::raster(volcano), dim = FALSE, split_date = FALSE) %>%  expect_named(c("cellvalue", "cellindex")) 
   
   as_tibble(setZ(raster::raster(volcano), Sys.Date()), cell = TRUE)  %>%  expect_named(c("cellvalue", "cellindex")) 
   as_tibble(setZ(raster::raster(volcano), Sys.Date()), dim = TRUE)  %>%  expect_named(c("cellvalue", "cellindex", "dimindex")) 
   as_tibble(setZ(raster::raster(volcano), Sys.Date()), dim = TRUE, cell = FALSE)  %>%  expect_named(c("cellvalue",  "dimindex")) 
   
  expect_silent( as_tibble(setZ(brick(raster::raster(volcano), raster::raster(volcano)), Sys.Date() + 1:2), cell = TRUE))
  expect_named( as_tibble(setZ(brick(raster::raster(volcano), raster::raster(volcano)), Sys.Date() + 1:2), 
                           cell = TRUE, split_date = TRUE), 
                c("cellvalue", "cellindex", "year", "month", "day"))
  
  expect_named(as_tibble(raster::raster(volcano), xy = TRUE, value = FALSE), c("cellindex", "x", "y"))
})
