context("test-edge.R")

test_that("edge cases", {
  expect_error(expect_message(cellnumbers(ghrsst, matrix(1))))
  expect_error(expect_warning(cellnumbers(ghrsst, 1)), "no method for 'query' of type numeric")
})
