## may well be that this is already in the other functions of tabularaster


# ## example data
# r <- raster(volcano)
# ## intervals (with +/- to ensure closed interval contains all raster values)
# ints <- c(93, 110, 140, 160, 196)
# rc <- cut(r, ints)

patches <- function(x) {
  cells <- data_frame(cell = seq(ncell(x)))
  adjv <- adjacent(x, cells$cell, directions = 4)
  adj <- data_frame(from = adjv[,1], to = adjv[,2])
  adj$from_value <- extract(brick(x), adj$from)
  adj$to_value <- extract(brick(x), adj$to)
  clas <- bind_rows(lapply(split(adj, adj$from_value), function(x) filter(x, from_value == to_value)  %>% distinct(from)  %>% transmute(cell = from)), .id = "index") 
  clas$index <- as.integer(clas$index)
  miss <- setdiff(seq(ncell(x)), clas$cell)
  df <- data_frame(cell = miss) %>% mutate(index = row_number() + nrow(clas)) %>% select(index, cell)
  clas <- bind_rows(clas, df)
  x[clas$cell] <- clas$index
  x
}

#rp <- patches(rc)
