test_that("CoxBoost helpers fail clearly when CoxBoost is unavailable", {
  if (requireNamespace("CoxBoost", quietly = TRUE)) {
    skip("CoxBoost is installed; guarded-unavailable path is not applicable.")
  }

  X <- matrix(rnorm(12), nrow = 6)
  y <- cbind(time = seq_len(6), status = rep(c(1L, 0L), length.out = 6))

  expect_error(
    fit.CoxBoost(response = y, x = X, cplx = 3),
    "Install it with install\\.packages\\('CoxBoost'\\)"
  )
})

test_that("CoxBoost wrappers expose fit, predictProb, and PLL when installed", {
  skip_on_cran()
  if (!requireNamespace("CoxBoost", quietly = TRUE)) {
    skip("CoxBoost not installed")
  }

  set.seed(808)
  n <- 40
  p <- 5
  X <- matrix(rnorm(n * p), n, p)
  beta <- c(0.8, -0.5, rep(0, p - 2))
  T <- rexp(n, rate = exp(scale(drop(X %*% beta))))
  C <- rexp(n, rate = 0.7)
  time <- pmin(T, C)
  status <- as.integer(T <= C)
  y <- cbind(time = time, status = status)

  fit <- fit.CoxBoost(response = y, x = X, cplx = 6)
  expect_s3_class(fit, "CoxBoost")

  times <- as.numeric(stats::quantile(time, probs = c(0.3, 0.6, 0.9)))
  prob <- predictProb(object = fit, response = y, x = X, times = times, complexity = 6)
  expect_true(is.matrix(prob))
  expect_equal(dim(prob), c(n, length(times)))
  expect_true(all(prob[is.finite(prob)] >= 0 & prob[is.finite(prob)] <= 1))

  pll <- PLL(object = fit, newdata = X, newtime = time, newstatus = status, complexity = 6)
  expect_type(pll, "double")
  expect_true(length(pll) >= 1)
  expect_true(all(is.finite(pll)))

})

test_that("complexity.mincv.CoxBoost returns a valid boosting step", {
  skip_on_cran()
  if (!requireNamespace("CoxBoost", quietly = TRUE)) {
    skip("CoxBoost not installed")
  }

  set.seed(809)
  n <- 36
  p <- 4
  X <- matrix(rnorm(n * p), n, p)
  beta <- c(0.7, -0.4, rep(0, p - 2))
  T <- rexp(n, rate = exp(scale(drop(X %*% beta))))
  C <- rexp(n, rate = 0.8)
  time <- pmin(T, C)
  status <- as.integer(T <= C)
  y <- cbind(time = time, status = status)
  folds <- split(seq_len(n), rep(1:3, length.out = n))

  cplx <- complexity.mincv.CoxBoost(
    response = y,
    x = X,
    full.data = data.frame(time = time, status = status, X),
    maxstepno = 5,
    K = 3,
    folds = folds,
    penalty = 100
  )

  expect_true(is.numeric(cplx) && length(cplx) == 1)
  expect_true(cplx >= 0 && cplx <= 5)
})
