# context("verbs")
# library(dplyr)
# r <- raster::raster(volcano)
# tr <- rasa(r)
# test_that("verbs works", {
#   tr %>% arrange()  
#   tr %>% arrange(cell_value)
#  # tr %>% distinct()
# #  tr %>% distinct(cell_value)
#   tr %>% filter()
#   tr %>% filter(cell_value > 120)
#   tr %>% group_by()
#   tr %>% group_by(cell_value)
#   tr %>% mutate()
#   tr %>% mutate(cell_value = row_number())
#   tr %>% rename()
#   tr %>%  rename(x = cell_value, idx = cell_index)
#   tr %>% dplyr::select()
#   tr %>% dplyr::select(cell_index)
#   tr %>% dplyr::transmute()
#   tr %>% dplyr::transmute(y = cell_index)
#   
#   tr %>% rename(x = cell_value, idx = cell_index)
#   #tr %>% sample_n() %>% expect_error("missing")
#   tr %>% sample_n(10L)
#   
#   
#   
# })
