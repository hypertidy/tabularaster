
[![Travis-CI Build Status](https://travis-ci.org/mdsumner/tidyraster.svg?branch=master)](https://travis-ci.org/mdsumner/tidyraster) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/mdsumner/tidyraster?branch=master&svg=true)](https://ci.appveyor.com/project/mdsumner/tidyraster)

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
data("rastercano")
data("polycano")
cells <- cellnumbers(rastercano, polycano[4:5, ])


cellnumbers(rastercano, as(polycano[4:5, ], "SpatialLinesDataFrame"))
#> Source: local data frame [235 x 2]
#> 
#>    object_ cell_
#>      (chr) (dbl)
#> 1        1  1129
#> 2        1  1190
#> 3        1  1251
#> 4        2     1
#> 5        2     2
#> 6        2     3
#> 7        2     4
#> 8        2     5
#> 9        2     6
#> 10       2     7
#> ..     ...   ...
cellnumbers(rastercano, as(as(polycano[4:5, ], "SpatialLinesDataFrame"), "SpatialPointsDataFrame"))
#> Source: local data frame [331 x 2]
#> 
#>    object_ cell_
#>      (chr) (dbl)
#> 1        1  1129
#> 2        2  1129
#> 3        3  1251
#> 4        4  1251
#> 5        5  1129
#> 6        6  1098
#> 7        7  1098
#> 8        8  1098
#> 9        9  1098
#> 10      10  1037
#> ..     ...   ...

## weights not workin
#xweight <- cellnumbers(rastercano, polycano[4:5, ], weights = TRUE)
#xweight  %>% group_by(object_)  %>% summarize(sum(weight_))
```
