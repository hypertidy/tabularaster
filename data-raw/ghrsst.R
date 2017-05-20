library(raadtools) ## requires significant back-end set up 
sink("data-raw/ghrsst-readme.txt")
print(readghrsst("2017-04-28"))
sink(NULL)

ghrsst <- readghrsst("2017-04-28", xylim = extent(140, 180, -65, -30))
#ghrsst <- aggregate(ghrsst, fact = 32)
#ghrsst <- focal(sst1, matrix(1, 3, 3), fun = median, na.rm = TRUE)
ghrsst <- aggregate(ghrsst, fun = median, fact = 8, na.rm = FALSE)
ghrsst <- ghrsst - 273.15

library(spex)
sst_regions <- sfdct::ct_triangulate(sf::st_as_sf(spex(ghrsst)), a = 100)
#plot(ghrsst, col = viridis::viridis(100))
#plot(st_geometry(sst_regions), add = TRUE, col = NA)
library(sf)
sst_regions <- as(st_cast(sst_regions), "Spatial")
sst_regions$ghrsst <- seq(nrow(sst_regions))
projection(ghrsst) <- projection(sst_regions)
devtools::use_data(sst_regions, compress = "xz")
devtools::use_data(ghrsst, compress = "xz")

