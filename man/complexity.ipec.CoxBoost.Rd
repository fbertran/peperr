\name{complexity.ipec.CoxBoost}
\alias{complexity.ipec.CoxBoost}
\alias{complexity.ripec.CoxBoost}
\title{Interface function for CoxBoost complexity selection via integrated prediction error curves}
\description{
Determines the number of boosting steps for a survival model fitted by \code{CoxBoost} via integrated prediction error curve estimates, conforming to the calling convention required by argument \code{complexity} in \code{peperr} call.
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
  \item{boost.steps}{maximum number of boosting steps, i.e. number of boosting steps is selected out of the interval \code{[1, boost.steps]}.}
  \item{eval.times}{vector of evaluation time points.}
  \item{smooth}{logical. Shall the prediction error curve be smoothed by local polynomial regression before integration?}
  \item{full.data}{data frame containing response and covariates of the full data set.}
  \item{\dots}{additional arguments passed to \code{CoxBoost} call.}
}
\value{
Scalar value giving the number of boosting steps.
}
\details{
Plotting the .632+ estimator for each time point given in \code{eval.times} results in a prediction error curve. A summary measure can be obtained by integrating over time. \code{complexity.ripec.CoxBoost} computes a Riemann integral, while \code{complexity.ipec.CoxBoost} uses a Lebesgue-like integral taking Kaplan-Meier estimates as weights. The number of boosting steps for which the minimal integrated error is obtained is returned.

Since \pkg{CoxBoost} is only suggested by \pkg{peperr}, install it before calling these functions. If \code{smooth = TRUE}, \pkg{locfit} is also required.
}
\seealso{ \code{peperr}, \code{\link[CoxBoost]{CoxBoost}} }
\keyword{models} \keyword{regression} \keyword{survival}
