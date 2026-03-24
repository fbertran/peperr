# Predicted survival probabilities for penalized Cox models

Extracts survival probabilities from a `penfit` survival model for use
in `pmpec`.

## Usage

``` r
# S3 method for class 'penfit'
predictProb(object, response, x, times, complexity = NULL, ...)
```

## Arguments

- object:

  a fitted `penfit` object.

- response:

  survival response, passed for consistency with the `predictProb`
  interface.

- x:

  new covariate matrix.

- times:

  evaluation times.

- complexity:

  unused for fitted `penfit` objects; included for interface
  compatibility.

- ...:

  additional arguments passed to the penalized prediction method.

## Value

Matrix of survival probabilities with one row per observation and one
column per evaluation time.

## See also

[`predictProb`](https://fbertran.github.io/peperr/reference/predictProb.md),
[`fit.penalized`](https://fbertran.github.io/peperr/reference/fit.LASSO.md),
[`PLL.penfit`](https://fbertran.github.io/peperr/reference/PLL.penfit.md)
