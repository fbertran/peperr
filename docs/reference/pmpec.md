# Calculate prediction error curves

Calculation of prediction error curve from a survival response and
predicted probabilities of survival.

## Usage

``` r
pmpec(object, response=NULL, x=NULL, times, model.args=NULL, 
    type=c("PErr","NoInf"), external.time=NULL, external.status=NULL, 
    data=NULL)
```

## Arguments

- object:

  fitted model of a class for which the interface function
  `predictProb.class` is available.

- response:

  Either a survival object (with `Surv(time, status)`, where time is an
  `n`-vector of censored survival times and status an `n`-vector
  containing event status, coded with 0 and 1) or a matrix with columns
  `time` containing survival times and `status` containing integers,
  where 0 indicates censoring, 1 the interesting event and larger
  numbers other competing risks.

- x:

  `n*p` matrix of covariates.

- times:

  vector of time points at which the prediction error is to be
  estimated.

- model.args:

  named list of additional arguments, e.g. complexity value, which are
  to be passed to `predictProb` function.

- type:

  type of output: Estimated prediction error (default) or no information
  error (prediction error obtained by permuting the data).

- external.time:

  optional vector of time points, used for censoring distribution.

- external.status:

  optional vector of status values, used for censoring distribution.

- data:

  Data frame containing `n`-vector of observed times ('time'),
  `n`-vector of event status ('status') and `n*p` matrix of covariates
  (remaining entries). Alternatively to `response` and `x`, for
  compatibility to pec.

## Value

Vector of prediction error estimates at each time point given in `time`.

## Details

Prediction error of survival data is measured by the Brier score, which
considers the squared difference of the true event status at a given
time point and the predicted event status by a risk prediction model at
that time. A prediction error curve is the weighted mean Brier score as
a function of time at time points in `times` (see References).

`pmpec` requires a `predictProb` method for the class of the fitted
model, i.e. for a model of class `class` `predictProb.class`.

`pmpec` is implemented to behave similar to function `pec` of package
pec, which provides several `predictProb` methods.

In bootstrap framework, `data` contains only a part of the full data
set. For censoring distribution, the full data should be used to avoid
extreme variance in case of small data sets. For that, the observed
times and status values can be passed as argument `external.time` and
`external.status`.

## See also

`predictProb`, pec

## Author

Harald Binder

## References

Gerds, A. and Schumacher, M. (2006) Consistent estimation of the
expected Brier score in general survival models with right-censored
event times. Biometrical Journal, 48, 1029–1040.

Schoop, R. (2008) Predictive accuracy of failure time models with
longitudinal covariates. PhD thesis, University of Freiburg.
http://www.freidok.uni-freiburg.de/volltexte/4995/.
