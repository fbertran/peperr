\name{fit.SGL.cox}
\alias{fit.SGL.cox}
\alias{complexity.cvSGL.cox}
\alias{predictProb.SGL_cox}
\alias{PLL.SGL_cox}
\title{Sparse-group-lasso Cox backend}
\description{
Wrappers for Cox models fitted with \pkg{SGL}.
}
\usage{
fit.SGL.cox(response, x, cplx, index, ...)
complexity.cvSGL.cox(response, x, full.data, index, ...)
\method{predictProb}{SGL_cox}(object, response, x, times, complexity = NULL, ...)
\method{PLL}{SGL_cox}(object, newdata, newtime, newstatus, complexity = NULL, ...)
}
\arguments{
  \item{response}{survival response as a \code{Surv} object or a two-column \code{time}/\code{status} matrix.}
  \item{x}{covariate matrix.}
  \item{cplx}{selected \code{lambda} value.}
  \item{index}{group membership vector for the columns of \code{x}.}
  \item{full.data}{full data frame, accepted for the \code{peperr} complexity-function contract.}
  \item{object}{a fitted \code{SGL_cox} object.}
  \item{times}{evaluation times for survival probabilities.}
  \item{complexity}{selected \code{lambda} value.}
  \item{newdata}{new covariate matrix.}
  \item{newtime}{vector of follow-up times.}
  \item{newstatus}{vector of event indicators.}
  \item{\dots}{additional arguments passed to \code{\link[SGL]{SGL}} or \code{\link[SGL]{cvSGL}}.}
}
\value{
Fitted \code{SGL_cox} objects, selected \code{lambda} values, survival-probability matrices, and numeric predictive partial log-likelihood values, respectively.
}
\details{
The \pkg{SGL} predictor returns relative risks. The \code{peperr} wrapper reconstructs survival probabilities from those risks with a Breslow baseline estimated on the stored training data.
}
\seealso{
\code{\link{peperr}}, \code{\link[SGL]{SGL}}, \code{\link[SGL]{cvSGL}}
}
\keyword{models} \keyword{regression} \keyword{survival}
