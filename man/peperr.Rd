\name{peperr}
\alias{peperr}
\title{Parallelised Estimation of Prediction Error}
\description{
Prediction error estimation for regression models via resampling techniques. Potentially parallelised, if compute cluster is available. 
}
\usage{
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
}
\arguments{
\item{response}{Either a survival object (with \code{Surv(time, status)}, where time is an \code{n}-vector of censored survival times and status an \code{n}-vector containing event status, coded with 0 and 1) or a matrix with columns \code{time} containing survival times and \code{status} containing integers, where 0 indicates censoring, 1 the interesting event and larger numbers other competing risks. In case of binary response, vector with entries 0 and 1.}
\item{x}{\code{n*p} matrix of covariates.}
\item{indices}{named list, with two elements (both expected to be lists) \code{sample.index}, containing the vector of indices of observations used to fit the model, and list \code{not.in.sample}, containing the vector of indices of observations used for assessment. One list entry per split.
Function \code{resample.indices} provides the most common resampling methods. If argument \code{indices} is not specified (default), the indices are determined as follows: If number of observations in the passed data matrix is smaller than number of covariates, 500 bootstrap samples without replacement are generated ("subsampling"), else 500 bootstrap samples with replacement.}
\item{fit.fun}{function returning a fitted model, see Details.}
\item{complexity}{if the choice of a complexity parameter is necessary, for example the number of boosting steps in boosting techniques, a function returning complexity parameter for model fitted with fit.fun, see Details. Alternatively, one explicit value for the complexity or a vector of values can be passed. In the latter case, the model fit is carried out for each of the complexity parameters. Alternatively, a named list can be passed, if complexity is a tuple of different parameter values.}
\item{args.fit}{named list of arguments to be passed to the function given in \code{fit.fun}.}
\item{args.complexity}{if \code{complexity} is a function, a named list of arguments to be passed to this function.}
\item{parallel}{the default setting corresponds to the case that sfCluster is used or if R runs sequential, i.e. without any parallelisation. If sfCluster is used, settings from sfCluster commandline call are taken, i.e. the required number of nodes has to be specified as option of the sfCluster call (and not using argument \code{cpus}). 
If another cluster solution (specified by argument \code{clustertype}) shall be used, a cluster with \code{cpus} CPUs is started if \code{parallel=TRUE}. \code{parallel=FALSE} switches back to sequential execution. See Details.}
\item{cpus}{number of nodes, i.e., number of parallel running R processes, to be set up in a cluster, if not specified by commandline call. Only needed if \code{parallel=TRUE}.}
\item{clustertype}{type of cluster, character. 'SOCK' for socket cluster, 'MPI', 'PVM' or 'NWS'. Only considered if \code{parallel=TRUE}. If so, a socket cluster, which does not require any additional installation, is started as default.}
\item{clusterhosts}{host list for socket and NWS clusters, if \code{parallel=TRUE}. Has to be specified only if using more than one machine.}
\item{noclusterstart}{if function is used in already parallelised code. If set to TRUE, no cluster is initialised even if a compute cluster is available and function works in sequential mode. Additionally usable if calls on the slaves should be executed before calling function \code{peperr}, for example to load data on slaves, see Details.} 
\item{noclusterstop}{if TRUE, cluster stop is suppressed. Useful for debugging of sessions on slaves. Note that the next \code{peperr} call forces cluster stop, except if called with \code{noclusterstart=TRUE}.}
\item{aggregation.fun}{function that evaluates the prediction error for a model fitted by the function given in \code{fit.fun}, see Details. If not specified, function \code{aggregation.pmpec} is taken if response is survival object, in case of binary response function \code{aggregation.brier}.}
\item{args.aggregation}{named list of arguments to be passed to the function given in argument \code{aggregation.fun}.}
\item{load.list}{a named list with element \code{packages}, \code{functions} and \code{variables} containing quoted names of libraries, functions and global variables required for computation on cluster nodes. The default extracts automatically the libraries, functions and global variables of the, potentially user-defined, functions \code{fit.fun}, \code{complexity} and \code{aggregation.fun}, see function \code{extract.fun}. Can be set to NULL, e.g. if no libraries, functions and variables are needed. Alternatively, use argument \code{load.all}. See Details.}
\item{load.vars}{a named list with global variables required for computation on cluster nodes. See Details. Relict, global variabels can now be passed as list element \code{variables} of argument \code{load.list}.}
\item{load.all}{logical. If set to TRUE, all variables, functions and libraries of the current global environment are loaded on cluster nodes. See Details.}
\item{trace}{logical. If TRUE, output about the current execution step is printed (if running parallel: printed on nodes, that means not visible in master R process, see Details).}
\item{debug}{if TRUE, information concerning export of variables is given.}
\item{peperr.lib.loc}{location of package \pkg{peperr} if not in standard library search path (\code{.libPaths()}), to be specified for loading \pkg{peperr} onto the cluster nodes.}
\item{RNG}{type of RNG. \code{"fixed"} requires a specified \code{seed}. \code{"RNGstream"} and \code{"SPRNG"} use default seeds, if not specified. See Details.}
\item{seed}{seed to allow reproducibility of results. Only considered if argument \code{RNG} is not \code{"none"}. See Details.}
\item{lb}{if TRUE and a compute cluster is used, computation of slaves is executed load balanced. See Details.}
\item{sr}{if TRUE, intermediate results are saved. If execution is interrupted, they can be restored by setting argument sr.restore to TRUE. See documentation of package \pkg{snowfall} for details}
\item{sr.name}{if \code{sr} is set to TRUE and more than one computation runs simultaneously, unique names need to be used.}
\item{sr.restore}{if \code{sr} is set to TRUE, an interrupted computation is restarted.}
}
\details{
Validation of new model fitting approaches requires the proper use of resampling techniques for prediction error estimation. Especially in high-dimensional data situations the computational demand might be huge. \code{peperr} accelerates computation through automatically parallelisation of the resampling procedure, if a compute cluster is available. A noticeable speed-up is reached even when using a dual-core processor.

Resampling based prediction error estimation requires for each split in training and test data the following steps: a) selection of model complexity (if desired), using the training data set, b) fitting the model with the selected (or a given) complexity on the training set and c) measurement of prediction error on the corresponding test set.

