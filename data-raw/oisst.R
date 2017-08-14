library(raadtools)
sfiles <- sstfiles()
ind <- min(grep("preliminary", sfiles$fullname))
oisst <- tibble::tibble(sst = values(raster(sfiles$fullname[ind - 1])))

##"data/eclipse.ncdc.noaa.gov/pub/OI-daily-v2/NetCDF/2017/AVHRR/avhrr-only-v2.20170729.nc"
devtools::use_data(oisst, compress = "bzip2")


