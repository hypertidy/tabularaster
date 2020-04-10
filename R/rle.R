# # pack rows into rle form (only suitable for big seas of constants, e.g. rasterized polygons)
# pack_raster <- function(grid) {
#   l <- vector("list", nrow(grid))
#   for (.x in seq_along(l)) {
#       rl <- rle(raster::extract(grid, raster::cellFromRow(grid, .x)))
#       l[[.x]] <- tibble::tibble(row = .x, 
#                          value = rl$values,
#                          length = rl$lengths,
#                          start = cumsum(length) - length + 1L) %>% 
#       dplyr::filter(!is.na(value))
#   }
#   dplyr::bind_rows(l) 
# }
# 
# unpack_raster <- function(template, idx) {
#   idx <- idx %>% 
#     dplyr::transmute(value, length, cell = raster::cellFromRowCol(template, idx$row, idx$start))
#   idx <- purrr::transpose(idx)
#   cells <- tibble::tibble(cell = 
#                             unlist(furrr::future_map(idx, 
#                                                      ~seq(.x$cell, length.out = .x$length))), 
#                           value = 
#                             unlist(furrr::future_map(idx, 
#                                                      ~rep_len(.x$value, length.out = .x$length))))
#   if (raster::hasValues(template)) template <- setValues(template, NA_real_)
#   template[cells$cell] <- cells$value
#   template
# }