Functions for fitting the model, determination of model complexity, if required by the fitting procedure, and aggregating the prediction error are passed as arguments \code{fit.fun}, \code{complexity} and \code{aggregation.fun}. Already available functions are 

for model fit:
\code{fit.CoxBoost}, \code{fit.coxph}, \code{fit.LASSO}, \code{fit.rsf_mtry}

to determine complexity:
\code{complexity.mincv.CoxBoost}, \code{complexity.ipec.CoxBoost}, \code{complexity.LASSO}, \code{complexity.ipec.rsf_mtry}

to aggregate prediction error:
\code{aggregation.pmpec}, \code{aggregation.brier}, \code{aggregation.misclass}

Function \code{peperr} is especially designed for evaluation of newly developed model fitting routines. For that, own routines can be passed as arguments to the \code{peperr} call. They are incorporated as follows (also compare existing functions, as named above):

\enumerate{
\item Model fitting techniques, which require selection of one or more complexity parameters, often provide routines based on cross-validation or similar to determine this parameter. If this routine is already at hand, the complexity function needed for the \code{peperr} call is not more than a wrapper around that, which consists of providing the data in the required way, calling the routine and return the selected complexity value(s). 

\item For a given model fitting routine the fitting function, which is passed to the \code{peperr} call as argument \code{fit.fun}, is not more than a wrapper around that. Explicitly, response and matrix of covariates have to be transformed to the required form, if necessary, the routine is called with the passed complexity value, if required, and the fitted prediction model is returned. 

\item Prediction error is estimated using a fitted model and a data set, by any kind of comparison of the true and the predicted response values. In case of survival response, apparent error (type \code{apparent}), which means that the prediction error is estimated in the same data set as used for model fitting, and no-information error (type \code{noinf}), which calculates the prediction error in permuted data, have to be provided. Note that the aggregation function returns the error with an additional attribute called \code{addattr}. The evaluation time points have to be stored there to allow later access.  

\item In case of survival response, the user may additionally provide a function for partial log likelihood calculation, if he uses an own function for model fit, called \code{PLL.class}. If prediction error curves are used for aggregation (\code{aggregation.pmpec}), a predictProb method has to be provided, i.e. for each model of class \code{class} \code{predictProb.class}, see there. 
}

