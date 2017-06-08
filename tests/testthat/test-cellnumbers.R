library(raster)
library(dplyr)
library(spex)  ## devtools::install_github("mdsumner/spex")
# repeater <- rep(seq_len(nrow(quakes)), 2)
# qk_mx <- jitter(as.matrix(quakes[,2:1])[repeater, ], 135)
# #qk_mx <- data.matrix(quakes[,2:1])
# hres_ras <- raster(spex::buffer_extent(extent(qk_mx), 1), res = 1, crs = "+init=epsg:4326")
# 
# library(tibble)
# cells <- tibble(cell_ = cellFromXY(hres_ras, qk_mx)) %>% 
#   mutate(mag = quakes$mag[repeater]) %>% 
#   group_by(cell_) %>% 
#   summarize(n_quakes = n(), mean_mag = mean(mag))
# 
# ## raster to polygon (one poly per pixel via indexed quadmesh)
# library(sf)
# poly <- spex::qm_rasterToPolygons(hres_ras)
# poly$n_quakes <- poly$mean_mag <- NA_real_
# poly$layer <- NULL
# poly$n_quakes[cells$cell_] <- cells$n_quakes
# poly$mean_mag[cells$cell_] <- cells$mean_mag
# 
# library(mapview)
# mapview(poly %>% filter(!is.na(n_quakes)), zcol="n_quakes", na.color="gray")
# 

context("cellnumbers")


test_that("cell numbers for points works", {
  qk_mx <- as.matrix(quakes[,2:1])
  hres_ras <- raster(spex::buffer_extent(extent(qk_mx), 1), res = 1, crs = "+init=epsg:4326")
  raster_tib <- tibble(cell_ = cellFromXY(hres_ras, qk_mx))
  expect_warning(tabula_tib <- cellnumbers(hres_ras, qk_mx), "projections not the same")
  expect_identical(raster_tib$cell_, tabula_tib$cell_)
})
