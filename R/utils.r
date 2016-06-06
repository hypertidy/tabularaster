#' @importFrom dplyr as_data_frame
mat2d_f <- function(x) {
  if (is.null(dim(x))) x<- matrix(x)
  dplyr::as_data_frame(as.data.frame((x)))
}
