
<!-- README.md is generated from README.Rmd. Please edit that file -->
![Travis-CI Build Status](https://travis-ci.org/hypertidy/tabularaster.svg?branch=master)\](<https://travis-ci.org/hypertidy/tabularaster>) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/hypertidy/tabularaster?branch=master&svg=true)](https://ci.appveyor.com/project/hypertidy/tabularaster) [![Coverage Status](https://img.shields.io/codecov/c/github/hypertidy/tabularaster/master.svg)](https://codecov.io/github/hypertidy/tabularaster?branch=master)

tabularaster
============

The `raster` package is extremely powerful in the R ecosystem for spatial data. It can be used very efficiently to drive data extraction and summary tools using its consistent cell-index and comprehensive helper functions for converting between cell values and less abstract raster grid properties.

Tabularaster provides some more helpers for working with cells and tries to fill some of the (very few!) gaps in raster functionality. When raster returns cell values of hierarchical objects it returns a hierarchical (list) of cells to match the input query.

Tabularaster provides:

-   extraction of cells as a simple data frame with "object ID" and "cell index"
-   `as_tibble` for raster data, with options for value column and cell, dimension and date indexing
-   workers to bring `sf` support to `raster`

There is some overlap with `quadmesh` and `spex` while I figure out where things belong.

Installation
============

Tabularaster is currently only available from Github, and it's early days so please use with caution. There are some things that I might need to change.

``` r
devtools::install_github("hypertidy/tabularaster")
```

Usage
=====

See the vignette.
