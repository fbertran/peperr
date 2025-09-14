
test_that("regression path (Gaussian) with custom MSE aggregator works", {
  skip_on_cran()
  set.seed(505)
  n <- 80; p <- 6
  X <- matrix(rnorm(n * p), n, p)
  colnames(X) <- paste("X",1:6,sep="")
  beta <- c(1.2, -0.8, rep(0, p-2))
  y <- drop(X %*% beta) + rnorm(n, sd = 0.7)

  idx <- resample.indices(n = n, sample.n = 4, method = "cv")

  # Custom aggregator for regression: MSE for apparent; baseline MSE for noinf
  aggregation.mse <- function(full.data=NULL, response, x, model, cplx=NULL,
                              type = c("apparent","noinf"), fullsample.attr = NULL, ...) {
    type <- match.arg(type)
    data <- as.data.frame(x); data$response <- response
    if (type == "apparent") {
      pred <- as.numeric(predict(model, newdata = data))
      return(mean((response - pred)^2))
    } else { # 'no information' baseline: predict mean(response)
      mu <- mean(response)
      return(mean((response - mu)^2))
    }
  }

  res <- suppressWarnings(peperr(
    response = y,
    x = X,
    indices = idx,
    fit.fun = function(response, x, cplx, ...) {
      lm(response ~ ., data = data.frame(response, x))},
    aggregation.fun = aggregation.mse,
    parallel = NULL,
    noclusterstart = TRUE,
    noclusterstop = TRUE,
    RNG = "none"
  ))

  expect_true(is.list(res))
  expect_true(all(c("full.apparent","noinf.error") %in% names(res)))
  fa <- as.numeric(res$full.apparent)
  ni <- as.numeric(res$noinf.error)
  expect_true(all(is.finite(fa)))
  expect_true(all(is.finite(ni)))
  # MSE is non-negative
  expect_true(all(fa >= 0))
  expect_true(all(ni >= 0))

  # perr should compute weighted combination without NA
  pe632 <- perr(res, type = "632")
  expect_true(all(is.finite(as.numeric(pe632))))
})
