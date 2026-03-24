# Parallelised Estimation of Prediction Error

Prediction error estimation for regression models via resampling
techniques. Potentially parallelised, if compute cluster is available.

## Usage

``` r
peperr(response, x, 
  indices = NULL, 
  fit.fun, complexity = NULL, args.fit = NULL, args.complexity = NULL,
  parallel = NULL, cpus = 2, clustertype=NULL, clusterhosts=NULL,
  noclusterstart = FALSE, noclusterstop=FALSE,
  aggregation.fun=NULL, args.aggregation = NULL, 
  load.list = extract.fun(list(fit.fun, complexity, aggregation.fun)),
  load.vars = NULL, load.all = FALSE, 
  trace = FALSE, debug = FALSE,
  peperr.lib.loc=NULL, 
        RNG=c("RNGstream", "SPRNG", "fixed", "none"), seed=NULL, 
        lb=FALSE, sr=FALSE, sr.name="default", sr.restore=FALSE)
```

## Arguments

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

- indices:

  named list, with two elements (both expected to be lists)
  `sample.index`, containing the vector of indices of observations used
  to fit the model, and list `not.in.sample`, containing the vector of
  indices of observations used for assessment. One list entry per split.
  Function `resample.indices` provides the most common resampling
  methods. If argument `indices` is not specified (default), the indices
  are determined as follows: If number of observations in the passed
  data matrix is smaller than number of covariates, 500 bootstrap
  samples without replacement are generated ("subsampling"), else 500
  bootstrap samples with replacement.

- fit.fun:

  function returning a fitted model, see Details.

- complexity:

  if the choice of a complexity parameter is necessary, for example the
  number of boosting steps in boosting techniques, a function returning
  complexity parameter for model fitted with fit.fun, see Details.
  Alternatively, one explicit value for the complexity or a vector of
  values can be passed. In the latter case, the model fit is carried out
  for each of the complexity parameters. Alternatively, a named list can
  be passed, if complexity is a tuple of different parameter values.

- args.fit:

  named list of arguments to be passed to the function given in
  `fit.fun`.

- args.complexity:

  if `complexity` is a function, a named list of arguments to be passed
  to this function.

- parallel:

  the default setting corresponds to the case that sfCluster is used or
  if R runs sequential, i.e. without any parallelisation. If sfCluster
  is used, settings from sfCluster commandline call are taken, i.e. the
  required number of nodes has to be specified as option of the
  sfCluster call (and not using argument `cpus`). If another cluster
  solution (specified by argument `clustertype`) shall be used, a
  cluster with `cpus` CPUs is started if `parallel=TRUE`.
  `parallel=FALSE` switches back to sequential execution. See Details.

- cpus:

  number of nodes, i.e., number of parallel running R processes, to be
  set up in a cluster, if not specified by commandline call. Only needed
  if `parallel=TRUE`.

- clustertype:

  type of cluster, character. 'SOCK' for socket cluster, 'MPI', 'PVM' or
  'NWS'. Only considered if `parallel=TRUE`. If so, a socket cluster,
  which does not require any additional installation, is started as
  default.

- clusterhosts:

  host list for socket and NWS clusters, if `parallel=TRUE`. Has to be
  specified only if using more than one machine.

- noclusterstart:

  if function is used in already parallelised code. If set to TRUE, no
  cluster is initialised even if a compute cluster is available and
  function works in sequential mode. Additionally usable if calls on the
  slaves should be executed before calling function `peperr`, for
  example to load data on slaves, see Details.

- noclusterstop:

  if TRUE, cluster stop is suppressed. Useful for debugging of sessions
  on slaves. Note that the next `peperr` call forces cluster stop,
  except if called with `noclusterstart=TRUE`.

- aggregation.fun:

  function that evaluates the prediction error for a model fitted by the
  function given in `fit.fun`, see Details. If not specified, function
  `aggregation.pmpec` is taken if response is survival object, in case
  of binary response function `aggregation.brier`.

