#' @importFrom dplyr row_number n
#' @importFrom rlang .data
vertex_edge_path <- function(x) {
  ## until we have silicate
  coord0 <- spbabel::sptable(x) %>% dplyr::transmute(.data$x_, .data$y_)
  ## anything path-based has a gibble (sp, sf, trip at least)
  ## which is just a row-per path with nrow, and object, subobject, path classifiers
  gmap <- gibble::gibble(x) 
  gmap$path <- seq_len(nrow(gmap))
  coord <- coord0 %>% dplyr::mutate(path = as.integer(factor(rep(path_paste(gmap), gmap$nrow))), 
                                    vertex = row_number()) %>%  dplyr::group_by(.data$path) 
  
  segs <- coord %>% dplyr::select(.data$path, .data$vertex)  %>% 
    dplyr::mutate(.vx0 = .data$vertex,   ## specify in segment terms 
                  .vx1 = .data$vertex + 1L) 
  
  segs <- dplyr::slice(segs, -n()) ## don't know why I thought this was poly-only?
  
  segs <- segs %>% dplyr::ungroup() %>% 
    dplyr::transmute(.data$.vx0, .data$.vx1)
  
  
list(
                 geometry = gmap,
                 segment = segs,
                 coord = coord0)
}




path_paste <- function(x, paster = function(...) paste(..., sep = "-")) {
  ## we are looking for  any of these three
  do.call(paster, x[intersect(names(x), c("object", "subobject", "path"))])
}