Concerning parallelisation, there are three possibilities to run \code{peperr}:

\itemize{
\item Start R on commandline with sfCluster and preferred options, for example number of cpus. Leave the three arguments \code{parallel}, \code{clustertype} and \code{nodes} unchanged.
\item Use any other cluster solution supported by \pkg{snowfall}, i.e. LAM/MPI, socket, PVM, NWS (set argument \code{clustertype}). Argument \code{parallel} has to be set to TRUE and number of cpus can be chosen by argument \code{nodes}) 
\item If no cluster is used, R works sequentially. Keep \code{parallel=NULL}. No parallelisation takes place and therefore no speed up can be obtained.
} 

In general, if \code{parallel=NULL}, all information concerning the cluster set-up is taken from commandline, else, it can be specified using the three arguments \code{parallel}, \code{clustertype}, \code{nodes}, and, if necessary, \code{clusterhosts}. 

sfCluster is a Unix tool for flexible and comfortable managment of parallel R processes. However, \pkg{peperr} is usable with any other cluster solution supported by \pkg{snowfall}, i.e. sfCluster has not to be installed to use package \pkg{peperr}. Note that this may require cluster handling by the user, e.g. manually shut down with 'lamhalt' on commandline for \code{type="MPI"}. But, using a socket cluster (argument \code{parallel=TRUE} and \code{clustertype="SOCK"}), does not require any extra installation. 

Note that the run time cannot speed up anymore if the number of nodes is chosen higher than the number of passed training/test samples plus one, as parallelisation takes place in the resampling procedure and one additional run is used for computation on the full sample.

If not running in sequential mode, a specified number of R processes called nodes is spawned for parallel execution of the resampling procedure (see above). This requires to provide all variables, functions and libraries necessary for computation on each of these R processes, so explicitly all variables, functions and libraries required by the, potentially user-defined, functions \code{fit.fun}, \code{complexity} and \code{aggregation.fun}. The simplest possibility is to load the whole content of the global environment on each node and all loaded libraries. This is done by setting argument \code{load.all=TRUE}. This is not the default, as a huge amount of data is potentially loaded to each node unnecessarily. Function \code{extract.fun} is provided to extract the functions and libraries needed, automatically called at each call of function \code{peperr}. Note that all required libraries have to be located in the standard library search path (obtained by \code{.libPaths()}). Another alternative is to load required data manually on the slaves, using \pkg{snowfall} functions \code{sfLibrary}, \code{sfExport} and \code{sfExportAll}. Then, argument \code{noclusterstart} has to be switched to TRUE. Additionally, argument \code{load.list} could be set to NULL, to avoid potentially overwriting of functions and variables loaded to the cluster nodes automatically.

Note that a \code{set.seed} call before calling function \code{peperr} is not sufficient to allow reproducibility of results when running in parallel mode, as the slave R processes are not affected as they are own R instances. \code{peperr} provides two possibilities to make results reproducible: 
\itemize{
\item Use \code{RNG="RNGstream"} or \code{RNG="SPRNG"}. Independent parallel random number streams are initialized on the cluster nodes, using function \code{sfClusterSetupRNG} of package \pkg{snowfall}. A seed can be specified using argument \code{seed}, else the default values are taken. A \code{set.seed} call on the master is required additionally and argument \code{lb=FALSE}, see below.
\item If \code{RNG="fixed"}, a seed has to be specified. This can be either an integer or a vector of length number of samples +2.  In the second case, the first entry is used for the main R process, the next number of samples ones for each sample run (in parallel execution mode on slave R processes) and the last one for computation on full sample (as well on slave R process in parallel execution mode). Passing integer x is equivalent to passing vector \code{x+(0:(number of samples+1))}. This procedure allows reproducibility in any case, i.e. also if the number of parallel processes changes as well as in sequential execution.
} 

