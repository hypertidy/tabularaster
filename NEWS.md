# tabularaster dev

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



