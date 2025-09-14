if (requireNamespace("testthat", quietly = TRUE)) {
  library(testthat)
  library(peperr)
  test_check("peperr")
} else {
  message("Package 'testthat' not available; skipping tests.")
}
