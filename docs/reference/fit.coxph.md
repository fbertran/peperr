# Interface function for fitting a Cox proportional hazards model

Interface for fitting survival models by Cox proporional hazards model,
conforming to the requirements for argument `fit.fun` in `peperr` call.

## Usage

``` r
fit.coxph(response, x, cplx, ...)
```

## Arguments

- response:

  a survival object (with `Surv(time, status)`).

- x:

  `n*p` matrix of covariates.

- cplx:

  not used.

- ...:

  additional arguments passed to `coxph` call.

## Value

coxph object

## Details

Function is basically a wrapper around `coxph` of package survival.

## See also

`peperr`, [`coxph`](https://rdrr.io/pkg/survival/man/coxph.html)
