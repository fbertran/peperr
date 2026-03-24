# Interface for CoxBoost selection of the optimal number of boosting steps via cross-validation

Determines the number of boosting steps for a survival model fitted by
`CoxBoost` via cross-validation, conforming to the calling convention
required by argument `complexity` in `peperr` call.

## Usage

``` r
complexity.mincv.CoxBoost(response, x, full.data, ...)
```

## Arguments

- response:

  a survival object (`Surv(time, status)`).

- x:

  `n*p` matrix of covariates.

- full.data:

  data frame containing response and covariates of the full data set.

- ...:

  additional arguments passed to `cv.CoxBoost` call.

## Value

Scalar value giving the optimal number of boosting steps.

## Details

Function is basically a wrapper around `cv.CoxBoost` of package
CoxBoost. A K-fold cross-validation (default K = 10) is performed to
search the optimal number of boosting steps, per default in the interval
`[0, maxstepno]`. Calling `peperr`, the default arguments of
`cv.CoxBoost` can be changed by passing a named list containing these as
argument `args.complexity`.

Since CoxBoost is only suggested by peperr, install it before calling
this function.

## See also

`peperr`,
[`cv.CoxBoost`](https://rdrr.io/pkg/CoxBoost/man/cv.CoxBoost.html)
