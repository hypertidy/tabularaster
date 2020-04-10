#' @importFrom tibble as_tibble
mat2d_f <- function(x) {
  
  if (is.null(x)) {
    return(NULL)
  }
  if (is.null(dim(x))) {
    x <- matrix(x)
  }
  colnames(x) <- letters[1:ncol(x)]
  tibble::as_tibble(x)
}
