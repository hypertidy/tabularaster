## get the raw files by download

library(raster)
# readav <- function(x) {
#   su <- stack(x, varname = "u")
#    b <- brick(stack(su, stack(x, varname = "v")))
#    names(b) <- c("u", "v")
#    rastertable(b)
# }
readav <- function(x, vn) {
  suppressWarnings(su <- stack(x, varname = vn))
  rastertable(su)
}

library(dplyr)
f <- list.files("data-raw/aviso", pattern = "nc$", full.names = TRUE)
u <- bind_rows(lapply(f, readav, "u"), .id = "index_")
v <- bind_rows(lapply(f, readav, "v"), .id = "index_")
names(u)[3] <- "u_"
u$v_ <- v$value_
uv <- u %>% filter(!is.na(u_))
rm(u, v)

rep
rqraster <- function(files) {
  x <-  rastertable:::rastertabletemplate(raster::raster(files[1]))
  d <- x[rep.int(seq(nrow(x)), times = length(files)), ]
}
