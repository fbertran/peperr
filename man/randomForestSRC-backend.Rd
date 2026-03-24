\name{fit.rfsrc}
\alias{fit.rfsrc}
\alias{complexity.oob.rfsrc}
\alias{predictProb.rfsrc}
\title{randomForestSRC survival backend}
\description{
Wrappers for random survival forests fitted with \pkg{randomForestSRC}.
}
\usage{
fit.rfsrc(response, x, cplx, ...)
complexity.oob.rfsrc(response, x, full.data,
    mtry = unique(pmax(1L, c(floor(sqrt(ncol(x))), floor(ncol(x)/3), ncol(x)))),
    nodesize = c(5L, 15L), ntree = 200L, ...)
\method{predictProb}{rfsrc}(object, response, x, times, complexity = NULL, ...)
}
\arguments{
  \item{response}{survival response as a \code{Surv} object or a two-column \code{time}/\code{status} matrix.}
  \item{x}{covariate matrix.}
  \item{cplx}{either a selected \code{mtry} value or a named list such as \code{list(mtry = ..., nodesize = ...)}.}
  \item{full.data}{full data frame, accepted for the \code{peperr} complexity-function contract.}
  \item{mtry}{candidate \code{mtry} values for OOB tuning.}
  \item{nodesize}{candidate terminal-node sizes for OOB tuning.}
  \item{ntree}{number of trees used during OOB tuning.}
  \item{object}{a fitted \code{rfsrc} object.}
  \item{times}{evaluation times for survival probabilities.}
  \item{complexity}{unused for fitted forests; included for interface compatibility.}
  \item{\dots}{additional arguments passed to \code{\link[randomForestSRC]{rfsrc}} or \code{\link[randomForestSRC]{predict.rfsrc}}.}
}
\value{
Fitted \code{rfsrc} objects, tuning lists containing \code{mtry} and \code{nodesize}, and survival-probability matrices.
}
\details{
No \code{PLL.rfsrc} method is provided, because random survival forests do not naturally expose a Cox-style partial likelihood. They can still be used with \code{pmpec} through \code{predictProb.rfsrc}.
}
\seealso{
\code{\link{peperr}}, \code{\link[randomForestSRC]{rfsrc}}, \code{\link[randomForestSRC]{predict.rfsrc}}
}
\keyword{models} \keyword{regression} \keyword{survival}
