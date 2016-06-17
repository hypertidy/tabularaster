f <- "http://res.freestockphotos.biz/pictures/16/16214-illustration-of-a-shark-pv.png"
dir.create("inst/extdata/sharkcano", recursive = TRUE, showWarnings = FALSE)
download.file(f, file.path("inst/extdata/sharkcano", basename(f)), mode = "wb")
r <-  brick(file.path("inst/extdata/sharkcano", basename(f)))[[2]]

## now flatten this thing as an illustration of grid cell encoding
library(dplyr)
sharkcano <- data_frame(cell_ = seq(ncell(r)), byte = values(r)) %>% filter(byte > 0)
attr(sharkcano, "rasterdim") <- dim(r)[1:2]
devtools::use_data(sharkcano, overwrite = TRUE, compress = "xz")