- args.aggregation:

  named list of arguments to be passed to the function given in argument
  `aggregation.fun`.

- load.list:

  a named list with element `packages`, `functions` and `variables`
  containing quoted names of libraries, functions and global variables
  required for computation on cluster nodes. The default extracts
  automatically the libraries, functions and global variables of the,
  potentially user-defined, functions `fit.fun`, `complexity` and
  `aggregation.fun`, see function `extract.fun`. Can be set to NULL,
  e.g. if no libraries, functions and variables are needed.
  Alternatively, use argument `load.all`. See Details.

- load.vars:

  a named list with global variables required for computation on cluster
  nodes. See Details. Relict, global variabels can now be passed as list
  element `variables` of argument `load.list`.

- load.all:

  logical. If set to TRUE, all variables, functions and libraries of the
  current global environment are loaded on cluster nodes. See Details.

- trace:

  logical. If TRUE, output about the current execution step is printed
  (if running parallel: printed on nodes, that means not visible in
  master R process, see Details).

- debug:

  if TRUE, information concerning export of variables is given.

- peperr.lib.loc:

  location of package peperr if not in standard library search path
  ([`.libPaths()`](https://rdrr.io/r/base/libPaths.html)), to be
  specified for loading peperr onto the cluster nodes.

- RNG:

  type of RNG. `"fixed"` requires a specified `seed`. `"RNGstream"` uses
  its default seed if not specified. `"SPRNG"` is retained only for
  backward compatibility and now triggers an error explaining that it is
  no longer supported. See Details.

- seed:

  seed to allow reproducibility of results. Only considered if argument
  `RNG` is not `"none"`. See Details.

- lb:

  if TRUE and a compute cluster is used, computation of slaves is
  executed load balanced. See Details.

- sr:

  if TRUE, intermediate results are saved. If execution is interrupted,
  they can be restored by setting argument sr.restore to TRUE. See
  documentation of package snowfall for details

- sr.name:

  if `sr` is set to TRUE and more than one computation runs
  simultaneously, unique names need to be used.

- sr.restore:

  if `sr` is set to TRUE, an interrupted computation is restarted.

## Details

Validation of new model fitting approaches requires the proper use of
resampling techniques for prediction error estimation. Especially in
high-dimensional data situations the computational demand might be huge.
`peperr` accelerates computation through automatically parallelisation
of the resampling procedure, if a compute cluster is available. A
noticeable speed-up is reached even when using a dual-core processor.

Resampling based prediction error estimation requires for each split in
training and test data the following steps: a) selection of model
complexity (if desired), using the training data set, b) fitting the
model with the selected (or a given) complexity on the training set and
c) measurement of prediction error on the corresponding test set.

Functions for fitting the model, determination of model complexity, if
required by the fitting procedure, and aggregating the prediction error
are passed as arguments `fit.fun`, `complexity` and `aggregation.fun`.
Already available functions are

for model fit: `fit.CoxBoost`, `fit.coxph`, `fit.penalized`,
`fit.LASSO`, `fit.fusedLASSO`, `fit.glmnet`, `fit.grpsurv`,
`fit.ncvsurv`, `fit.rfsrc`, `fit.mboost.coxph`, `fit.SGL.cox`

to determine complexity: `complexity.mincv.CoxBoost`,
`complexity.ipec.CoxBoost`, `complexity.ripec.CoxBoost`,
`complexity.cv.penalized`, `complexity.LASSO`, `complexity.fusedLASSO`,
`complexity.cv.glmnet`, `complexity.cv.grpsurv`,
`complexity.cv.ncvsurv`, `complexity.oob.rfsrc`,
`complexity.cvrisk.mboost`, `complexity.cvSGL.cox`

to aggregate prediction error: `aggregation.pmpec`, `aggregation.brier`,
`aggregation.misclass`

