# Determine the missclassification rate for a fitted model

Evaluate the misclassification rate, i.e. prediction error, for a fitted
model on new data. To use as argument `aggregation.fun` in `peperr`
call.

## Usage

``` r
aggregation.misclass(full.data=NULL, response, x, model, cplx=NULL,  
type=c("apparent", "noinf"), fullsample.attr = NULL, ...)
```

## Arguments

- full.data:

  passed from `peperr`, but not used for calculation of the
  misclassification rate.

- response:

  vector of binary response.

- x:

  `n*p` matrix of covariates.

- model:

  model fitted with `fit.fun`.

- cplx:

  passed from `peperr`, but not necessary for calculation of the
  misclassification rate.

- type:

  character.

- fullsample.attr:

  passed from `peperr`, but not necessary for calculation of the
  misclassification rate.

- ...:

  additional arguments, passed to `predict` function.

## Details

Misclassification rate is the ratio of observations for which prediction
of response is wrong.

## Value

Scalar, indicating the misclassification rate.
