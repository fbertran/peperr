
test_that("coxph workflow: fit.coxph -> predictProb.coxph -> pmpec -> ipec", {
  skip_on_cran()
  set.seed(42)
  n <- 60; p <- 5
  X <- matrix(rnorm(n * p), n, p)
  beta <- c(0.8, -0.6, rep(0, p-2))
  linpred <- drop(X %*% beta)
  # Exponential survival with rate depending on LP
  T <- rexp(n, rate = exp(scale(linpred)))
  C <- rexp(n, rate = 0.5)
  time <- pmin(T, C)
  status <- as.integer(T <= C)  # 1=event, 0=censored
  y <- survival::Surv(time = time, event = status)

  # Fit via package's interface
  fit <- fit.coxph(response = cbind(time = time, status = status), x = X)
  expect_s3_class(fit, "coxph")

  # Predict survival probabilities at 3 time points
  times <- as.numeric(stats::quantile(time, probs = c(0.3, 0.6, 0.9)))
  prob <- predictProb.coxph(object = fit, response = cbind(time = time, status = status), x = X, times = times)
  expect_true(is.matrix(prob))
  expect_equal(dim(prob), c(n, length(times)))
  expect_true(all(is.finite(prob[is.finite(prob)])))
  expect_true(all(prob[is.finite(prob)] >= 0 & prob[is.finite(prob)] <= 1))

  # Prediction error curve and its integral
  pe_curve <- pmpec(object = fit, response = cbind(time = time, status = status), x = X, times = times, type = "PErr")
  expect_type(pe_curve, "double")
  expect_length(pe_curve, length(times))
  expect_true(all(pe_curve >= 0 & pe_curve <= 1, na.rm = TRUE))

  pe_int <- ipec(pe = pe_curve, eval.times = times, type = "Riemann")
  expect_true(is.numeric(pe_int) && length(pe_int) == 1 && is.finite(pe_int))
})
