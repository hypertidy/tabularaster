#' buffer an extent e1 to whole number e2
bufext <- function(e1, e2) {
  if (e2 == 0) return(e1)
  x <- e1     ## input object that has extent()
  chunk <- e2 ## rounding chunk
  num0 <- c(xmin(x), xmax(x), ymin(x), ymax(x))
  
  extent(    c((num0[c(1L, 3L)] %/% chunk) * chunk, 
               (num0[c(2L, 4L)] %/% chunk) * chunk + chunk)[c(1, 3, 2, 4)])
  
}
