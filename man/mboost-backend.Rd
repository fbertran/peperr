\name{fit.mboost.coxph}
\alias{fit.mboost.coxph}
\alias{complexity.cvrisk.mboost}
\alias{predictProb.mboost_coxph}
\alias{PLL.mboost_coxph}
\title{mboost Cox backend}
\description{
Wrappers for Cox boosting models fitted with \pkg{mboost}.
}
\usage{
fit.mboost.coxph(response, x, cplx, ...)
complexity.cvrisk.mboost(response, x, full.data, max.mstop = 100L, folds = NULL, ...)
\method{predictProb}{mboost_coxph}(object, response, x, times, complexity = NULL, ...)
\method{PLL}{mboost_coxph}(object, newdata, newtime, newstatus, complexity = NULL, ...)
}
\arguments{
  \item{response}{survival response as a \code{Surv} object or a two-column \code{time}/\code{status} matrix.}
  \item{x}{covariate matrix.}
  \item{cplx}{selected stopping iteration \code{mstop}.}
  \item{full.data}{full data frame, accepted for the \code{peperr} complexity-function contract.}
  \item{max.mstop}{maximum number of boosting iterations considered during cross-validation.}
  \item{folds}{optional \pkg{mboost} fold specification passed to \code{cvrisk}.}
  \item{object}{a fitted \code{mboost_coxph} object.}
  \item{times}{evaluation times for survival probabilities.}
  \item{complexity}{selected stopping iteration.}
  \item{newdata}{new covariate matrix.}
  \item{newtime}{vector of follow-up times.}
  \item{newstatus}{vector of event indicators.}
  \item{\dots}{additional arguments passed to \code{\link[mboost]{glmboost}}, \code{\link[mboost]{cvrisk}}, or prediction helpers.}
}
\value{
Fitted \code{mboost_coxph} objects, selected stopping iterations, survival-probability matrices, and numeric predictive partial log-likelihood values, respectively.
}
\details{
If \pkg{mboost} provides native survival-curve predictions for the fitted model, \code{predictProb.mboost_coxph} uses them. Otherwise it falls back to a Breslow baseline estimated from the stored training data and linear predictors.
}
\seealso{
\code{\link{peperr}}, \code{\link[mboost]{glmboost}}, \code{\link[mboost]{cvrisk}}
}
\keyword{models} \keyword{regression} \keyword{survival}
