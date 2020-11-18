
<!-- README.md is generated from README.Rmd. Please edit that file -->

<!-- badges: start -->

[![Lifecycle\_stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://www.tidyverse.org/lifecycle/#stable)
[![R\_build\_status](https://github.com/hypertidy/tabularaster/workflows/R-CMD-check/badge.svg)](https://github.com/hypertidy/tabularaster/actions?query=workflow%3AR-CMD-check)
[![R\_build\_status](https://github.com/hypertidy/tabularaster/workflows/test-coverage/badge.svg)](https://github.com/hypertidy/tabularaster/actions)
[![CRAN
status](https://www.r-pkg.org/badges/version/tabularaster)](https://CRAN.R-project.org/package=tabularaster)
<!-- badges: end -->

# tabularaster

The `raster` package is extremely powerful for spatial data. It provides
very efficient data extraction and summary tools via consistent
cell-index and comprehensive set of functions for working with grids,
cells and their values.

Tabularaster provides some more helpers for working with cells and tries
to fill some of the (very few\!) gaps in raster functionality. When
raster returns cell values of hierarchical objects it returns a
hierarchical (list) of cells to match the input query, while
`tabularaster::cellnumbers` instead returns a data frame of identifiers
and cell numbers.

Tabularaster provides these functions.

  - `as_tibble` - convert to data frame with options for value column
    and cell, dimension and date indexing
  - `cellnumbers` - extract of cell index numbers as a simple data frame
    with “object ID” and “cell index”
  - `index_extent` - create an index extent, essentially `extent(0,
    ncol(raster), 0, nrow(raster))`

All functions that work with `sp Spatial` also work with `sf simple
features`.

There is some overlap with `quadmesh` and `spex` while I figure out
where things belong.

# Installation

Install from CRAN,

``` r
install.packages("tabularaster")
```

or get the development version from Github.

``` r
devtools::install_github("hypertidy/tabularaster")
```

# Usage

Basic usage is to extract the cell numbers from an object, where object
is a a matrix of points, a `Spatial` object or a `simple features sf`
object.

``` r
cells <- cellnumbers(raster, object)
```

The value in this approach is not for getting cell numbers per se, but
for using those downstream. The cell number is an index into the raster
that means the geometric hard work is done, so we can apply the index
for subsequent extractions, grouping aggregations, or for determining
the coordinates or other structure summaries of where the cell belongs.

E.g.

``` r

## summarize by object grouping
cells %>% mutate(value= extract(raster, cell_)) %>% group_by(object_) %>% summarize(mean(value))

## summarize by cell grouping
cells %>% mutate(value= extract(raster, cell_)) %>% group_by(cell_) %>% summarize(mean(value))
```

The utility of this is very much dependent on individual workflow, so
this in its own right is not very exciting: Tabularaster simply provides
an easier way to create news tools when format vagaries aren’t your day
job.

See the vignettes for more.

-----

Please note that the ‘silicate’ project is released with a [Contributor
Code of
Conduct](https://github.com/hypertidy/tabularaster/blob/master/CODE_OF_CONDUCT.md).
By contributing to this project, you agree to abide by its terms.
