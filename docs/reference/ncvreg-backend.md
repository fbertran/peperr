# ncvreg survival backend

Wrappers for Cox models fitted with ncvreg.

## Usage

``` r
fit.ncvsurv(response, x, cplx, ...)
complexity.cv.ncvsurv(response, x, full.data, ...)
# S3 method for class 'ncvsurv'
predictProb(object, response, x, times, complexity = NULL, ...)
# S3 method for class 'ncvsurv'
PLL(object, newdata, newtime, newstatus, complexity = NULL, ...)
```

## Arguments

- response:

  survival response as a `Surv` object or a two-column `time`/`status`
  matrix.

- x:

  covariate matrix.

- cplx:

  selected `lambda` value.

- full.data:

  full data frame, accepted for the `peperr` complexity-function
  contract.

- object:

  a fitted `ncvsurv` object.

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

  additional arguments passed to `ncvsurv`, `cv.ncvsurv`, or `predict`.

## Value

Fitted `ncvsurv` objects, selected `lambda` values, survival-probability
matrices, and numeric predictive partial log-likelihood values,
respectively.

## Details

The implementation first tries the native ncvreg survival prediction
method. If that is unavailable for the installed version, it falls back
to a Breslow baseline built from stored training data and linear
predictors.

## See also

[`peperr`](https://fbertran.github.io/peperr/reference/peperr.md),
[`predictProb`](https://fbertran.github.io/peperr/reference/predictProb.md),
[`PLL`](https://fbertran.github.io/peperr/reference/PLL.md)
