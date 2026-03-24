# Predictive partial log-likelihood for a CoxBoost model fit

Extracts the predictive partial log-likelihood from a CoxBoost model
fit.

## Usage

``` r
# S3 method for class 'CoxBoost'
PLL(object, newdata, newtime, newstatus, complexity, ...)
```

## Arguments

- object:

  fitted model of class `CoxBoost`.

- newdata:

  `n_new*p` matrix of covariates.

- newtime:

  `n_new`-vector of censored survival times.

- newstatus:

  `n_new`-vector of survival status, coded with 0 and 1.

- complexity:

  complexity, either one value, which is the number of boosting steps,
  or a list containing `stepno`.

- ...:

  additional arguments passed to `predict.CoxBoost`.

## Details

Used by function `peperr`, if function `fit.CoxBoost` is used for model
fit.

Since CoxBoost is only suggested by peperr, install it before calling
this function.

## Value

Numeric predictive partial log-likelihood returned by
`predict.CoxBoost`.
