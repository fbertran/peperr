# Generic function for extracting predicted survival probabilities

Generic function for extraction of predicted survival probabilities from
a fitted survival model conforming to the interface required by `pmpec`.

## Usage

``` r
predictProb(object, response, x, ...)
```

## Arguments

- object:

  a fitted survival model.

- response:

  Either a survival object (with `Surv(time, status)`, where time is an
  `n`-vector of censored survival times and status an `n`-vector
  containing event status, coded with 0 and 1) or a matrix with columns
  `time` containing survival times and `status` containing integers,
  where 0 indicates censoring, 1 the interesting event and larger
  numbers other competing risks. In case of binary response, vector with
  entries 0 and 1.

- x:

  `n*p` matrix of covariates.

- ...:

  additional arguments, for example model complexity or, in case of
  survival response, argument `times`, a vector containing evaluation
  times.

## Details

`pmpec` requires a `predictProb.class` function for each model fit of
class `class`. It extracts the predicted probability of survival from
this model.

See existing `predictProb` functions, at the time
`predictProb.CoxBoost`, `predictProb.coxph`, `predictProb.survfit`,
`predictProb.penfit`, `predictProb.coxnet`, `predictProb.grpsurv`,
`predictProb.ncvsurv`, `predictProb.rfsrc`, `predictProb.mboost_coxph`,
and `predictProb.SGL_cox`.

If desired `predictProb` function for class `class` is not available in
peperr, but implemented in package pec as `predictSurvProb.class`, it
can easily be transformed as `predictProb` method.

## Value

Matrix with predicted probabilities for each evaluation time point in
`times` (columns) and each new observation (rows).
