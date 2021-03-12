\name{fit.coxph}
\alias{fit.coxph}
\title{Interface function for fitting a Cox proportional hazards model}
\description{
Interface for fitting survival models by Cox proporional hazards model, conforming to the requirements for argument \code{fit.fun} in \code{peperr} call. 
}
\usage{
fit.coxph(response, x, cplx, ...)
}
\arguments{
  \item{response}{a survival object (with \code{Surv(time, status)}).}
  \item{x}{\code{n*p} matrix of covariates.}
  \item{cplx}{not used.}
  \item{\dots}{additional arguments passed to \code{coxph} call.}
}
\value{
CoxBoost object
}
\details{
Function is basically a wrapper around \code{coxph} of package \pkg{survival}. 
}
\seealso{ \code{peperr}, \code{\link[survival]{coxph}}}
\keyword{models} \keyword{regression} \keyword{survival}