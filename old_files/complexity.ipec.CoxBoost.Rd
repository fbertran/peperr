\name{complexity.ipec.CoxBoost}
\alias{complexity.ipec.CoxBoost}
\alias{complexity.ripec.CoxBoost}
\title{Interface function for complexity selection for CoxBoost via integrated prediction error curve and the bootstrap}
\description{
Determines the number of boosting steps for a survival model fitted by CoxBoost via integrated prediction error curve (IPEC) estimates, conforming to the calling convention required by argument \code{complexity} in \code{peperr} call. 
}
\usage{
complexity.ipec.CoxBoost(response, x, boot.n.c = 10, boost.steps = 100, 
   eval.times = NULL, smooth = FALSE, full.data, ...)

complexity.ripec.CoxBoost(response, x, boot.n.c = 10, boost.steps = 100, 
   eval.times = NULL, smooth = FALSE, full.data, ...)
}
\arguments{
  \item{response}{a survival object (with \code{Surv(time, status)}).}
  \item{x}{\code{n*p} matrix of covariates.}
  \item{boot.n.c}{number of bootstrap samples.}
  \item{boost.steps}{maximum number of boosting steps, i.e. number of boosting steps is selected out of interval (1, boost.steps).}
  \item{eval.times}{vector of evaluation time points.}
  \item{smooth}{logical. Shall prediction error curve be smoothed by local polynomial regression before integration?}
  \item{full.data}{Data frame containing response and covariates of the full data set.}
  \item{\dots}{additional arguments passed to \code{CoxBoost} call.}
}
\value{
Scalar value giving the number of boosting steps.
}
\details{
Plotting the .632+ estimator for each time point given in \code{eval.times} results in a prediction error curve. A summary measure can be obtained by integrating over time. \code{complexity.ripec.CoxBoost} computes a Riemann integral, while \code{complexity.ipec.CoxBoost} uses a Lebesgue-like integral taking Kaplan-Meier estimates as weights. The number of boosting steps of the interval (0, \code{boost.steps}), for which the minimal IPEC is obtained, is returned.
}
\seealso{ \code{peperr}, \code{\link[CoxBoost]{CoxBoost}} }
\keyword{models} \keyword{regression} \keyword{survival}
