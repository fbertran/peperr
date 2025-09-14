
test_that("peperr runs (serial) with coxph + aggregation.pmpec and returns sane errors", {
  skip_on_cran()
  set.seed(7)
  n <- 50; p <- 4
  X <- matrix(rnorm(n * p), n, p)
  beta <- c(1, -0.7, 0, 0)
  T <- rexp(n, rate = exp(scale(drop(X %*% beta))))
  C <- rexp(n, rate = 0.7)
  time <- pmin(T, C)
  status <- as.integer(T <= C)
  y <- cbind(time = time, status = status)

  # 3-fold CV indices
  idx <- resample.indices(n = n, sample.n = 3, method = "cv")

  # Keep it serial (no cluster) and explicit aggregator for survival
  times <- as.numeric(stats::quantile(time, probs = c(0.25, 0.5, 0.75)))
  res <- suppressWarnings(peperr(
    response = y,
    x = X,
    indices = idx,
    fit.fun = fit.coxph,
    aggregation.fun = aggregation.pmpec,
    args.aggregation = list(times = times),
    parallel = NULL,
    noclusterstart = TRUE,
    noclusterstop = TRUE,
    RNG = "none"   # deterministic
  ))

  expect_true(is.list(res))
  # Full-sample apparent and no-inf error should be present
  expect_true(all(c("full.apparent","noinf.error") %in% names(res)))
  # Errors are per time point (rows = 1 if no complexity)
  fa <- res$full.apparent
  ni <- res$noinf.error
  expect_true(is.matrix(fa) || is.numeric(fa))
  # Coerce to numeric vector for assertions
  fa_vec <- if (is.matrix(fa)) as.numeric(fa) else as.numeric(fa)
  ni_vec <- if (is.matrix(ni)) as.numeric(ni) else as.numeric(ni)
  expect_true(all(fa_vec >= 0 & fa_vec <= 1, na.rm = TRUE))
  expect_true(all(ni_vec >= 0 & ni_vec <= 1, na.rm = TRUE))

  # Aggregate with perr()
  pe_noinf <- perr(res, type = "NoInf")
  expect_true(all(is.finite(as.numeric(pe_noinf))))
})
