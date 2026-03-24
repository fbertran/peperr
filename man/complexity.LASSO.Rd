\name{complexity.cv.penalized}
\alias{complexity.cv.penalized}
\alias{complexity.LASSO}
\alias{complexity.fusedLASSO}
\title{Complexity selection helpers for penalized backends}
\description{
Wrapper functions for choosing the \pkg{penalized} tuning parameter used by \code{fit.penalized}, \code{fit.LASSO}, and \code{fit.fusedLASSO}.
}
\usage{
complexity.cv.penalized(response, x, full.data, ...)
complexity.LASSO(response, x, full.data, ...)
complexity.fusedLASSO(response, x, full.data, ...)
}
\arguments{
  \item{response}{response used for model fitting. Survival responses may be passed as a \code{Surv} object or as a two-column matrix with \code{time} and \code{status}.}
  \item{x}{\code{n * p} matrix of covariates.}
  \item{full.data}{data frame containing the full data set. This argument is accepted to match the \code{peperr} complexity-function contract.}
  \item{\dots}{additional arguments passed to \code{\link[penalized]{profL1}}.}
}
\value{
A scalar tuning value, typically the selected \code{lambda1}.
}
\details{
\code{complexity.cv.penalized} profiles the cross-validated \code{lambda1} values returned by \code{\link[penalized]{profL1}} and keeps the maximizer. \code{complexity.LASSO} is a compatibility alias. \code{complexity.fusedLASSO} performs the same search while forwarding \code{fusedl = TRUE}.
}
\seealso{
\code{\link{fit.penalized}}, \code{\link{fit.LASSO}}, \code{\link{fit.fusedLASSO}}, \code{\link[penalized]{profL1}}
}
\keyword{models} \keyword{regression} \keyword{survival}
