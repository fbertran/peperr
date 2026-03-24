# Generation of indices for resampling Procedure

Generates training and test set indices for use in resampling estimation
of prediction error, e.g. cross-validation or bootstrap (with and
without replacement).

## Usage

``` r
resample.indices(n, sample.n = 100, method = c("no", "cv" ,"boot", "sub632"))
```

## Arguments

- n:

  number of observations of the full data set.

- sample.n:

  the number of bootstrap samples in case of `method="boot"` and the
  number of cross-validation subsets in case of `method="cv"`, e.g. 10
  for 10-fold cross-validation. Not considered if `method="no"`, where
  number of samples is one (the full data set) by definition.

- method:

  by default, the training set indices are the same as the test set
  indices, i.e. the model is assessed in the same data as fitted
  (`"no"`). `"cv"`: Cross-validation, `"boot"`: Bootstrap (with
  replacement), `"sub632"`: Boostrap without replacement, also called
  subsampling. In the latter case, the number of observations in each
  sample equals `round(0.632 * n)`, see Details.

## Value

A list containing two lists of length `sample.n`:

- sample.index:

  contains in each element the indices of observations of one training
  set.

- not.in.sample:

  contains in each element the indices of observations of one test set,
  corresponding to the training set in listelement `sample.index`.

## Details

As each bootstrap sample should be taken as if new data, complexity
selection should be carried out in each bootstrap sample. Binder and
Schumacher show that when bootstrap samples are drawn with replacement,
often too complex models are obtained in high-dimensional data settings.
They recommend to draw bootstrap samples without replacement, each of
size `round(0.632 * n)`, which equals the expected number of unique
observations in one bootstrap sample drawn with replacement, to avoid
biased complexity selection and improve predictive power of the
resulting models.

## References

Binder, H. and Schumacher, M. (2008) Adapting prediction error estimates
for biased complexity selection in high-dimensional bootstrap samples.
Statistical Applications in Genetics and Molecular Biology, 7:1.

## See also

`peperr`

## Examples

``` r
# generate dataset: 100 patients, 20 covariates
data <- matrix(rnorm(2000), nrow=100)

# generate indices for training and test data for 10-fold cross-validation
indices <- resample.indices(n=100, sample.n = 10, method = "cv")

# create training and test data via indices
trainingsample1 <- data[indices$sample.index[[1]],]
testsample1 <- data[indices$not.in.sample[[1]],]
```
