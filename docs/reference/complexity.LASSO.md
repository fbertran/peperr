# Interface for selection of optimal parameter for lasso fit

Determines the optimal value for tuning parameter lambda for a
regression model with lasso penalties via cross-validation. Conforming
to the calling convention required by argument `complexity` in `peperr`
call.

## Usage

``` r
complexity.LASSO(response, x, full.data, ...)
```

## Arguments

- response:

  a survival object (`Surv(time, status)`).

- x:

  `n*p` matrix of covariates.

- full.data:

  data frame containing response and covariates of the full data set.

- ...:

  additional arguments passed to `optL1` of package penalized call.

## Value

Scalar value giving the optimal value for lambda.

## Details

Function is basically a wrapper around `optL1` of package penalized.
Calling `peperr`, default arguments of `optL1` can be changed by passing
a named list containing these as argument `args.complexity`.

## See also

`peperr`, [`optL1`](https://rdrr.io/pkg/penalized/man/cvl.html)
