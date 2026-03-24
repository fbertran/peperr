# Interface function for CoxBoost complexity selection via integrated prediction error curves

Determines the number of boosting steps for a survival model fitted by
`CoxBoost` via integrated prediction error curve estimates, conforming
to the calling convention required by argument `complexity` in `peperr`
call.

## Usage

``` r
complexity.ipec.CoxBoost(response, x, boot.n.c = 10, boost.steps = 100,
   eval.times = NULL, smooth = FALSE, full.data, ...)

complexity.ripec.CoxBoost(response, x, boot.n.c = 10, boost.steps = 100,
   eval.times = NULL, smooth = FALSE, full.data, ...)
```

## Arguments

- response:

  a survival object (with `Surv(time, status)`).

- x:

  `n*p` matrix of covariates.

- boot.n.c:

  number of bootstrap samples.

- boost.steps:

  maximum number of boosting steps, i.e. number of boosting steps is
  selected out of the interval `[1, boost.steps]`.

- eval.times:

  vector of evaluation time points.

- smooth:

  logical. Shall the prediction error curve be smoothed by local
  polynomial regression before integration?

- full.data:

  data frame containing response and covariates of the full data set.

- ...:

  additional arguments passed to `CoxBoost` call.

## Value

Scalar value giving the number of boosting steps.

## Details

Plotting the .632+ estimator for each time point given in `eval.times`
results in a prediction error curve. A summary measure can be obtained
by integrating over time. `complexity.ripec.CoxBoost` computes a Riemann
integral, while `complexity.ipec.CoxBoost` uses a Lebesgue-like integral
taking Kaplan-Meier estimates as weights. The number of boosting steps
for which the minimal integrated error is obtained is returned.

Since CoxBoost is only suggested by peperr, install it before calling
these functions. If `smooth = TRUE`, locfit is also required.

## See also

`peperr`, [`CoxBoost`](https://rdrr.io/pkg/CoxBoost/man/CoxBoost.html)
