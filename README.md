
<!-- README.md is generated from README.Rmd. Please edit that file -->
tidyraster
==========

Extract cells from rasters and get a nice data frame.

``` r
library(tidyraster)
library(raster)
#> Loading required package: sp
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:raster':
#> 
#>     intersect, select, union
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
r <- raster(volcano)
p <- rasterToPolygons(r %/% 15, dissolve = TRUE)
#> Loading required namespace: rgeos
x <- cellnumbers(r, p)
#> Warning in `[<-`(`*tmp*`, cnt, value = p@polygons[[i]]@Polygons[[j]]):
#> implicit list embedding of S4 objects is deprecated

#> Warning in `[<-`(`*tmp*`, cnt, value = p@polygons[[i]]@Polygons[[j]]):
#> implicit list embedding of S4 objects is deprecated

#> Warning in `[<-`(`*tmp*`, cnt, value = p@polygons[[i]]@Polygons[[j]]):
#> implicit list embedding of S4 objects is deprecated

#> Warning in `[<-`(`*tmp*`, cnt, value = p@polygons[[i]]@Polygons[[j]]):
#> implicit list embedding of S4 objects is deprecated

#> Warning in `[<-`(`*tmp*`, cnt, value = p@polygons[[i]]@Polygons[[j]]):
#> implicit list embedding of S4 objects is deprecated

#> Warning in `[<-`(`*tmp*`, cnt, value = p@polygons[[i]]@Polygons[[j]]):
#> implicit list embedding of S4 objects is deprecated

#> Warning in `[<-`(`*tmp*`, cnt, value = p@polygons[[i]]@Polygons[[j]]):
#> implicit list embedding of S4 objects is deprecated

#> Warning in `[<-`(`*tmp*`, cnt, value = p@polygons[[i]]@Polygons[[j]]):
#> implicit list embedding of S4 objects is deprecated

#> Warning in `[<-`(`*tmp*`, cnt, value = p@polygons[[i]]@Polygons[[j]]):
#> implicit list embedding of S4 objects is deprecated

#> Warning in `[<-`(`*tmp*`, cnt, value = p@polygons[[i]]@Polygons[[j]]):
#> implicit list embedding of S4 objects is deprecated

#> Warning in `[<-`(`*tmp*`, cnt, value = p@polygons[[i]]@Polygons[[j]]):
#> implicit list embedding of S4 objects is deprecated

#> Warning in `[<-`(`*tmp*`, cnt, value = p@polygons[[i]]@Polygons[[j]]):
#> implicit list embedding of S4 objects is deprecated

#> Warning in `[<-`(`*tmp*`, cnt, value = p@polygons[[i]]@Polygons[[j]]):
#> implicit list embedding of S4 objects is deprecated

#> Warning in `[<-`(`*tmp*`, cnt, value = p@polygons[[i]]@Polygons[[j]]):
#> implicit list embedding of S4 objects is deprecated

#> Warning in `[<-`(`*tmp*`, cnt, value = p@polygons[[i]]@Polygons[[j]]):
#> implicit list embedding of S4 objects is deprecated

#> Warning in `[<-`(`*tmp*`, cnt, value = p@polygons[[i]]@Polygons[[j]]):
#> implicit list embedding of S4 objects is deprecated

#> Warning in `[<-`(`*tmp*`, cnt, value = p@polygons[[i]]@Polygons[[j]]):
#> implicit list embedding of S4 objects is deprecated

#> Warning in `[<-`(`*tmp*`, cnt, value = p@polygons[[i]]@Polygons[[j]]):
#> implicit list embedding of S4 objects is deprecated

#> Warning in `[<-`(`*tmp*`, cnt, value = p@polygons[[i]]@Polygons[[j]]):
#> implicit list embedding of S4 objects is deprecated

#> Warning in `[<-`(`*tmp*`, cnt, value = p@polygons[[i]]@Polygons[[j]]):
#> implicit list embedding of S4 objects is deprecated

#> Warning in `[<-`(`*tmp*`, cnt, value = p@polygons[[i]]@Polygons[[j]]):
#> implicit list embedding of S4 objects is deprecated

#> Warning in `[<-`(`*tmp*`, cnt, value = p@polygons[[i]]@Polygons[[j]]):
#> implicit list embedding of S4 objects is deprecated

x
#> Source: local data frame [5,307 x 3]
#> 
#>       i_  cell layer
#>    (chr) (dbl) (dbl)
#> 1      1   519   152
#> 2      1   520   152
#> 3      1   521   151
#> 4      1   522   151
#> 5      1   523   150
#> 6      1   577   150
#> 7      1   578   151
#> 8      1   579   156
#> 9      1   580   158
#> 10     1   581   159
#> ..   ...   ...   ...

xweight <- cellnumbers(r, p, weights = TRUE)
#> Warning in `[<-`(`*tmp*`, cnt, value = p@polygons[[i]]@Polygons[[j]]):
#> implicit list embedding of S4 objects is deprecated

#> Warning in `[<-`(`*tmp*`, cnt, value = p@polygons[[i]]@Polygons[[j]]):
#> implicit list embedding of S4 objects is deprecated

#> Warning in `[<-`(`*tmp*`, cnt, value = p@polygons[[i]]@Polygons[[j]]):
#> implicit list embedding of S4 objects is deprecated

#> Warning in `[<-`(`*tmp*`, cnt, value = p@polygons[[i]]@Polygons[[j]]):
#> implicit list embedding of S4 objects is deprecated

#> Warning in `[<-`(`*tmp*`, cnt, value = p@polygons[[i]]@Polygons[[j]]):
#> implicit list embedding of S4 objects is deprecated

#> Warning in `[<-`(`*tmp*`, cnt, value = p@polygons[[i]]@Polygons[[j]]):
#> implicit list embedding of S4 objects is deprecated

#> Warning in `[<-`(`*tmp*`, cnt, value = p@polygons[[i]]@Polygons[[j]]):
#> implicit list embedding of S4 objects is deprecated

#> Warning in `[<-`(`*tmp*`, cnt, value = p@polygons[[i]]@Polygons[[j]]):
#> implicit list embedding of S4 objects is deprecated

#> Warning in `[<-`(`*tmp*`, cnt, value = p@polygons[[i]]@Polygons[[j]]):
#> implicit list embedding of S4 objects is deprecated

#> Warning in `[<-`(`*tmp*`, cnt, value = p@polygons[[i]]@Polygons[[j]]):
#> implicit list embedding of S4 objects is deprecated

#> Warning in `[<-`(`*tmp*`, cnt, value = p@polygons[[i]]@Polygons[[j]]):
#> implicit list embedding of S4 objects is deprecated

#> Warning in `[<-`(`*tmp*`, cnt, value = p@polygons[[i]]@Polygons[[j]]):
#> implicit list embedding of S4 objects is deprecated

#> Warning in `[<-`(`*tmp*`, cnt, value = p@polygons[[i]]@Polygons[[j]]):
#> implicit list embedding of S4 objects is deprecated

#> Warning in `[<-`(`*tmp*`, cnt, value = p@polygons[[i]]@Polygons[[j]]):
#> implicit list embedding of S4 objects is deprecated

#> Warning in `[<-`(`*tmp*`, cnt, value = p@polygons[[i]]@Polygons[[j]]):
#> implicit list embedding of S4 objects is deprecated

#> Warning in `[<-`(`*tmp*`, cnt, value = p@polygons[[i]]@Polygons[[j]]):
#> implicit list embedding of S4 objects is deprecated

#> Warning in `[<-`(`*tmp*`, cnt, value = p@polygons[[i]]@Polygons[[j]]):
#> implicit list embedding of S4 objects is deprecated

#> Warning in `[<-`(`*tmp*`, cnt, value = p@polygons[[i]]@Polygons[[j]]):
#> implicit list embedding of S4 objects is deprecated

#> Warning in `[<-`(`*tmp*`, cnt, value = p@polygons[[i]]@Polygons[[j]]):
#> implicit list embedding of S4 objects is deprecated

#> Warning in `[<-`(`*tmp*`, cnt, value = p@polygons[[i]]@Polygons[[j]]):
#> implicit list embedding of S4 objects is deprecated

#> Warning in `[<-`(`*tmp*`, cnt, value = p@polygons[[i]]@Polygons[[j]]):
#> implicit list embedding of S4 objects is deprecated

#> Warning in `[<-`(`*tmp*`, cnt, value = p@polygons[[i]]@Polygons[[j]]):
#> implicit list embedding of S4 objects is deprecated
xweight  %>% group_by(i_)  %>% summarize(sum(weight))
#> Source: local data frame [8 x 2]
#> 
#>      i_ sum(weight)
#>   (chr)       (dbl)
#> 1     1           1
#> 2     2           1
#> 3     3           1
#> 4     4           1
#> 5     5           1
#> 6     6           1
#> 7     7           1
#> 8     8           1


b <- brick(raster(volcano), raster(volcano * 2))
```
