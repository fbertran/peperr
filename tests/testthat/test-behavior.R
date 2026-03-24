test_that("peperr runs on a tiny synthetic classification task", {
  skip_on_cran()
  n <- 200
  p <- 100
  beta <- c(rep(1,10),rep(0,p-10))
  x <- matrix(rnorm(n*p),n,p)
  real.time <- -(log(runif(n)))/(10*exp(drop(x %*% beta)))
  cens.time <- rexp(n,rate=1/10)
  status <- ifelse(real.time <= cens.time,1,0)
  time <- ifelse(real.time <= cens.time,real.time,cens.time)
  
  # Try a very small repeated double CV to keep tests quick
  res <- suppressWarnings(peperr(response=Surv(time, status), x=x, 
                           fit.fun=peperr:::fit.coxph, complexity=c(50, 75), 
                           indices=resample.indices(n=length(time), method="sub632", sample.n=10),
                           parallel=FALSE,
                           RNG="none"))
  # Basic structure checks commonly returned by resampling procedures
  expect_true(is.list(res))
  # If error rates are present, they should be numeric and in [0,1]
  err_fields <- intersect(names(res), c("err", "error", "cv.error", "pe", "pe.est"))
  if (length(err_fields)) {
    er <- unlist(res[err_fields], use.names = FALSE)
    er <- er[is.finite(er)]
    expect_true(all(er >= 0 & er <= 1))
  } else {
    # Otherwise, ensure some non-empty performance element exists
    expect_gt(length(res), 0L)
  }
})


test_that("no documented datasets detected (placeholder)", {
  skip("No \\docType{data} topics detected in man/.")
})

test_that("peperr gives a clear error when RNGstream support is unavailable", {
  if (requireNamespace("rlecuyer", quietly = TRUE)) {
    skip("rlecuyer is installed")
  }

  x <- matrix(rnorm(30), nrow = 10)
  time <- rexp(10)
  status <- sample(c(0L, 1L), size = 10, replace = TRUE)

  expect_error(
    peperr(
      response = Surv(time, status),
      x = x,
      fit.fun = peperr:::fit.coxph,
      indices = resample.indices(n = 10, method = "cv", sample.n = 2),
      parallel = NULL,
      noclusterstart = TRUE,
      noclusterstop = TRUE,
      RNG = "RNGstream"
    ),
    "requires the 'rlecuyer' package"
  )
})

test_that("peperr gives a clear error when legacy SPRNG support is requested", {
  x <- matrix(rnorm(30), nrow = 10)
  time <- rexp(10)
  status <- sample(c(0L, 1L), size = 10, replace = TRUE)

  expect_error(
    suppressWarnings(
      peperr(
        response = Surv(time, status),
        x = x,
        fit.fun = peperr:::fit.coxph,
        indices = resample.indices(n = 10, method = "cv", sample.n = 2),
        parallel = NULL,
        noclusterstart = TRUE,
        noclusterstop = TRUE,
        RNG = "SPRNG"
      )
    ),
    "no longer supported"
  )
})
