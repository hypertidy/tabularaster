library(testthat)
context("all-major-funs")

r <- rastercano
r@crs@projargs <- "+proj=lcc +lon_0=10 +lat_0=-10 +lat_1=0 +lat_2=4 +datum=WGS84"

p <- polycano[5:7, ]
p@proj4string@projargs <- "+proj=lcc +lon_0=10 +lat_0=-10 +lat_1=0 +lat_2=4 +datum=WGS84"

test_that("cellnumber extraction is available", {
  expect_message(tib <- cellnumbers(r, p[1, ]) %>% expect_named(c("object_", "cell_")) %>% expect_s3_class("tbl_df") )
  expect_that(nrow(tib), equals(917L))
})




