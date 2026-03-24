# Extract predicted survival probabilities from a coxph object

Extracts predicted survival probabilities for survival models fitted by
Cox proportional hazards model, providing an interface as required by
`pmpec`.

## Usage

``` r
# S3 method for class 'coxph'
predictProb(object, response, x, times, ...)
```

## Arguments

- object:

  a fitted model of class `coxph`.

- response:

  survival object (with `Surv(time, status)`, where time is an
  `n`-vector of censored survival times and status an `n`-vector
  containing survival status, coded with 0 and 1.

- x:

  `n*p` matrix of covariates.

- times:

  vector of evaluation time points.

- ...:

  additional arguments, currently not used.

## Value

Matrix with probabilities for each evaluation time point in
`times`(columns) and each new observation (rows).
