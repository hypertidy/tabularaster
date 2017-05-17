#' Create a rasa. 
#' 
#' A ... is a tibble storage mode for a "raster". This follows the model in the raster and sp packages where 
#' raster cell values are stored in long form, in image-screen left-to-right, top-to-bottom order (same as used by GDAL). 
#' 
#' We are similar to sp in that the columns are for variables, rows are for observations. In raster this is muddled, since
#' extra dimensions (e.g. time) are stored "wide" with a column for each "XY layer". Note that an RGB image is stored "wide"
#' in raster too, so ultimately it cannot have time-layer or z-layer varying RGB or other multi-column data (like U- V- velocity
#' vector components, or any multi-variable observations in higher than 2 dimensions). 
#' @param x input model
#' @para ... args for methods
#' @name rasa
#' @export
rasa <- function(x, ...) {
  UseMethod("rasa")
}

#' Create a rasa. 
#' 
#' The `rasa` method for `raster::RasterLayer`
#' @name rasa.RasterLayer
#' @export
#' @examples 
#' r <- raster::raster(volcano)
#' tr <- rasa(r)
#' ## usual verbs
#' mutate(tr, a = 2)
#' ## subsetting adds cell_index if not present
#' filter(tr, cell_value > 110)
#' slice(tr, c(1000, 1001))
#' plot(rasa(r) %>% filter(cell_value > 106) %>% slice(100:1000))
#' 
#' ## more realish
#' library(maptools)
#' data(wrld_simpl)
#' r <- rasterize(wrld_simpl, raster(wrld_simpl, nrow = 360, ncol = 180))
#' tr <- rasa(r) %>% filter(!is.na(cell_value))
#' plot(tr %>% sample_n(15000))
#' plot(tr %>% filter(cell_index > 3e4))
rasa.RasterLayer <- function(x, ...) {
  out <- tibble::tibble(cell_value = attr(attr(x, "data"), "values"))
  as_rasa(out, tabula_transform(x))
}
rasa.RasterStackBrick <- function(x, ...) {
  b <- bind_rows(lapply(seq_len(nlayers(x)), function(a) tibble::tibble(cell_value = attr(attr(x[[a]], "data"), "values"))), .id = "index")
 # b$cell_value <- b$cell_value * (as.integer(b$index) - 1)
  b$index <- NULL
  as_rasa(b, tabula_transform(x[[1L]]))
}
as_rasa <- function(x, tt, ...) {UseMethod("as_rasa")}
as_rasa.data.frame <- function(x, tt, ...) {
  class(x) <- c("rasa", class(x))
  attr(x, "tabula_transform") <- tabula_transform(tt)
  x
}
as_rasa.rasa <- function(x, tt, ...) x
add_cell_index <- function(x, ...) {
  tt <- tabula_transform(x)
  #nr <- unlist(tt[c("nrows", "ncols")])
  #print(nr)
  if (!"cell_index" %in% names(x)) {
    #x[["cell_index"]] <- seq_len(nrow(x))
    x <- mutate(x, cell_index = row_number())
  }
  x
}
plot.rasa <- function(x, ...) {
  al <- list(...)
  if (!"col" %in% names(al)) al[["col"]] <- viridis::viridis(100)
  r <- as_raster(x)
  ## very wasteful, need semantics to avoid this
  x <- add_cell_index(x)
  r[x$cell_index] <- x$cell_value
  al[["x"]] <- r
  do.call(plot, al)
}
as_raster <- function(x, ...) UseMethod("as_raster")
 as_raster.rasa <- function(x, ...) {
  raster::raster(raster::extent(unlist(as.list(tabula_transform(x))[c("xmin", "xmax", "ymin", "ymax")])), 
                 nrow = tabula_transform(x)$nrows, ncol = tabula_transform(x)$ncols)
 }
 
## convert the cell_index to xy form
## rasa(sf) %>% xy_cell_index() %>% group_by(cell_index) %>% summarize(cell_value = min(cell_value)) %>% plot()
xy_cell_index <- function(x, ...) UseMethod("xy_cell_index")
xy_cell_index.rasa <- function(x, ...) {
  x <- add_cell_index(x)
  tt <- tabula_transform(x)
  nr <- unlist(tt[c("nrows", "ncols")])
  mutate(x, cell_index = ((cell_index - 1L) %% prod(nr)) + 1)
}
print.rasa <- function(x, ...) {
  print(tabula_transform(x))
  NextMethod(x)
}
get_extent <- function(x) {
  nms <- c("xmin", "xmax", "ymin", "ymax")
  setNames(lapply(nms, function(a) attr(x@extent, a)), nms)
}

get_dim <- function(x) {
  nms <- c("nrows", "ncols")
  setNames(lapply(nms, function(a) attr(x, a)), nms)
}

tabula_transform <- function(x, ...) {
  UseMethod("tabula_transform")
}
tabula_transform.rasa <- function(x, ...) {
  attr(x, "tabula_transform")
}
tabula_transform.RasterLayer <- function(x, ...) {
  xy_min_max <- get_extent(x)
  n_row_col <- get_dim(x)
  tibble::as_tibble(c(xy_min_max, n_row_col))
}
tabula_transform.tbl_df <- function(x, ...) {
  x
}


unclass_rasa <- function(x, ...) {
  attr(x, "tabula_transform") <- NULL
  class(x) <- setdiff( class(x), "rasa")
  x
}
as_tibble.rasa <- function(x, ...) {
  as_tibble(unclass_rasa(x))
}
arrange_.rasa <- function(.data, ..., .dots) {
  tt <- tabula_transform(.data)
  .data <- add_cell_index(.data)
  as_rasa(NextMethod(), tt)
}
group_by_.rasa <- function (.data, ..., add = FALSE) {
  tt <- tabula_transform(.data)
  .data <- add_cell_index(.data)
  as_rasa(NextMethod(), tt)
}
## count_.rasa ## not a generic
#data_frame_
# distinct_.rasa <- ## cannot do since cell_index gets dropped
## function (.data, ..., .dots, .keep_all = FALSE) {
#   tt <- tabula_transform(.data)
#   .data <- add_cell_index(.data)
#   as_rasa(NextMethod(), tt)
# }
rename_.rasa <- function (.data, ...) {
  tt <- tabula_transform(.data)
  .data <- add_cell_index(.data)
  as_rasa(NextMethod(), tt)
}
select_.rasa <- function (.data, ...) {
  tt <- tabula_transform(.data)
  .data <- add_cell_index(.data)
  as_rasa(NextMethod(), tt)
}
transmute_.rasa <- function (.data, ...) {
  tt <- tabula_transform(.data)
  .data <- add_cell_index(.data)
  as_rasa(NextMethod(), tt)
}
sample_n.rasa <- function(.data, ..., .dots) {
  tt <- tabula_transform(.data)
  .data <- add_cell_index(.data)
  as_rasa(NextMethod(), tt)
}
slice_.rasa <- function(.data, ..., .dots) {
  tt <- tabula_transform(.data)
  .data <- add_cell_index(.data)
  as_rasa(NextMethod(), tt)
}
summarise_.rasa <- function(.data, ..., .dots) {
  tt <- tabula_transform(.data)
  .data <- add_cell_index(.data)
  as_rasa(NextMethod(), tt)
}
mutate_.rasa <- function(.data, ..., .dots) {
  tt <- tabula_transform(.data)
  #.data <- add_cell_index(.data)
  as_rasa(NextMethod(), tt)
} 
filter_.rasa <- function(.data, ..., .dots) {
  tt <- tabula_transform(.data)
  .data <- add_cell_index(.data)
  as_rasa(NextMethod(), tt)
}

