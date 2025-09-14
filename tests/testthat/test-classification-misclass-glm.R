
test_that("classification with aggregation.misclass + glm works", {
  skip_on_cran()
  set.seed(101)
  n <- 80; p <- 6
  X <- matrix(rnorm(n * p), n, p)
  eta <- X[,1] - 0.8*X[,2] + 0.5*rnorm(n)
  pr  <- 1/(1 + exp(-eta))
  y   <- rbinom(n, 1, pr)

  # indices: 4-fold CV
  idx <- resample.indices(n = n, sample.n = 4, method = "cv")

  # Fit via base glm inside peperr, evaluate misclassification
  res <- suppressWarnings(peperr(
    response = y,
    x = X,
    indices = idx,
    fit.fun = function(response, x, cplx, ...) glm(response ~ ., data = data.frame(response, x), family = binomial()),
    aggregation.fun = aggregation.misclass,
    parallel = NULL,
    noclusterstart = TRUE,
    noclusterstop = TRUE,
    RNG = "none"
  ))

  expect_true(is.list(res))
  expect_true(all(c("full.apparent","noinf.error") %in% names(res)))
  fa <- as.numeric(res$full.apparent)
  ni <- as.numeric(res$noinf.error)
  expect_true(all(fa >= 0 & fa <= 1, na.rm = TRUE))
  expect_true(all(ni >= 0 & ni <= 1, na.rm = TRUE))
  # perr() returns a numeric vector/matrix
  pe <- perr(res, type = "632")
  expect_true(all(is.finite(as.numeric(pe))))
})
