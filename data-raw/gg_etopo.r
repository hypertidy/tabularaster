##topo <- raadtools::readtopo("etopo2")

library(dplyr)
template <- raster(topo)
etopo2 <- data_frame(topo = as.integer(values(topo)))


library(feather)
write_feather(etopo2, "inst/extdata/etopo2.feather")
template <- data_frame(nrow = nrow(topo), ncol = ncol(topo), xmin = xmin(topo), ymin = ymin(topo), 
                       xmax = xmax(topo), ymax = ymax(topo), crs = projection(topo))

write_feather(template, "inst/extdata/etopo2_template.feather")
