
test_that("LASSO path using glmnet via custom wrappers integrates with peperr", {
  skip_on_cran()
  if (!requireNamespace("glmnet", quietly = TRUE)) skip("glmnet not installed")
  set.seed(303)
  n <- 70; p <- 10
  X <- matrix(rnorm(n * p), n, p)
  eta <- X[,1] - 0.7*X[,2] + 0.4*rnorm(n)
  y   <- rbinom(n, 1, 1/(1 + exp(-eta)))

  # Custom complexity function using cv.glmnet
  complexity.glmnet <- function(response, x, full.data, ...) {
    fitcv <- glmnet::cv.glmnet(x = x, y = response, family = "binomial", nfolds = 3, ...)
    # return lambda that peperr will pass to fit.fun
    as.numeric(fitcv$lambda.min)
  }

  # Custom fit function that accepts cplx = lambda
  fit.glmnet.bin <- function(response, x, cplx, ...) {
    glmnet::glmnet(x = x, y = response, family = "binomial", lambda = cplx, ...)
  }

  # Custom aggregator compatible with glmnet's predict() signature
  aggregation.glmnet.misclass <- function(full.data = NULL, response, x, model, cplx = FALSE,
                                          type = c("apparent", "noinf"), fullsample.attr = NULL, ...) {
    type <- match.arg(type)
    pr <- as.numeric(predict(model, newx = x, s = cplx, type = "response"))
    # ensure response numeric 0/1
    yy <- if (is.factor(response)) as.numeric(response) - 1 else as.numeric(response)
    if (type == "apparent") {
      return(sum(abs(round(pr) - yy)) / length(yy))
    } else {
      return(mean(abs((matrix(yy, length(yy), length(yy), byrow = TRUE) - round(pr)))))
    }
  }

  idx <- resample.indices(n = n, sample.n = 3, method = "cv")
  res <- suppressWarnings(peperr(
    response = y,
    x = X,
    indices = idx,
    fit.fun = fit.glmnet.bin,
    complexity = complexity.glmnet,
    aggregation.fun = aggregation.glmnet.misclass,
    parallel = NULL,
    noclusterstart = TRUE,
    noclusterstop = TRUE,
    RNG = "none"
  ))
  expect_true(is.list(res))
  fa <- as.numeric(res$full.apparent)
  expect_true(all(fa >= 0 & fa <= 1, na.rm = TRUE))
  # perr() should compute something finite
  pe632p <- perr(res, type = "632p")
  expect_true(all(is.finite(as.numeric(pe632p))))
})
