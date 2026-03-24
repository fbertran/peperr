\name{fit.grpsurv}
\alias{fit.grpsurv}
\alias{complexity.cv.grpsurv}
\alias{predictProb.grpsurv}
\alias{PLL.grpsurv}
\title{grpreg grouped Cox backend}
\description{
Wrappers for grouped survival models fitted with \pkg{grpreg}.
}
\usage{
fit.grpsurv(response, x, cplx, group, ...)
complexity.cv.grpsurv(response, x, full.data, group, ...)
\method{predictProb}{grpsurv}(object, response, x, times, complexity = NULL, ...)
\method{PLL}{grpsurv}(object, newdata, newtime, newstatus, complexity = NULL, ...)
}
\arguments{
  \item{response}{survival response as a \code{Surv} object or a two-column \code{time}/\code{status} matrix.}
  \item{x}{covariate matrix.}
  \item{cplx}{selected \code{lambda} value.}
  \item{group}{group membership vector for the columns of \code{x}.}
  \item{full.data}{full data frame, accepted for the \code{peperr} complexity-function contract.}
  \item{object}{a fitted \code{grpsurv} object.}
  \item{times}{evaluation times for survival probabilities.}
  \item{complexity}{selected \code{lambda} value.}
  \item{newdata}{new covariate matrix.}
  \item{newtime}{vector of follow-up times.}
  \item{newstatus}{vector of event indicators.}
  \item{\dots}{additional arguments passed to \code{\link[grpreg]{grpsurv}}, \code{\link[grpreg]{cv.grpreg}}, or \code{predict}.}
}
\value{
Fitted \code{grpsurv} objects, scalar \code{lambda} values, survival-probability matrices, and numeric predictive partial log-likelihood values, respectively.
}
\details{
The grouped backend exposes grouped lasso, grouped MCP, grouped SCAD, and related penalties through the native \pkg{grpreg} arguments passed in \code{\dots}.
}
\seealso{
\code{\link{peperr}}, \code{\link[grpreg]{grpsurv}}, \code{\link[grpreg]{cv.grpreg}}
}
\keyword{models} \keyword{regression} \keyword{survival}
