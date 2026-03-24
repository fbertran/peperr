test_that("penalized survival backend works through peperr", {
  skip_on_cran()
  if (!requireNamespace("penalized", quietly = TRUE)) skip("penalized not installed")

  expect_survival_backend_flow(
    fit.fun = fit.penalized,
    complexity = complexity.cv.penalized,
    seed = 10
  )
})

test_that("fused-lasso convenience wrapper works", {
  skip_on_cran()
  if (!requireNamespace("penalized", quietly = TRUE)) skip("penalized not installed")

  expect_survival_backend_flow(
    fit.fun = fit.fusedLASSO,
    complexity = complexity.fusedLASSO,
    seed = 11
  )
})

test_that("glmnet Cox backend works through peperr", {
  skip_on_cran()
  if (!requireNamespace("glmnet", quietly = TRUE)) skip("glmnet not installed")

  expect_survival_backend_flow(
    fit.fun = fit.glmnet,
    complexity = complexity.cv.glmnet,
    args.fit = list(alpha = 0.5),
    args.complexity = list(alpha = 0.5, nfolds = 3),
    seed = 12
  )
})

test_that("grpreg survival backend works through peperr", {
  skip_on_cran()
  if (!requireNamespace("grpreg", quietly = TRUE)) skip("grpreg not installed")

  group <- rep(1:3, each = 2)
  expect_survival_backend_flow(
    fit.fun = fit.grpsurv,
    complexity = complexity.cv.grpsurv,
    args.fit = list(group = group, penalty = "grLasso"),
    args.complexity = list(group = group, penalty = "grLasso", nfolds = 3),
    seed = 13
  )
})

test_that("SGL Cox backend works through peperr", {
  skip_on_cran()
  if (!requireNamespace("SGL", quietly = TRUE)) skip("SGL not installed")

  index <- rep(1:3, each = 2)
  expect_survival_backend_flow(
    fit.fun = fit.SGL.cox,
    complexity = complexity.cvSGL.cox,
    args.fit = list(index = index, nlam = 6),
    args.complexity = list(index = index, nfold = 3, nlam = 6),
    seed = 14
  )
})

test_that("missing optional backend packages fail with clear guidance", {
  dat <- tiny_survival_fixture(seed = 20, n = 12, p = 4)

  if (!requireNamespace("ncvreg", quietly = TRUE)) {
    expect_error(
      fit.ncvsurv(dat$response, dat$x, cplx = 0),
      "Package 'ncvreg' is required"
    )
  }

  if (!requireNamespace("randomForestSRC", quietly = TRUE)) {
    expect_error(
      fit.rfsrc(dat$response, dat$x, cplx = 0),
      "Package 'randomForestSRC' is required"
    )
  }

  if (!requireNamespace("mboost", quietly = TRUE)) {
    expect_error(
      fit.mboost.coxph(dat$response, dat$x, cplx = 0),
      "Package 'mboost' is required"
    )
  }
})
