# Predictive partial log-likelihood for penalized Cox models

Computes the predictive partial log-likelihood for `penfit` survival
models.

## Usage

``` r
# S3 method for class 'penfit'
PLL(object, newdata, newtime, newstatus, complexity = NULL, ...)
```

## Arguments

- object:

  a fitted `penfit` object.

- newdata:

  new covariate matrix.

- newtime:

  vector of follow-up times.

- newstatus:

  vector of event indicators.

- complexity:

  unused for fitted `penfit` objects; included for interface
  compatibility.

- ...:

  unused additional arguments.

## Value

Numeric predictive partial log-likelihood.

## See also

[`PLL`](https://fbertran.github.io/peperr/reference/PLL.md),
[`fit.penalized`](https://fbertran.github.io/peperr/reference/fit.LASSO.md),
[`predictProb.penfit`](https://fbertran.github.io/peperr/reference/predictProb.penfit.md)
