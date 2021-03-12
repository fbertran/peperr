\name{complexity.mincv.CoxBoost}
\alias{complexity.mincv.CoxBoost}
\title{Interface for CoxBoost selection of optimal number of boosting steps via cross-validation}
\description{
Determines the number of boosting steps for a survival model fitted by CoxBoost via cross-validation, conforming to the calling convention required by argument \code{complexity} in \code{peperr} call. 
}
\usage{
complexity.mincv.CoxBoost(response, x, full.data, ...)
}
\arguments{
  \item{response}{a survival object (\code{Surv(time, status)}).}
  \item{x}{\code{n*p} matrix of covariates.}
  \item{full.data}{data frame containing response and covariates of the full data set.}
  \item{\dots}{additional arguments passed to \code{cv.CoxBoost} call.}
  }
\value{
Scalar value giving the optimal number of boosting steps.
}
\details{
Function is basically a wrapper around \code{cv.CoxBoost} of package \code{CoxBoost}. A K-fold cross-validation (default K=10) is performed to search the optimal number of boosting steps, per default in the interval (0, \code{maxstepno}=100). The number of boosting steps with minimum mean partial log-likelihood is returned. Calling \code{peperr}, the default arguments of \code{cv.CoxBoost} can be changed by passing a named list containing these as argument \code{args.complexity}.
}
\seealso{\code{peperr}, \code{\link[CoxBoost]{cv.CoxBoost}}}
\keyword{models} \keyword{regression} \keyword{survival}
