# Interface function for fitting a CoxBoost model

Interface for fitting survival models by `CoxBoost`, conforming to the
requirements for argument `fit.fun` in `peperr` call.

## Usage

``` r
fit.CoxBoost(response, x, cplx, ...)
```

## Arguments

- response:

  a survival object (with `Surv(time, status)`).

- x:

  `n*p` matrix of covariates.

- cplx:

  number of boosting steps, or a list containing at least `stepno` and
  optionally further `CoxBoost` tuning arguments.

- ...:

  additional arguments passed to `CoxBoost` call.

## Value

CoxBoost object

## Details

Function is basically a wrapper around `CoxBoost` of package CoxBoost. A
Cox proportional hazards model is fitted by componentwise likelihood
based boosting, especially suited for models with many covariates and
few observations.

Since CoxBoost is only suggested by peperr, install it before calling
this function.

## See also

`peperr`, [`CoxBoost`](https://rdrr.io/pkg/CoxBoost/man/CoxBoost.html)
