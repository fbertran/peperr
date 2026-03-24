# grpreg grouped Cox backend

Wrappers for grouped survival models fitted with grpreg.

## Usage

``` r
fit.grpsurv(response, x, cplx, group, ...)
complexity.cv.grpsurv(response, x, full.data, group, ...)
# S3 method for class 'grpsurv'
predictProb(object, response, x, times, complexity = NULL, ...)
# S3 method for class 'grpsurv'
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

- group:

  group membership vector for the columns of `x`.

- full.data:

  full data frame, accepted for the `peperr` complexity-function
  contract.

- object:

  a fitted `grpsurv` object.

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
  [`grpsurv`](https://pbreheny.github.io/grpreg/reference/grpsurv.html),
  [`cv.grpreg`](https://pbreheny.github.io/grpreg/reference/cv.grpreg.html),
  or `predict`.

## Value

Fitted `grpsurv` objects, scalar `lambda` values, survival-probability
matrices, and numeric predictive partial log-likelihood values,
respectively.

## Details

The grouped backend exposes grouped lasso, grouped MCP, grouped SCAD,
and related penalties through the native grpreg arguments passed in
`...`.

## See also

[`peperr`](https://fbertran.github.io/peperr/reference/peperr.md),
[`grpsurv`](https://pbreheny.github.io/grpreg/reference/grpsurv.html),
[`cv.grpreg`](https://pbreheny.github.io/grpreg/reference/cv.grpreg.html)
