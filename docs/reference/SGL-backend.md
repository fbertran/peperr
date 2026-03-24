# Sparse-group-lasso Cox backend

Wrappers for Cox models fitted with SGL.

## Usage

``` r
fit.SGL.cox(response, x, cplx, index, ...)
complexity.cvSGL.cox(response, x, full.data, index, ...)
# S3 method for class 'SGL_cox'
predictProb(object, response, x, times, complexity = NULL, ...)
# S3 method for class 'SGL_cox'
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

- index:

  group membership vector for the columns of `x`.

- full.data:

  full data frame, accepted for the `peperr` complexity-function
  contract.

- object:

  a fitted `SGL_cox` object.

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
  [`SGL`](https://rdrr.io/pkg/SGL/man/SGL.html) or
  [`cvSGL`](https://rdrr.io/pkg/SGL/man/cvSGL.html).

## Value

Fitted `SGL_cox` objects, selected `lambda` values, survival-probability
matrices, and numeric predictive partial log-likelihood values,
respectively.

## Details

The SGL predictor returns relative risks. The `peperr` wrapper
reconstructs survival probabilities from those risks with a Breslow
baseline estimated on the stored training data.

## See also

[`peperr`](https://fbertran.github.io/peperr/reference/peperr.md),
[`SGL`](https://rdrr.io/pkg/SGL/man/SGL.html),
[`cvSGL`](https://rdrr.io/pkg/SGL/man/cvSGL.html)
