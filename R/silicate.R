vertex_edge_path <- function(x) {
  ## until we have silicate
  coord0 <- spbabel::sptable(x) %>% dplyr::transmute(x_, y_)
  ## anything path-based has a gibble (sp, sf, trip at least)
  ## which is just a row-per path with nrow, and object, subobject, path classifiers
  gmap <- gibble::gibble(x) %>% dplyr::mutate(path = row_number())
  coord <- coord0 %>% dplyr::mutate(path = as.integer(factor(rep(path_paste(gmap), gmap$nrow))), 
                                    vertex = row_number()) %>%  dplyr::group_by(path) 
  
  segs <- coord %>% select(path, vertex)  %>% 
    dplyr::mutate(.vx0 = vertex,   ## specify in segment terms 
                  .vx1 = vertex + 1L) %>% 
    dplyr::group_by(path)
  
  #if (all(grepl("poly", gmap$type, ignore.case = TRUE))) {
  segs <- dplyr::slice(segs, -n()) ## don't know why I thought this was poly-only?
  ## but TODO is check we aren't getting a degenerate final segment in closing
  ## polygon rings?
  #}
  segs <- segs %>% dplyr::ungroup() %>% 
    dplyr::transmute(.vx0, .vx1)
  
  
list(
                 geometry = gmap,
                 segment = segs,
                 coord = coord0)
}




path_paste <- function(x, paster = function(...) paste(..., sep = "-")) {
  ## we are looking for  any of these three
  do.call(paster, x[intersect(names(x), c("object", "subobject", "path"))])
}
