library(raster)
library(rastertable)
voltab <- rastertable(raster(volcano))
devtools::use_data(voltab)
