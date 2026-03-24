\name{fit.ncvsurv}
\alias{fit.ncvsurv}
\alias{complexity.cv.ncvsurv}
\alias{predictProb.ncvsurv}
\alias{PLL.ncvsurv}
\title{ncvreg survival backend}
\description{
Wrappers for Cox models fitted with \pkg{ncvreg}.
}
\usage{
fit.ncvsurv(response, x, cplx, ...)
complexity.cv.ncvsurv(response, x, full.data, ...)
\method{predictProb}{ncvsurv}(object, response, x, times, complexity = NULL, ...)
\method{PLL}{ncvsurv}(object, newdata, newtime, newstatus, complexity = NULL, ...)
}
\arguments{
  \item{response}{survival response as a \code{Surv} object or a two-column \code{time}/\code{status} matrix.}
  \item{x}{covariate matrix.}
  \item{cplx}{selected \code{lambda} value.}
  \item{full.data}{full data frame, accepted for the \code{peperr} complexity-function contract.}
  \item{object}{a fitted \code{ncvsurv} object.}
  \item{times}{evaluation times for survival probabilities.}
  \item{complexity}{selected \code{lambda} value.}
  \item{newdata}{new covariate matrix.}
  \item{newtime}{vector of follow-up times.}
  \item{newstatus}{vector of event indicators.}
  \item{\dots}{additional arguments passed to \code{ncvsurv}, \code{cv.ncvsurv}, or \code{predict}.}
}
\value{
Fitted \code{ncvsurv} objects, selected \code{lambda} values, survival-probability matrices, and numeric predictive partial log-likelihood values, respectively.
}
\details{
The implementation first tries the native \pkg{ncvreg} survival prediction method. If that is unavailable for the installed version, it falls back to a Breslow baseline built from stored training data and linear predictors.
}
\seealso{
\code{\link{peperr}}, \code{\link{predictProb}}, \code{\link{PLL}}
}
\keyword{models} \keyword{regression} \keyword{survival}
