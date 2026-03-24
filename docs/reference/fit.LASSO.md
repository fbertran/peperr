# Interface function for fitting a generalised linear model with the lasso

Interface for fitting survival models with the lasso, conforming to the
requirements of argument `fit.fun` in `peperr` call.

## Usage

``` r
fit.LASSO(response, x, cplx, ...)
```

## Arguments

- response:

  response. Could be numeric vector for linear regression, `Surv` object
  for Cox regression or a binary vector for logistic regression.

- x:

  `n*p` matrix of covariates.

- cplx:

  LASSO penalty. `lambda1` of `penalized` call.

- ...:

  additional arguments passed to `penalized` call.

## Value

penfit object

## Details

Function is basically a wrapper around function `penalized` of package
`penalized`.

## See also

`peperr`,
[`penalized`](https://rdrr.io/pkg/penalized/man/penalized.html)