Function `peperr` is especially designed for evaluation of newly
developed model fitting routines. For that, own routines can be passed
as arguments to the `peperr` call. They are incorporated as follows
(also compare existing functions, as named above):

1.  Model fitting techniques, which require selection of one or more
    complexity parameters, often provide routines based on
    cross-validation or similar to determine this parameter. If this
    routine is already at hand, the complexity function needed for the
    `peperr` call is not more than a wrapper around that, which consists
    of providing the data in the required way, calling the routine and
    return the selected complexity value(s).

2.  For a given model fitting routine the fitting function, which is
    passed to the `peperr` call as argument `fit.fun`, is not more than
    a wrapper around that. Explicitly, response and matrix of covariates
    have to be transformed to the required form, if necessary, the
    routine is called with the passed complexity value, if required, and
    the fitted prediction model is returned.

3.  Prediction error is estimated using a fitted model and a data set,
    by any kind of comparison of the true and the predicted response
    values. In case of survival response, apparent error (type
    `apparent`), which means that the prediction error is estimated in
    the same data set as used for model fitting, and no-information
    error (type `noinf`), which calculates the prediction error in
    permuted data, have to be provided. Note that the aggregation
    function returns the error with an additional attribute called
    `addattr`. The evaluation time points have to be stored there to
    allow later access.

4.  In case of survival response, the user may additionally provide a
    function for partial log likelihood calculation, if he uses an own
    function for model fit, called `PLL.class`. If prediction error
    curves are used for aggregation (`aggregation.pmpec`), a predictProb
    method has to be provided, i.e. for each model of class `class`
    `predictProb.class`, see there.

Concerning parallelisation, there are three possibilities to run
`peperr`:

- Start R on commandline with sfCluster and preferred options, for
  example number of cpus. Leave the three arguments `parallel`,
  `clustertype` and `nodes` unchanged.

- Use any other cluster solution supported by snowfall, i.e. LAM/MPI,
  socket, PVM, NWS (set argument `clustertype`). Argument `parallel` has
  to be set to TRUE and number of cpus can be chosen by argument
  `nodes`)

- If no cluster is used, R works sequentially. Keep `parallel=NULL`. No
  parallelisation takes place and therefore no speed up can be obtained.

In general, if `parallel=NULL`, all information concerning the cluster
set-up is taken from commandline, else, it can be specified using the
three arguments `parallel`, `clustertype`, `nodes`, and, if necessary,
`clusterhosts`.

sfCluster is a Unix tool for flexible and comfortable managment of
parallel R processes. However, peperr is usable with any other cluster
solution supported by snowfall, i.e. sfCluster has not to be installed
to use package peperr. Note that this may require cluster handling by
the user, e.g. manually shut down with 'lamhalt' on commandline for
`type="MPI"`. But, using a socket cluster (argument `parallel=TRUE` and
`clustertype="SOCK"`), does not require any extra installation.

Note that the run time cannot speed up anymore if the number of nodes is
chosen higher than the number of passed training/test samples plus one,
as parallelisation takes place in the resampling procedure and one
additional run is used for computation on the full sample.

