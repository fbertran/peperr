\name{fit.glmnet}
\alias{fit.glmnet}
\alias{complexity.cv.glmnet}
\alias{predictProb.coxnet}
\alias{PLL.coxnet}
\title{glmnet Cox backend}
\description{
Wrappers that integrate \pkg{glmnet} Cox models into the \code{peperr} fit/complexity/prediction interface.
}
\usage{
fit.glmnet(response, x, cplx, ...)
complexity.cv.glmnet(response, x, full.data, ...)
\method{predictProb}{coxnet}(object, response, x, times, complexity = NULL, ...)
\method{PLL}{coxnet}(object, newdata, newtime, newstatus, complexity = NULL, ...)
}
\arguments{
  \item{response}{survival response as a \code{Surv} object or a two-column \code{time}/\code{status} matrix.}
  \item{x}{covariate matrix.}
  \item{cplx}{selected \code{lambda} value for \code{glmnet}.}
  \item{full.data}{full data frame, accepted for the \code{peperr} complexity-function contract.}
  \item{object}{a fitted \code{coxnet} object.}
  \item{times}{evaluation times for survival probabilities.}
  \item{complexity}{selected \code{lambda} value.}
  \item{newdata}{new covariate matrix.}
  \item{newtime}{vector of follow-up times.}
  \item{newstatus}{vector of event indicators.}
  \item{\dots}{additional arguments passed to \code{\link[glmnet]{glmnet}}, \code{\link[glmnet]{cv.glmnet}}, \code{survfit.coxnet}, or \code{predict}.}
}
\value{
\code{fit.glmnet} returns a fitted \code{coxnet} object. \code{complexity.cv.glmnet} returns a scalar \code{lambda}. \code{predictProb.coxnet} returns an \code{n * length(times)} survival-probability matrix. \code{PLL.coxnet} returns a numeric predictive partial log-likelihood.
}
\details{
The backend stores the training design matrix and survival outcome on the fitted object so that the \code{survfit.coxnet} method can be reused later when \code{pmpec} calls \code{predictProb}.
}
\seealso{
\code{\link{peperr}}, \code{\link{predictProb}}, \code{\link{PLL}}, \code{\link[glmnet]{glmnet}}, \code{\link[glmnet]{cv.glmnet}}
}
\keyword{models} \keyword{regression} \keyword{survival}
