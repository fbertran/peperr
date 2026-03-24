# glmnet Cox backend

Wrappers that integrate glmnet Cox models into the `peperr`
fit/complexity/prediction interface.

## Usage

``` r
fit.glmnet(response, x, cplx, ...)
complexity.cv.glmnet(response, x, full.data, ...)
# S3 method for class 'coxnet'
predictProb(object, response, x, times, complexity = NULL, ...)
# S3 method for class 'coxnet'
PLL(object, newdata, newtime, newstatus, complexity = NULL, ...)
```

## Arguments

- response:

  survival response as a `Surv` object or a two-column `time`/`status`
  matrix.

- x:

  covariate matrix.

- cplx:

  selected `lambda` value for `glmnet`.

- full.data:

  full data frame, accepted for the `peperr` complexity-function
  contract.

- object:

  a fitted `coxnet` object.

- times:

  evaluation times for survival probabilities.

- complexity:

  selected `lambda` value.

- newdata:

  new covariate matrix.

- newtime:

  vector of follow-up times.

- newstatus:

  vector of event indicators.

- ...:

  additional arguments passed to
  [`glmnet`](https://glmnet.stanford.edu/reference/glmnet.html),
  [`cv.glmnet`](https://glmnet.stanford.edu/reference/cv.glmnet.html),
  `survfit.coxnet`, or `predict`.

## Value

`fit.glmnet` returns a fitted `coxnet` object. `complexity.cv.glmnet`
returns a scalar `lambda`. `predictProb.coxnet` returns an
`n * length(times)` survival-probability matrix. `PLL.coxnet` returns a
numeric predictive partial log-likelihood.

## Details

The backend stores the training design matrix and survival outcome on
the fitted object so that the `survfit.coxnet` method can be reused
later when `pmpec` calls `predictProb`.

## See also

[`peperr`](https://fbertran.github.io/peperr/reference/peperr.md),
[`predictProb`](https://fbertran.github.io/peperr/reference/predictProb.md),
[`PLL`](https://fbertran.github.io/peperr/reference/PLL.md),
[`glmnet`](https://glmnet.stanford.edu/reference/glmnet.html),
[`cv.glmnet`](https://glmnet.stanford.edu/reference/cv.glmnet.html)
