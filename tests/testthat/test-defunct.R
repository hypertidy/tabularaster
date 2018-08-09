context("test-defunct.R")

test_that("defunction is defunct", {
  expect_error(bufext(ghrsst), "'bufext' is defunct.")
  expect_warning(decimate(ghrsst), "'decimate' is deprecated.")
})
