# Penalized backend fitting wrappers

Interface functions for fitting penalized models in `peperr`. The
generic wrapper is `fit.penalized`; `fit.LASSO` and `fit.fusedLASSO` are
convenience aliases for plain and fused lasso fits.

## Usage

``` r
fit.penalized(response, x, cplx, ...)
fit.LASSO(response, x, cplx, ...)
fit.fusedLASSO(response, x, cplx, ...)
```

## Arguments

- response:

  response. This can be a binary vector, a numeric response, a `Surv`
  object, or a two-column matrix with `time` and `status`.

- x:

  `n * p` matrix of covariates.

- cplx:

  complexity value. For the penalized backend this is usually `lambda1`,
  or a named list of tuning arguments.

- ...:

  additional arguments passed to
  [`penalized`](https://rdrr.io/pkg/penalized/man/penalized.html).

## Value

A fitted `penfit` object.

## Details

`fit.penalized` is the general wrapper around
[`penalized`](https://rdrr.io/pkg/penalized/man/penalized.html). For
survival models it also stores the training design matrix and response
so that `predictProb.penfit` and `PLL.penfit` can be used later by
`pmpec` and `peperr`.

`fit.LASSO` simply calls `fit.penalized`. `fit.fusedLASSO` calls the
same backend with `fusedl = TRUE`.

## See also

[`complexity.cv.penalized`](https://fbertran.github.io/peperr/reference/complexity.LASSO.md),
[`predictProb.penfit`](https://fbertran.github.io/peperr/reference/predictProb.penfit.md),
[`PLL.penfit`](https://fbertran.github.io/peperr/reference/PLL.penfit.md),
[`penalized`](https://rdrr.io/pkg/penalized/man/penalized.html)