If not running in sequential mode, a specified number of R processes
called nodes is spawned for parallel execution of the resampling
procedure (see above). This requires to provide all variables, functions
and libraries necessary for computation on each of these R processes, so
explicitly all variables, functions and libraries required by the,
potentially user-defined, functions `fit.fun`, `complexity` and
`aggregation.fun`. The simplest possibility is to load the whole content
of the global environment on each node and all loaded libraries. This is
done by setting argument `load.all=TRUE`. This is not the default, as a
huge amount of data is potentially loaded to each node unnecessarily.
Function `extract.fun` is provided to extract the functions and
libraries needed, automatically called at each call of function
`peperr`. Note that all required libraries have to be located in the
standard library search path (obtained by
[`.libPaths()`](https://rdrr.io/r/base/libPaths.html)). Another
alternative is to load required data manually on the slaves, using
snowfall functions `sfLibrary`, `sfExport` and `sfExportAll`. Then,
argument `noclusterstart` has to be switched to TRUE. Additionally,
argument `load.list` could be set to NULL, to avoid potentially
overwriting of functions and variables loaded to the cluster nodes
automatically.

Note that a `set.seed` call before calling function `peperr` is not
sufficient to allow reproducibility of results when running in parallel
mode, as the slave R processes are not affected as they are own R
instances. `peperr` provides two possibilities to make results
reproducible:

- Use `RNG="RNGstream"` for independent parallel random number streams
  initialized on the cluster nodes via `sfClusterSetupRNG` from package
  snowfall. This requires package rlecuyer. A seed can be specified
  using argument `seed`, else the default values are taken. A `set.seed`
  call on the master is required additionally and argument `lb=FALSE`,
  see below.

- `RNG="SPRNG"` is kept as a recognized legacy value so existing code
  fails with an informative message, but it is no longer supported
  because rsprng has been removed from CRAN.

- If `RNG="fixed"`, a seed has to be specified. This can be either an
  integer or a vector of length number of samples +2. In the second
  case, the first entry is used for the main R process, the next number
  of samples ones for each sample run (in parallel execution mode on
  slave R processes) and the last one for computation on full sample (as
  well on slave R process in parallel execution mode). Passing integer x
  is equivalent to passing vector `x+(0:(number of samples+1))`. This
  procedure allows reproducibility in any case, i.e. also if the number
  of parallel processes changes as well as in sequential execution.

Load balancing (argument `lb`) means, that a slave gets a new job
immediately after the previous is finished. This speeds up computation,
but may change the order of jobs. Due to that, results are only
reproducible, if `RNG="fixed"` is used.

## Value

Object of class `peperr`

- indices:

  list of resampling indices.

- complexity:

  passed complexity. If argument `complexity` not specified, 0.

- selected.complexity:

  selected complexity for the full data set, if `complexity` was passed
  as function. Else equal to value `complexity`.

- response:

  passed response.

- full.model.fit:

  List, one entry per complexity value. Fitted model of the full data
  set by passed `fit.fun`.

- full.apparent:

  full apparent error of the full data set. Matrix: One row per
  complexity value. In case of survival response, columns correspond to
  evaluation timepoints, which are returned in value `attribute`.

- noinf.error:

  No information error of the full data set, i. e. evaluation in
  permuted data. Matrix: One row per complexity value. Columns
  correspond to evaluation timepoints, which are returned in
  `attribute`.

- attribute:

  if response is survival: Evaluation time points. Passed in
  `args.aggregation` or automatically determined by aggregation
  function. Otherwise, if available, extra attribute returned by
  aggregation function, else `NULL`, see Details.

- sample.error:

  list. Each entry contains matrix of prediction error for one
  resampling test sample. One row per complexity value.

- sample.complexity:

  vector of complexity values. Equals value `complexity`, if complexity
  value was passed explicitly, otherwise by function `complexity`
  selected complexity value for each resampling sample. If argument
  `complexity` not specified, 0.

- sample.lipec:

  only, if response is survival. Lebesgue integrated prediction error
  curve for each sample. List with one entry per sample, each a matrix
  with one row per complexity value.

- sample.pll:

  only, if response is survival and PLL.class function available.
  Predictive partial log likelihood for each sample. List with one entry
  per sample, each a matrix with one row per complexity value.

- null.model.fit:

  only, if response is survival or binary. Fit of null model, i.e. fit
  without information of covariates. In case of survival response
  Kaplan-Meier, else logistic regression model.

- null.model:

  only, if response is survival or binary. Vector or scalar: Prediction
  error of the null model, in case of survival response at each
  evaluation time point.

- sample.null.model:

  list. Prediction error of the null model for one resampling test
  sample. Matrix, one row per complexity value.

## References

Binder, H. and Schumacher, M. (2008) Adapting prediction error estimates
for biased complexity selection in high-dimensional bootstrap samples.
Statistical Applications in Genetics and Molecular Biology, 7:1.

Porzelius, C., Binder, H., Schumacher, M. (2008) Parallelised prediction
error estimation for evaluation of high-dimensional models. Manuscript.

## Author

Christine Porzelius <cp@fdm.uni-freiburg.de>, Harald Binder

## See also

[`perr`](https://fbertran.github.io/peperr/reference/perr.md),
[`resample.indices`](https://fbertran.github.io/peperr/reference/resample.indices.md),
[`extract.fun`](https://fbertran.github.io/peperr/reference/extract.fun.md)

## Examples

``` r
# Generate survival data with 10 informative covariates
n <- 200
p <- 100
beta <- c(rep(1,10),rep(0,p-10))
x <- matrix(rnorm(n*p),n,p)
real.time <- -(log(runif(n)))/(10*exp(drop(x %*% beta)))
cens.time <- rexp(n,rate=1/10)
status <- ifelse(real.time <= cens.time,1,0)
time <- ifelse(real.time <= cens.time,real.time,cens.time)

if (FALSE) { # \dontrun{
# A: R runs sequential or R is started on commandline with desired options 
# (for example using sfCluster: sfCluster -i --cpus=5)
# Example A1:
# Obtain prediction error estimate fitting a Cox proportional hazards model
# using CoxBoost 
# through 10 bootstrap samples 
# with fixed complexity 50 and 75
# and aggregate using prediction error curves (default setting)

peperr.object1 <- peperr(response=Surv(time, status), x=x, 
   fit.fun=fit.CoxBoost, complexity=c(50, 75), 
   indices=resample.indices(n=length(time), method="sub632", sample.n=10))
peperr.object1

# Diagnostic plots
plot(peperr.object1)

# Extraction of prediction error curves (.632+ prediction error estimate), 
# blue line corresponds to complexity 50, 
# red one to complexity 75
plot(peperr.object1$attribute,
   perr(peperr.object1)[1,], type="l", col="blue",
   xlab="Evaluation time points", ylab="Prediction error")
lines(peperr.object1$attribute, 
   perr(peperr.object1)[2,], col="red")

# Example A2:
# As Example A1, but
# with complexity selected through a cross-validation procedure
# and extra argument 'penalty' passed to fit function and complexity function
peperr.object2 <- peperr(response=Surv(time, status), x=x, 
   fit.fun=fit.CoxBoost, args.fit=list(penalty=100),
   complexity=complexity.mincv.CoxBoost, args.complexity=list(penalty=100),
   indices=resample.indices(n=length(time), method="sub632", sample.n=10),
   trace=TRUE)
peperr.object2

# Diagnostic plots
plot(peperr.object2)

# Example A3:
# As Example A2, but
# with extra argument 'times', specifying the evaluation times passed to aggregation.fun
# and seed, for reproducibility of results
# Note: set.seed() is required additional to argument 'seed', 
# as function 'resample.indices' is used in peperr call.
set.seed(123)
peperr.object3 <- peperr(response=Surv(time, status), x=x, 
   fit.fun=fit.CoxBoost, args.fit=list(penalty=100),
   complexity=complexity.mincv.CoxBoost, args.complexity=list(penalty=100),
   indices=resample.indices(n=length(time), method="sub632", sample.n=10),
   args.aggregation=list(times=seq(0, quantile(time, probs=0.9), length.out=100)),
   trace=TRUE, RNG="fixed", seed=321)
peperr.object3

# Diagnostic plots
plot(peperr.object3)

# B: R is started sequential, desired cluster options are given as arguments
# Example B1:
# As example A1, but using a socket cluster and 3 CPUs
peperr.object4 <- peperr(response=Surv(time, status), x=x, 
   fit.fun=fit.CoxBoost, complexity=c(50, 75), 
   indices=resample.indices(n=length(time), method="sub632", sample.n=10),
   parallel=TRUE, clustertype="SOCK", cpus=3)
} # }
```
