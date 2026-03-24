# Determine the Brier score for a fitted model

Evaluate the Brier score, i.e. prediction error, for a fitted model on
new data. To be used as argument `aggregation.fun` in `peperr` call.

## Usage

``` r
aggregation.brier(full.data=NULL, response, x, model, cplx=NULL,  
type=c("apparent", "noinf"), fullsample.attr = NULL, ...)
```

## Arguments

- full.data:

  passed from `peperr`, but not used for calculation of the Brier score.

- response:

  vector of binary response.

- x:

  `n*p` matrix of covariates.

- model:

  model fitted as returned by a `fit.fun`, as used in a call to
  `peperr`.

- cplx:

  passed from `peperr`, but not necessary for calculation of the Brier
  score.

- type:

  character.

- fullsample.attr:

  passed from `peperr`, but not necessary for calculation of the Brier
  score.

- ...:

  additional arguments, passed to `predict` function.

## Details

The empirical Brier score is the mean of the squared difference of the
risk prediction and the true value of all observations and takes values
between 0 and 1, where small values indicate good prediction performance
of the risk prediction model.

## Value

Scalar, indicating the empirical Brier score.
