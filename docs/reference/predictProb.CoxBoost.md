# Extract predicted survival probabilities from a CoxBoost fit

Extracts predicted survival probabilities from a survival model fitted
by `CoxBoost`, providing an interface as required by `pmpec`.

## Usage

``` r
# S3 method for class 'CoxBoost'
predictProb(object, response, x, times, complexity, ...)
```

## Arguments

- object:

  a fitted model of class `CoxBoost`.

- response:

  survival object (with `Surv(time, status)`, where time is an
  `n`-vector of censored survival times and status an `n`-vector
  containing survival status, coded with 0 and 1).

- x:

  `n*p` matrix of covariates.

- times:

  vector of evaluation time points.

- complexity:

  complexity value, or a list containing `stepno`.

- ...:

  additional arguments passed to `predict.CoxBoost`.

## Details

Since CoxBoost is only suggested by peperr, install it before calling
this function.

## Value

Matrix with probabilities for each evaluation time point in `times`
(columns) and each new observation (rows).
