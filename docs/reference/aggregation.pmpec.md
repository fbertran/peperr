# Determine the prediction error curve for a fitted model

Interface to `pmpec`, for conforming to the structure required by the
argument `aggregation.fun` in `peperr` call. Evaluates the prediction
error curve, i.e. the Brier score tracked over time, for a fitted
survival model.

## Usage

``` r
aggregation.pmpec(full.data, response, x, model, cplx=NULL, times = NULL, 
   type=c("apparent", "noinf"), fullsample.attr = NULL, ...)
```

## Arguments

- full.data:

  data frame with full data set.

- response:

  Either a survival object (with `Surv(time, status)`, where time is an
  `n`-vector of censored survival times and status an `n`-vector
  containing event status, coded with 0 and 1) or a matrix with columns
  `time` containing survival times and `status` containing integers,
  where 0 indicates censoring, 1 the interesting event and larger
  numbers other competing risks.

- x:

  `n*p` matrix of covariates.

- model:

  survival model as returned by `fit.fun` as used in call to `peperr`.

- cplx:

  numeric, number of boosting steps or list, containing number of
  boosting steps in argument `stepno`.

- times:

  vector of evaluation time points. If given, used as well as in
  calculation of full apparent and no-information error as in resampling
  procedure. Not used if `fullsample.attr` is specified.

- type:

  character.

- fullsample.attr:

  vector of evaluation time points, passed in resampling procedure.
  Either user-defined, if `times` were passed as `args.aggregation`, or
  the determined time points from the `aggregation.fun` call with the
  full data set.

- ...:

  additional arguments passed to `pmpec` call.

## Details

If no evaluation time points are passed, they are generated using all
uncensored time points if their number is smaller than 100, or 100 time
points up to the 95% quantile of the uncensored time points are taken.

`pmpec` requires a `predictProb` method for the class of the fitted
model, i.e. for a model of class `class` `predictProb.class`.

## Value

A matrix with one row. Each column represents the estimated prediction
error of the fit at the time points.

## See also

`peperr`, `predictProb`, `pmpec`
