rasa <- function(x, ...) {
  UseMethod("rasa")
}

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
  as_rasa_tibble(out, tabula_transform(x))
}
as_rasa_tibble <- function(x, tt, ...) {
  class(x) <- c("rasa", class(x))
  attr(x, "tabula_transform") <- tabula_transform(tt)
  x
}
add_cell_index <- function(x, ...) {
  if (!"cell_index" %in% names(x)) {
    x[["cell_index"]] <- seq_len(nrow(x))
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
arrange_.rasa <- function(x, ...) {
  x <- add_cell_index(x)
  as_rasa_tibble(NextMethod(), tabula_transform(x))
}
count_.rasa <- function(x, ...) {
  NextMethod()  ## what can count do?
  #x <- add_cell_index(x)
  #as_rasa_tibble(NextMethod(), tabula_transform(x))
}
#data_frame_
distinct_.rasa <- function(x, ...) {
  x <- add_cell_index(x)
  as_rasa_tibble(NextMethod(), tabula_transform(x))
}
sample_n.rasa <- function(x, ...) {
  x <- add_cell_index(x)
  as_rasa_tibble(NextMethod(), tabula_transform(x))
}
slice_.rasa <- function(x, ...) {
  x <- add_cell_index(x)
  as_rasa_tibble(NextMethod(), tabula_transform(x))
}
mutate_.rasa <- function(x, ...) {
  as_rasa_tibble(NextMethod(), tabula_transform(x))
}
filter_.rasa <- function(x, ...) {
  x <- add_cell_index(x)
  x <- as_tibble(x)
  as_rasa_tibble(filter_(x, ...), tabula_transform(x))
}