Load balancing (argument \code{lb}) means, that a slave gets a new job immediately after the previous is finished. This speeds up computation, but may change the order of jobs. Due to that, results are only reproducible, if \code{RNG="fixed"} is used.
}

\value{
Object of class \code{peperr}
\item{indices}{list of resampling indices.}
\item{complexity}{passed complexity. If argument \code{complexity} not specified, 0.}
\item{selected.complexity}{selected complexity for the full data set, if \code{complexity} was passed as function. Else equal to value \code{complexity}.}
\item{response}{passed response.}
\item{full.model.fit}{List, one entry per complexity value. Fitted model of the full data set by passed \code{fit.fun}.}
\item{full.apparent}{full apparent error of the full data set. Matrix: One row per complexity value. In case of survival response, columns correspond to evaluation timepoints, which are returned in value \code{attribute}.}
\item{noinf.error}{No information error of the full data set, i. e. evaluation in permuted data. Matrix: One row per complexity value. Columns correspond to evaluation timepoints, which are returned in \code{attribute}.}
\item{attribute}{if response is survival: Evaluation time points. Passed in \code{args.aggregation} or automatically determined by aggregation function. Otherwise, if available, extra attribute returned by aggregation function, else \code{NULL}, see Details.}
\item{sample.error}{list. Each entry contains matrix of prediction error for one resampling test sample. One row per complexity value.}
\item{sample.complexity}{vector of complexity values. Equals value \code{complexity}, if complexity value was passed explicitly, otherwise by function \code{complexity} selected complexity value for each resampling sample. If argument \code{complexity} not specified, 0.}
\item{sample.lipec}{only, if response is survival. Lebesgue integrated prediction error curve for each sample. List with one entry per sample, each a matrix with one row per complexity value.}
\item{sample.pll}{only, if response is survival and PLL.class function available. Predictive partial log likelihood for each sample. List with one entry per sample, each a matrix with one row per complexity value.}
\item{null.model.fit}{only, if response is survival or binary. Fit of null model, i.e. fit without information of covariates. In case of survival response Kaplan-Meier, else logistic regression model.}
\item{null.model}{only, if response is survival or binary. Vector or scalar: Prediction error of the null model, in case of survival response at each evaluation time point.}
\item{sample.null.model}{list. Prediction error of the null model for one resampling test sample. Matrix, one row per complexity value.}
}

\references{
Binder, H. and Schumacher, M. (2008) Adapting prediction error estimates for biased complexity selection in high-dimensional bootstrap samples. Statistical Applications in Genetics and Molecular Biology, 7:1.

Porzelius, C., Binder, H., Schumacher, M. (2008) Parallelised prediction error estimation for evaluation of high-dimensional models. Manuscript.
}

\author{Christine Porzelius \email{cp@fdm.uni-freiburg.de}, Harald Binder}

\seealso{\code{\link{perr}}, \code{\link{resample.indices}}, \code{\link{extract.fun}}}

\examples{
# Generate survival data with 10 informative covariates 
\dontrun{
n <- 200
p <- 100
beta <- c(rep(1,10),rep(0,p-10))
x <- matrix(rnorm(n*p),n,p)
real.time <- -(log(runif(n)))/(10*exp(drop(x %*% beta)))
cens.time <- rexp(n,rate=1/10)
status <- ifelse(real.time <= cens.time,1,0)
time <- ifelse(real.time <= cens.time,real.time,cens.time)

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
}
}
\keyword{models} \keyword{regression} \keyword{survival}
