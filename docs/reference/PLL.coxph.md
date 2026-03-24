# Predictive partial log-likelihood for Cox poportional hazards model

Extracts the predictive partial log-likelihood from a coxph model fit.

## Usage

``` r
# S3 method for class 'coxph'
PLL(object, newdata, newtime, newstatus, complexity, ...)
```

## Arguments

- object:

  fitted model of class `coxph`.

- newdata:

  `n_new*p` matrix of covariates.

- newtime:

  `n_new`-vector of censored survival times.

- newstatus:

  `n_new`-vector of survival status, coded with 0 and .1

- complexity:

  not used.

- ...:

  additional arguments, not used.

## Details

Used by function `peperr`, if function `fit.coxph` is used for model
fit.

## Value

Vector of length `n_new`
