# library(testthat)
# context("rastertable creation and behaviour")
# library(dplyr)
# library(rastertable)
# library(raster)
# r <- raster(volcano)
# br <- brick(r)
# sr <- stack(r)
# 
# rt <- rastertable(r)
# brt  <- rastertable(br)
# srt <- rastertable(sr)
# rt <- voltab
# test_that("rastertable works", {
#   rt %>%
#     expect_is("rastertable")
#   brt %>%
#     expect_is("rastertable")
#   srt %>%
#     expect_is("rastertable")
# })
# 
# test_that("size is correct for single layer rasters", {
#   expect_that(dim(rt), equals(dim(brt)))
#   expect_that(dim(rt), equals(dim(srt)))
#   expect_that(dim(brt), equals(dim(brt)))
# })
# 
# br3 <- brick(r, r, r)
# sr3 <- stack(r, r, r)
# test_that("size is correct for multi layer rasters", {
#   expect_that(dim(rastertable(br3)), equals(c(prod(dim(br3)), 3)))
#   expect_that(dim(rastertable(sr3)), equals(c(prod(dim(br3)), 3)))
# })
