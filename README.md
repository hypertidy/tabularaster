
[![Travis-CI Build Status](https://travis-ci.org/r-gris/tabularaster.svg?branch=master)](https://travis-ci.org/r-gris/tabularaster) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/r-gris/tabularaster?branch=master&svg=true)](https://ci.appveyor.com/project/r-gris/tabularaster) [![Coverage Status](https://img.shields.io/codecov/c/github/r-gris/tabularaster/master.svg)](https://codecov.io/github/r-gris/tabularaster?branch=master)

<!-- README.md is generated from README.Rmd. Please edit that file -->
tabularaster
============

The `raster` package is extremely powerful in the R ecosystem for spatial data. It can be used very efficiently to drive data extraction and summary tools using its consistent cell-index and comprehensive helper functions for converting between cell values and less abstract raster grid properties.

Tabularaster provides some more helpers for working with cells and tries to fill some of the (very few!) gaps in raster functionality. When raster returns cell values of hierarchical objects it returns a hierarchical (list) of cells to match the input query.

Tabularaster provides:

-   extraction of cells as a simple data frame with "object ID" and "cell index"
-   a "decimate" function for fast as possible resolution reduction
-   workers to bring sf into the raster fold, WIP

there is some overlap with `quadmesh` and `spex` while I figure out where things belong

Extract cells from rasters
==========================

``` r
library(tabularaster)
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
data("rastercano")
data("polycano")
cells <- cellnumbers(rastercano, polycano[4:5, ])
#> Warning in cellnumbers(rastercano, polycano[4:5, ]): projections not the same 
#>     x: NA
#> query: NA


cellnumbers(rastercano, as(polycano[4:5, ], "SpatialLinesDataFrame"))
#> Warning in cellnumbers(rastercano, as(polycano[4:5, ], "SpatialLinesDataFrame")): projections not the same 
#>     x: NA
#> query: NA
#> # A tibble: 235 x 2
#>    object_ cell_
#>      <chr> <dbl>
#>  1       1  1129
#>  2       1  1190
#>  3       1  1251
#>  4       2     1
#>  5       2     2
#>  6       2     3
#>  7       2     4
#>  8       2     5
#>  9       2     6
#> 10       2     7
#> # ... with 225 more rows
cellnumbers(rastercano, as(as(polycano[4:5, ], "SpatialLinesDataFrame"), "SpatialPointsDataFrame"))
#> Warning in cellnumbers(rastercano, as(as(polycano[4:5, ], "SpatialLinesDataFrame"), : projections not the same 
#>     x: NA
#> query: NA
#> # A tibble: 331 x 2
#>    object_ cell_
#>      <chr> <dbl>
#>  1       1  1129
#>  2       2  1129
#>  3       3  1251
#>  4       4  1251
#>  5       5  1129
#>  6       6  1098
#>  7       7  1098
#>  8       8  1098
#>  9       9  1098
#> 10      10  1037
#> # ... with 321 more rows

## weights not workin
#xweight <- cellnumbers(rastercano, polycano[4:5, ], weights = TRUE)
#xweight  %>% group_by(object_)  %>% summarize(sum(weight_))
```

Extract values or cell numbers with sf object
=============================================

...

Decimate
========

It may be that `raster::aggregate` is better than `decimate`.

``` r
(r <- raster(volcano))
#> class       : RasterLayer 
#> dimensions  : 87, 61, 5307  (nrow, ncol, ncell)
#> resolution  : 0.01639344, 0.01149425  (x, y)
#> extent      : 0, 1, 0, 1  (xmin, xmax, ymin, ymax)
#> coord. ref. : NA 
#> data source : in memory
#> names       : layer 
#> values      : 94, 195  (min, max)
decimate(r, dec = 6)
#> class       : RasterLayer 
#> dimensions  : 14, 10, 140  (nrow, ncol, ncell)
#> resolution  : 0.09836066, 0.06896552  (x, y)
#> extent      : 0, 0.9836066, 0.03448276, 1  (xmin, xmax, ymin, ymax)
#> coord. ref. : NA 
#> data source : in memory
#> names       : layer 
#> values      : 95, 189  (min, max)

(r2 <- disaggregate(r, fact = 25))
#> class       : RasterLayer 
#> dimensions  : 2175, 1525, 3316875  (nrow, ncol, ncell)
#> resolution  : 0.0006557377, 0.0004597701  (x, y)
#> extent      : 0, 1, 0, 1  (xmin, xmax, ymin, ymax)
#> coord. ref. : NA 
#> data source : in memory
#> names       : layer 
#> values      : 94, 195  (min, max)
system.time(decimate(r2, 25))
#>    user  system elapsed 
#>   1.360   0.368   1.729
```
