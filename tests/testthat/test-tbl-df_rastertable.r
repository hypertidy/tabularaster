# ## not implemented, these operations break the model
# ## or work fine with tbl default
# ##--# S3method("$",tbl_df)
# ##--# S3method("[",tbl_df)
# ##--# S3method("[[",tbl_df)
# ##--# S3method(all.equal,tbl_df)
# ##--# S3method(as.data.frame,tbl_df)
# ##- # S3method(as_data_frame,tbl_df)
# # S3method(print,tbl_df)
# library(dplyr)
# library(rastertable)
# 
# rtcopy <- rt <- voltab
# test_that("fall back to tbl_df methods works", {
#   expect_that(rt$cell_, is_a("integer"))
#   expect_that(rt[,1], is_a("tbl_df"))
#   expect_that(rt[[1]], is_a("integer"))
#   expect_true(all.equal(rt, rtcopy))
#   expect_true(grepl("Incompatible type", all.equal(rt, rtcopy * 1)))
#   expect_silent(as.data.frame(rt))
#   expect_silent(as_data_frame(rt))
# })
