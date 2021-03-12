\name{PLL.CoxBoost}
\alias{PLL.CoxBoost}
\title{Predictive partial log-likelihood for CoxBoost model fit}
\description{
Extracts the predictive partial log-likelihood from a CoxBoost model fit.
}
\usage{
\method{PLL}{CoxBoost}(object, newdata, newtime, newstatus, complexity, \dots)
}
\arguments{
  \item{object}{fitted model of class \code{CoxBoost}.}
  \item{newdata}{\code{n_new*p} matrix of covariates.}
  \item{newtime}{\code{n_new}-vector of censored survival times.}
  \item{newstatus}{\code{n_new}-vector of survival status, coded with 0 and .1}
  \item{complexity}{complexity, either one value, which is number of boosting steps, or a list containing number of boosting steps in argument \code{stepno}.}
  \item{\dots}{additional arguments, not used.}
}
\details{
Used by function \code{peperr}, if function \code{fit.CoxBoost} is used for model fit.
}
\value{
Vector of length \code{n_new}
}
\keyword{models} \keyword{regression} \keyword{survival}