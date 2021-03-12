\name{complexity.LASSO}
\alias{complexity.LASSO}
\title{Interface for selection of optimal parameter for lasso fit}
\description{
Determines the optimal value for tuning parameter lambda for a regression model with lasso penalties via cross-validation. Conforming to the calling convention required by argument \code{complexity} in \code{peperr} call. 
}
\usage{
complexity.LASSO(response, x, full.data, ...)
}
\arguments{
  \item{response}{a survival object (\code{Surv(time, status)}).}
  \item{x}{\code{n*p} matrix of covariates.}
  \item{full.data}{data frame containing response and covariates of the full data set.}
  \item{\dots}{additional arguments passed to \code{optL1} of package \pkg{penalized} call.}
  }
\value{
Scalar value giving the optimal value for lambda.
}
\details{
Function is basically a wrapper around \code{optL1} of package \pkg{penalized}.  Calling \code{peperr}, default arguments of \code{optL1} can be changed by passing a named list containing these as argument \code{args.complexity}.
}
\seealso{\code{peperr}, \code{\link[penalized]{optL1}}}
\keyword{models} \keyword{regression} \keyword{survival}
