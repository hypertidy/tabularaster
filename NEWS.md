# tabularaster 0.6.0

* Un-deprecate and re-export `decimate()`. 

* Function `cellnumbers` now provides only basic cell lookup, the weights and other
 options available in raster functions are ignored. 
 
* Function `extentFromCells` is now imported from raster and re-exported. 

* Now applying `fasterize` for sf polygon objects, and `spatstat` for sf line objects for 
 very significant speed ups. 

* Now import `spatstat` for faster line rasterization. 

# tabularaster 0.4.0

* add `xy` argument to `as_tibble`

* fix missing vignette knitr reference

* new oisst data set

# tabularaster 0.3.0

* bufext made defunct

* added index extent functions `index_extent` and `cellsFromExtent`

* removed decimate function

* fixed unnecessary lapply call for the points case, so that is now not slow

* extra handling for as_tibble, value is now optional so that data-less rasters can be used to 
 build cell and dimension indices
 
* new vignette stub to list all relevant raster functions

* object_ is now integer, 1-based to match the rows in query

* removed `boundary` (see `romsboundary` in `angstroms`)

* consolidated on the central tools, removed experiments

* migrated the buffer extent logic to `spex`, deprecated `bufext`

* added `as_tibble` for rasters

* added boundary function

# tidyraster 0.2.0

* new data sets rastercano and polycano

* new functions decimate, cellnumbers and bufext

* Added a `NEWS.md` file to track changes to the package.



