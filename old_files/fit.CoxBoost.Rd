\name{fit.CoxBoost}
\alias{fit.CoxBoost}
\title{Interface function for fitting a CoxBoost model}
\description{
Interface for fitting survival models by \code{CoxBoost}, conforming to the requirements for argument \code{fit.fun} in \code{peperr} call. 
}
\usage{
fit.CoxBoost(response, x, cplx, ...)
}
\arguments{
  \item{response}{a survival object (with \code{Surv(time, status)}).}
  \item{x}{\code{n*p} matrix of covariates.}
  \item{cplx}{number of boosting steps or list, containing number of boosting steps in argument \code{stepno} and penalty factor in argument \code{penalty.factor}.}
  \item{\dots}{additional arguments passed to \code{CoxBoost} call.}
}
\value{
CoxBoost object
}
\details{
Function is basically a wrapper around \code{CoxBoost} of package \pkg{CoxBoost}. A Cox proportional hazards model is fitted by componentwise likelihood based boosting, especially suited for models with many covariates and few observations. 
}
\seealso{ \code{peperr}, \code{\link[CoxBoost]{CoxBoost}}}
\keyword{models} \keyword{regression} \keyword{survival}