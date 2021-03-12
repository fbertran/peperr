\name{aggregation.pmpec}
\alias{aggregation.pmpec}
\title{Determine the prediction error curve for a fitted model}
\description{
Interface to \code{pmpec}, for conforming to the structure required by the argument \code{aggregation.fun} in \code{peperr} call. Evaluates the prediction error curve, i.e. the Brier score tracked over time, for a fitted survival model.
}
\usage{
aggregation.pmpec(full.data, response, x, model, cplx=NULL, times = NULL, 
   type=c("apparent", "noinf"), fullsample.attr = NULL, ...)
}
\arguments{
\item{full.data}{data frame with full data set.}
\item{response}{Either a survival object (with \code{Surv(time, status)}, where time is an \code{n}-vector of censored survival times and status an \code{n}-vector containing event status, coded with 0 and 1) or a matrix with columns \code{time} containing survival times and \code{status} containing integers, where 0 indicates censoring, 1 the interesting event and larger numbers other competing risks.}
\item{x}{\code{n*p} matrix of covariates.}
\item{model}{survival model as returned by \code{fit.fun} as used in call to \code{peperr}.}
\item{cplx}{numeric, number of boosting steps or list, containing number of boosting steps in argument \code{stepno}.}
\item{times}{vector of evaluation time points. If given, used as well as in calculation of full apparent and no-information error as in resampling procedure. Not used if \code{fullsample.attr} is specified.}
\item{type}{character.}
\item{fullsample.attr}{vector of evaluation time points, passed in resampling procedure. Either user-defined, if \code{times} were passed as \code{args.aggregation}, or the determined time points from the \code{aggregation.fun} call with the full data set.}
\item{\dots}{additional arguments passed to \code{pmpec} call.}
}
\details{
If no evaluation time points are passed, they are generated using all uncensored time points if their number is smaller than 100, or 100 time points up to the 95\% quantile of the uncensored time points are taken.

\code{pmpec} requires a \code{predictProb} method for the class of the fitted model, i.e. for a model of class \code{class} \code{predictProb.class}. 
}
\value{
A matrix with one row. Each column represents the estimated prediction error of the fit at the time points.
}
\seealso{\code{peperr}, \code{predictProb}, \code{pmpec}}
\keyword{models} \keyword{regression} \keyword{survival}