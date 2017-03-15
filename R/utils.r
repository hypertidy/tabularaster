#' @importFrom tibble as_tibble
mat2d_f <- function(x) {
  
  if (is.null(x)) {
    return(NULL)
  }
  tibble::as_tibble(x)
}
