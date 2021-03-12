\name{PLL.coxph}
\alias{PLL.coxph}
\title{Predictive partial log-likelihood for Cox poportional hazards model}
\description{
Extracts the predictive partial log-likelihood from a coxph model fit.
}
\usage{
\method{PLL}{coxph}(object, newdata, newtime, newstatus, complexity, \dots)
}
\arguments{
  \item{object}{fitted model of class \code{coxph}.}
  \item{newdata}{\code{n_new*p} matrix of covariates.}
  \item{newtime}{\code{n_new}-vector of censored survival times.}
  \item{newstatus}{\code{n_new}-vector of survival status, coded with 0 and .1}
  \item{complexity}{not used.}
  \item{\dots}{additional arguments, not used.}
}
\details{
Used by function \code{peperr}, if function \code{fit.coxph} is used for model fit.
}
\value{
Vector of length \code{n_new}
}
\keyword{models} \keyword{regression} \keyword{survival}