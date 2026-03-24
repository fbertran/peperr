# mboost Cox backend

Wrappers for Cox boosting models fitted with mboost.

## Usage

``` r
fit.mboost.coxph(response, x, cplx, ...)
complexity.cvrisk.mboost(response, x, full.data, max.mstop = 100L, folds = NULL, ...)
# S3 method for class 'mboost_coxph'
predictProb(object, response, x, times, complexity = NULL, ...)
# S3 method for class 'mboost_coxph'
PLL(object, newdata, newtime, newstatus, complexity = NULL, ...)
```

## Arguments

- response:

  survival response as a `Surv` object or a two-column `time`/`status`
  matrix.

- x:

  covariate matrix.

- cplx:

  selected stopping iteration `mstop`.

- full.data:

  full data frame, accepted for the `peperr` complexity-function
  contract.

- max.mstop:

  maximum number of boosting iterations considered during
  cross-validation.

- folds:

  optional mboost fold specification passed to `cvrisk`.

- object:

  a fitted `mboost_coxph` object.

- times:

  evaluation times for survival probabilities.

- complexity:

  selected stopping iteration.

- newdata:

  new covariate matrix.

- newtime:

  vector of follow-up times.

- newstatus:

  vector of event indicators.

- ...:

  additional arguments passed to
  [`glmboost`](https://rdrr.io/pkg/mboost/man/glmboost.html),
  [`cvrisk`](https://rdrr.io/pkg/mboost/man/cvrisk.html), or prediction
  helpers.

## Value

Fitted `mboost_coxph` objects, selected stopping iterations,
survival-probability matrices, and numeric predictive partial
log-likelihood values, respectively.

## Details

If mboost provides native survival-curve predictions for the fitted
model, `predictProb.mboost_coxph` uses them. Otherwise it falls back to
a Breslow baseline estimated from the stored training data and linear
predictors.

## See also

[`peperr`](https://fbertran.github.io/peperr/reference/peperr.md),
[`glmboost`](https://rdrr.io/pkg/mboost/man/glmboost.html),
[`cvrisk`](https://rdrr.io/pkg/mboost/man/cvrisk.html)
