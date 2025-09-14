
test_that("LASSO path with penalized (fit.LASSO + complexity.LASSO) works", {
  skip()
  if (!requireNamespace("penalized", quietly = TRUE)) skip("penalized not installed")
  set.seed(202)
  n <- 60; p <- 8
  X <- matrix(rnorm(n * p), n, p)
  eta <- X[,1] - 0.5*X[,2] + 0.3*rnorm(n)
  y   <- rbinom(n, 1, 1/(1 + exp(-eta)))

  idx <- resample.indices(n = n, sample.n = 3, method = "cv")

  # Find complexity (lambda) via package's helper (penalized::profL1)
  lam <- complexity.LASSO(response = y, x = X, full.data = data.frame(response=y, X))
  expect_true(is.numeric(lam) && length(lam) == 1 && is.finite(lam))

  # Fit and evaluate via peperr using LASSO (penalized)
  res <- suppressWarnings(peperr(
    response = y,
    x = X,
    indices = idx,
    fit.fun = fit.LASSO,
    complexity = complexity.LASSO,
    aggregation.fun = aggregation.misclass,
  ))
  expect_true(is.list(res))
  # misclass rates in [0,1]
  fa <- as.numeric(res$full.apparent)
  ni <- as.numeric(res$noinf.error)
  expect_true(all(fa >= 0 & fa <= 1, na.rm = TRUE))
  expect_true(all(ni >= 0 & ni <= 1, na.rm = TRUE))
})
