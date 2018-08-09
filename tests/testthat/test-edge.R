context("test-edge.R")

test_that("edge cases", {
  expect_error(cellnumbers(ghrsst, matrix(1)))
  expect_error(cellnumbers(ghrsst, 1), "no method for 'query' of type numeric")
})
