\name{fit.LASSO}
\alias{fit.LASSO}
\title{Interface function for fitting a generalised linear model with the lasso}
\description{
Interface for fitting survival models with the lasso, conforming to the requirements of argument \code{fit.fun} in \code{peperr} call. 
}
\usage{
fit.LASSO(response, x, cplx, ...)
}
\arguments{
  \item{response}{response. Could be numeric vector for linear regression, \code{Surv} object for Cox regression or a binary vector for logistic regression.}
  \item{x}{\code{n*p} matrix of covariates.}
  \item{cplx}{LASSO penalty. \code{lambda1} of \code{penalized} call.}
  \item{\dots}{additional arguments passed to \code{penalized} call.}
}
\value{
penfit object
}
\details{
Function is basically a wrapper around function \code{penalized} of package \code{penalized}. 
}
\seealso{ \code{peperr}, \code{\link[penalized]{penalized}}}
\keyword{models} \keyword{regression} \keyword{survival}