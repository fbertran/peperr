# Extract predicted survival probabilities from a survfit object

Extracts predicted survival probabilities for survival models fitted by
`survfit`, providing an interface as required by `pmpec`.

## Usage

``` r
# S3 method for class 'survfit'
predictProb(object, response, x, times, train.data, ...)
```

## Arguments

- object:

  a fitted model of class `survfit`.

- response:

  survival object (with `Surv(time, status)`, where time is an
  `n`-vector of censored survival times and status an `n`-vector
  containing survival status, coded with 0 and 1.

- x:

  `n*p` matrix of covariates.

- times:

  vector of evaluation time points.

- train.data:

  not used.

- ...:

  additional arguments, currently not used.

## Value

Matrix with probabilities for each evaluation time point in
`times`(columns) and each new observation (rows).
