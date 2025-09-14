
test_that("classification with aggregation.brier + glm (logistic) works", {
  skip_on_cran()
  set.seed(404)
  n <- 90; p <- 7
  X <- matrix(rnorm(n * p), n, p)
  eta <- 0.9*X[,1] - 0.6*X[,2] + 0.4*rnorm(n)
  pr  <- 1/(1 + exp(-eta))
  y   <- rbinom(n, 1, pr)

  idx <- resample.indices(n = n, sample.n = 3, method = "cv")

  res <- suppressWarnings(peperr(
    response = y,
    x = X,
    indices = idx,
    fit.fun = function(response, x, cplx, ...) glm(response ~ ., data = data.frame(response, x), family = binomial()),
    aggregation.fun = aggregation.brier,
    parallel = NULL,
    noclusterstart = TRUE,
    noclusterstop = TRUE,
    RNG = "none"
  ))

  expect_true(is.list(res))
  expect_true(all(c("full.apparent","noinf.error") %in% names(res)))
  fa <- as.numeric(res$full.apparent)
  ni <- as.numeric(res$noinf.error)
  # Brier score is in [0,1] for Bernoulli outcomes
  expect_true(all(fa >= 0 & fa <= 1, na.rm = TRUE))
  expect_true(all(ni >= 0 & ni <= 1, na.rm = TRUE))
  pe <- perr(res, type = "632")
  expect_true(all(is.finite(as.numeric(pe))))
})
