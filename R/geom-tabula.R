#' @format NULL
#' @usage NULL
#' @export
StatTabula <- ggproto("StatTabula", ggplot2::Stat,
                      compute_group = function(data, scales, params) {
                        data$x <-data$x + 100
                        data
                      }
)

#' Leave data tabulastic!
#'
#' The tabula statistic is a kook.
#' @import ggplot2
#' @inheritParams layer
#' @inheritParams geom_point
#' @export
#' @examples
#' p <- ggplot(mtcars, aes(wt, mpg))
#' p + stat_tabula()
#' 
#' r <- raster::raster(volcano)
#' tr <- rasa(r)
#' #tr$x <- raster::xFromCell(r, seq_len(nrow(tr)))
#' #tr$y <- raster::yFromCell(r, seq_len(nrow(tr)))
#' library(ggplot2)
#' library(grid)
#' ggplot(tr, aes(x, y, fill = cell_value)) + geom_tabula()
#' library(tidyverse)
#' ggplot() +  geom_tabula(data = tr %>% filter(cell_value > 120, cell_value < 190), aes(x, y, fill = cell_value))
#' 
#' #library(elevatr)
#' #elev <- get_elev_raster(raster(extent(100, 150, -50, -20), crs = "+proj=longlat +datum=WGS84"), z = 3)
#' #saveRDS(rasa(elev), file = "rasa_data.rds", compress = "xz")
#' elev <- readRDS("rasa_data.rds")
#' ggplot() +  geom_tabula(data = elev %>% filter(cell_value < 120), aes(x, y, fill = cell_value))
stat_tabula <- function(mapping = NULL, data = NULL,
                          geom = "point", position = "identity",
                          ...,
                          show.legend = NA,
                          inherit.aes = TRUE) {
  print(mapping)
  layer(
    data = data,
    mapping = mapping,
    stat = StatTabula,
    geom = geom,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      na.rm = FALSE,
      ...
    )
  )
}





#' @export
#' @rdname geom_tile
#' @param hjust,vjust horizontal and vertical justification of the grob.  Each
#'   justification value should be a number between 0 and 1.  Defaults to 0.5
#'   for both, centering each pixel over its data location.
#' @param interpolate If \code{TRUE} interpolate linearly, if \code{FALSE}
#'   (the default) don't interpolate.
geom_tabula <- function(mapping = aes(), data = NULL,
                        stat = "tabula", position = "identity",
                        ...,
                        hjust = 0.5,
                        vjust = 0.5,
                        interpolate = FALSE,
                        na.rm = FALSE,
                        show.legend = NA,
                        inherit.aes = TRUE)
{
  stopifnot(is.numeric(hjust), length(hjust) == 1)
  stopifnot(is.numeric(vjust), length(vjust) == 1)
  # Automatically determin name of geometry column
  if (!is.null(data) && inherits(data, "rasa")) {
    #geometry_col <- attr(data, "sf_column")
    r <- as_raster(data)
    data <- tabularaster::add_cell_index(data)
    data$x <- raster::xFromCell(r, data$cell_index)
    data$y <- raster::yFromCell(r, data$cell_index)
    #'
  } 

  layer(
    data = data,
    mapping = mapping,
    stat = stat,
    geom = GeomTabula,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      hjust = hjust,
      vjust = vjust,
      interpolate = interpolate,
      na.rm = na.rm,
      ...
    )
  )
}

#' @rdname ggplot2-ggproto
#' @format NULL
#' @usage NULL
#' @export
GeomTabula <- ggproto("GeomTabula", Geom,
                      default_aes = aes(fill = "grey20", alpha = NA),
                      non_missing_aes = "fill",
                      required_aes = c("x", "y"),
                      
                      setup_data = function(data, params) {
                     
                        hjust <- params$hjust %||% 0.5
                        vjust <- params$vjust %||% 0.5
                        
                        w <- resolution(data$x, FALSE)
                        h <- resolution(data$y, FALSE)
                        
                        data$xmin <- data$x - w * (1 - hjust)
                        data$xmax <- data$x + w * hjust
                        data$ymin <- data$y - h * (1 - vjust)
                        data$ymax <- data$y + h * vjust
                        data
                      },
                      
                      draw_panel = function(data, panel_params, coord, interpolate = FALSE,
                                            hjust = 0.5, vjust = 0.5) {
                        if (!inherits(coord, "CoordCartesian")) {
                          stop("geom_tabula only works with Cartesian coordinates", call. = FALSE)
                        }
                        
                        data <- coord$transform(data, panel_params)
                        
                        # Convert vector of data to raster
                        x_pos <- as.integer((data$x - min(data$x)) / resolution(data$x, FALSE))
                        y_pos <- as.integer((data$y - min(data$y)) / resolution(data$y, FALSE))
                        
                        nrow <- max(y_pos) + 1
                        ncol <- max(x_pos) + 1
                        
                        raster <- matrix(NA_character_, nrow = nrow, ncol = ncol)
                        raster[cbind(nrow - y_pos, x_pos + 1)] <- alpha(data$fill, data$alpha)
                        
                        # Figure out dimensions of raster on plot
                        x_rng <- c(min(data$xmin, na.rm = TRUE), max(data$xmax, na.rm = TRUE))
                        y_rng <- c(min(data$ymin, na.rm = TRUE), max(data$ymax, na.rm = TRUE))
                        
                        rasterGrob(raster,
                                   x = mean(x_rng), y = mean(y_rng),
                                   width = diff(x_rng), height = diff(y_rng),
                                   default.units = "native", interpolate = interpolate
                        )
                      },
                      draw_key = draw_key_rect
)

"%||%" <- function(a, b) {
  if (!is.null(a)) a else b
}