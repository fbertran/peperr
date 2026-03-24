# Complexity selection helpers for penalized backends

Wrapper functions for choosing the penalized tuning parameter used by
`fit.penalized`, `fit.LASSO`, and `fit.fusedLASSO`.

## Usage

``` r
complexity.cv.penalized(response, x, full.data, ...)
complexity.LASSO(response, x, full.data, ...)
complexity.fusedLASSO(response, x, full.data, ...)
```

## Arguments

- response:

  response used for model fitting. Survival responses may be passed as a
  `Surv` object or as a two-column matrix with `time` and `status`.

- x:

  `n * p` matrix of covariates.

- full.data:

  data frame containing the full data set. This argument is accepted to
  match the `peperr` complexity-function contract.

- ...:

  additional arguments passed to
  [`profL1`](https://rdrr.io/pkg/penalized/man/cvl.html).

## Value

A scalar tuning value, typically the selected `lambda1`.

## Details

`complexity.cv.penalized` profiles the cross-validated `lambda1` values
returned by [`profL1`](https://rdrr.io/pkg/penalized/man/cvl.html) and
keeps the maximizer. `complexity.LASSO` is a compatibility alias.
`complexity.fusedLASSO` performs the same search while forwarding
`fusedl = TRUE`.

## See also

[`fit.penalized`](https://fbertran.github.io/peperr/reference/fit.LASSO.md),
[`fit.LASSO`](https://fbertran.github.io/peperr/reference/fit.LASSO.md),
[`fit.fusedLASSO`](https://fbertran.github.io/peperr/reference/fit.LASSO.md),
[`profL1`](https://rdrr.io/pkg/penalized/man/cvl.html)
