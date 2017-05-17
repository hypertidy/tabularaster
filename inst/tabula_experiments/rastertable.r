
#' Volcano raster map in rastertable form.
#'
#' This table is a raster with 61 columns and 87 rows, see \code{\link{volcano}}.
#' The values are stored in columns `cell_` and `value_` using the left-right top-bottom convention used by the raster package.
#' The raster skeleton of this is stored as an attribute `rtemplate`.
#'
#' Created in /data-raw/.
#' @name voltab
#' @docType data
#' @rdname voltab
#' @examples
#' data(voltab)
#' plot(voltab, pch = 19, col = "#66666611")
NULL


# #writeLines(grep("S3method.+tbl_df", readLines("https://raw.githubusercontent.com/hadley/tibble/master/NAMESPACE"), value = TRUE))
# S3method("$",tbl_df)
# S3method("[",tbl_df)
# S3method("[[",tbl_df)
# S3method(all.equal,tbl_df)
# S3method(as.data.frame,tbl_df)
# S3method(as_data_frame,tbl_df)
# S3method(print,tbl_df)
# #writeLines(grep("S3method.+tbl_df", readLines("https://raw.githubusercontent.com/hadley/dplyr/master/NAMESPACE"), value = TRUE))
# S3method(all.equal,tbl_df)
# S3method(anti_join,tbl_df)
# S3method(arrange_,tbl_df)
# S3method(as.data.frame,tbl_df)
# S3method(auto_copy,tbl_df)
# S3method(distinct_,tbl_df)
# S3method(filter_,tbl_df)
# S3method(full_join,tbl_df)
# S3method(inner_join,tbl_df)
# S3method(left_join,tbl_df)
# S3method(mutate_,tbl_df)
# S3method(right_join,tbl_df)
# S3method(semi_join,tbl_df)
# S3method(slice_,tbl_df)
# S3method(summarise_,tbl_df)

setOldClass("rastertable")
#' Create a rastertable.
#'
#' A raster table is a long-form of data in the `raster` package.
#'
#'
#' @param x object as defined in `raster` package
#' @param ... unused
#'
#' @return rastertable
#' @export
#'
#' @examples
#' library(rastertable)
#' r <- raster(volcano)
#' rt <- rastertable(r)
#' @importFrom dplyr data_frame dim_desc
#' @importFrom raster ncell nlayers raster values
rastertable <- function(x, ...) UseMethod("rastertable")

rastertabletemplate <- function(x) {
  data_frame(cell_ = seq(raster::ncell(x)))
}

#' @rdname rastertable
#' @export
rastertable.Raster <- function(x, ...) {
  r0 <- raster(x)  ## drop to single-layer template
  d <- rastertabletemplate(r0) ## expand to multilayer if needed
  if (nlayers(x) > 1) {
    d <- d[rep(seq(nrow(d)), raster::nlayers(x)), ]
    d[["index_"]] <- rep(seq(raster::nlayers(x)), each = raster::ncell(x))
  }
 
  d[["value_"]] <-  as.vector(values(x))
 
  class(d) <- c("rastertable", class(d))
  attr(d, "rtemplate") <- raster::raster(x)
  d
}

## not implemented, these operations break the model
## or work fine with tbl default
##--# S3method("$",tbl_df)
##--# S3method("[",tbl_df)
##--# S3method("[[",tbl_df)
##--# S3method(all.equal,tbl_df)
##--# S3method(as.data.frame,tbl_df)
##- # S3method(as_data_frame,tbl_df)
# S3method(print,tbl_df)

#' @importFrom dplyr trunc_mat
#' @importFrom raster print
#' @inheritParams tibble::print.tbl_df
#' @export
print.rastertable <- function (x, ..., n = NULL, width = NULL)  {
  cat("Source: local rastertable ", dplyr::dim_desc(x), "\n", sep = "")
  print(attr(x, "rtemplate"))
  cat("\n")
  print(dplyr::trunc_mat(x, n = n, width = width))
  invisible(x)
}

# S3method(anti_join,tbl_df)
# S3method(arrange_,tbl_df)
# S3method(as.data.frame,tbl_df)
# S3method(auto_copy,tbl_df)
# S3method(distinct_,tbl_df)
# S3method(filter_,tbl_df)
# S3method(full_join,tbl_df)
# S3method(inner_join,tbl_df)
# S3method(left_join,tbl_df)
# S3method(mutate_,tbl_df)
# S3method(right_join,tbl_df)
# S3method(semi_join,tbl_df)
# S3method(slice_,tbl_df)
# S3method(summarise_,tbl_df)



rtemplate <- function(x, ...) {
  attr(x, "rtemplate")
}


inner_join.rastertable <- function(x, y, by = NULL, copy = FALSE, ...) {
  rx <- rtemplate(x)
  out <- NextMethod("inner_join", x = x, y = y, by = by, copy = copy, ...)
  out
}

#' Crop a rastertable with a 2D extent.
#'
#' The cells that fall within `y` are determined and the table is filtered to these.
#' If no rows are left . . . something something.
#' @param x rastertable
#' @inheritParams raster::crop
#' @seealso \code{\link[raster]{crop}}
#' @return rastertable
#' @export
#'
#' @examples
#' x <- voltab %>% crop_(c(0.5, 0.6, 0.1, 0.2))
#' @importFrom raster cellsFromExtent extent
crop_ <- function(x, ...) UseMethod("crop_")

#' @rdname crop_
#' @export
crop_.rastertable <- function(x, y, snap = 'near', ...) {
  #cropped <- crop(attr(x, "rtemplate", y, ...))
  cropcell <- data_frame(cell = raster::cellsFromExtent(attr(x, "rtemplate"),  raster::extent(y)))
  inner_join(x, cropcell, c("cell_" = "cell"))
}



#' Title
#'
#' Return the extents of data values stored, as opposed to the full domain.
#' @param x rastertable
#' @param ... ignored
#'
#' @return ??
#' @export
#'
#' @examples
#' extent_(voltab)
extent_ <- function(x, ...) {
  UseMethod("extent_")
}


#' @rdname extent_
#' @export
#' @importFrom raster extent res xyFromCell
#' @importFrom dplyr distinct_
extent_.rastertable <- function(x, ...) {
  resx <- raster::res(rtemplate(x))
  raster::extent(raster::xyFromCell(rtemplate(x), (dplyr::distinct_(x, "cell_"))$cell))
}
