# randomForestSRC survival backend

Wrappers for random survival forests fitted with randomForestSRC.

## Usage

``` r
fit.rfsrc(response, x, cplx, ...)
complexity.oob.rfsrc(response, x, full.data,
    mtry = unique(pmax(1L, c(floor(sqrt(ncol(x))), floor(ncol(x)/3), ncol(x)))),
    nodesize = c(5L, 15L), ntree = 200L, ...)
# S3 method for class 'rfsrc'
predictProb(object, response, x, times, complexity = NULL, ...)
```

## Arguments

- response:

  survival response as a `Surv` object or a two-column `time`/`status`
  matrix.

- x:

  covariate matrix.

- cplx:

  either a selected `mtry` value or a named list such as
  `list(mtry = ..., nodesize = ...)`.

- full.data:

  full data frame, accepted for the `peperr` complexity-function
  contract.

- mtry:

  candidate `mtry` values for OOB tuning.

- nodesize:

  candidate terminal-node sizes for OOB tuning.

- ntree:

  number of trees used during OOB tuning.

- object:

  a fitted `rfsrc` object.

- times:

  evaluation times for survival probabilities.

- complexity:

  unused for fitted forests; included for interface compatibility.

- ...:

  additional arguments passed to
  [`rfsrc`](https://www.randomforestsrc.org//reference/rfsrc.html) or
  [`predict.rfsrc`](https://www.randomforestsrc.org//reference/predict.rfsrc.html).

## Value

Fitted `rfsrc` objects, tuning lists containing `mtry` and `nodesize`,
and survival-probability matrices.

## Details

No `PLL.rfsrc` method is provided, because random survival forests do
not naturally expose a Cox-style partial likelihood. They can still be
used with `pmpec` through `predictProb.rfsrc`.

## See also

[`peperr`](https://fbertran.github.io/peperr/reference/peperr.md),
[`rfsrc`](https://www.randomforestsrc.org//reference/rfsrc.html),
[`predict.rfsrc`](https://www.randomforestsrc.org//reference/predict.rfsrc.html)
