tiny_survival_fixture <- function(seed = 1, n = 36, p = 6) {
  set.seed(seed)

  x <- matrix(rnorm(n * p), n, p)
  beta <- c(0.9, -0.6, 0.4, rep(0, p - 3))
  linpred <- drop(x %*% beta)
  true_time <- rexp(n, rate = exp(scale(linpred)))
  cens_time <- rexp(n, rate = 0.6)
  time <- pmin(true_time, cens_time)
  status <- as.integer(true_time <= cens_time)
  response <- cbind(time = time, status = status)

  list(
    x = x,
    response = response,
    times = as.numeric(stats::quantile(time, probs = c(0.25, 0.5, 0.75))),
    full.data = data.frame(x, time = time, status = status),
    indices = resample.indices(n = n, sample.n = 2, method = "cv")
  )
}

has_exported_pll_method <- function(object) {
  ns <- asNamespace("peperr")
  any(vapply(
    class(object),
    function(class_name) exists(paste0("PLL.", class_name), envir = ns, inherits = FALSE),
    logical(1)
  ))
}

expect_survival_backend_flow <- function(fit.fun, complexity = NULL, args.fit = NULL, args.complexity = NULL, seed = 1) {
  dat <- tiny_survival_fixture(seed = seed)
  selected <- if (is.function(complexity)) {
    do.call(
      complexity,
      c(
        list(response = dat$response, x = dat$x, full.data = dat$full.data),
        args.complexity
      )
    )
  } else {
    complexity
  }

  fit <- do.call(
    fit.fun,
    c(
      list(
        response = dat$response,
        x = dat$x,
        cplx = if (is.null(selected)) 0 else selected
      ),
      args.fit
    )
  )

  prob <- do.call(
    predictProb,
    list(
      object = fit,
      response = dat$response,
      x = dat$x,
      times = dat$times,
      complexity = selected
    )
  )

  expect_true(is.matrix(prob))
  expect_equal(dim(prob), c(nrow(dat$x), length(dat$times)))
  expect_true(all(prob[is.finite(prob)] >= 0 & prob[is.finite(prob)] <= 1))

  pe_curve <- pmpec(
    object = fit,
    response = dat$response,
    x = dat$x,
    times = dat$times,
    model.args = list(complexity = selected),
    type = "PErr"
  )

  expect_type(pe_curve, "double")
  expect_length(pe_curve, length(dat$times))
  expect_true(all(pe_curve[is.finite(pe_curve)] >= 0 & pe_curve[is.finite(pe_curve)] <= 1))

  if (has_exported_pll_method(fit)) {
    pll <- do.call(
      PLL,
      list(
        object = fit,
        newdata = dat$x,
        newtime = dat$response[, "time"],
        newstatus = dat$response[, "status"],
        complexity = selected
      )
    )

    expect_true(is.numeric(pll))
    expect_true(all(is.finite(as.numeric(pll))))
  }

  res <- suppressWarnings(peperr(
    response = dat$response,
    x = dat$x,
    indices = dat$indices,
    fit.fun = fit.fun,
    complexity = if (is.function(complexity)) complexity else if (is.null(complexity)) 0 else complexity,
    args.fit = args.fit,
    args.complexity = args.complexity,
    parallel = FALSE,
    RNG = "none"
  ))

  expect_true(is.list(res))
  expect_true(all(c("full.apparent", "noinf.error") %in% names(res)))
}
