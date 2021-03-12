\name{PLL}
\alias{PLL}
\title{Generic function for extracting the predictive partial log-likelihood}
\description{
Generic function for extracting th predictive partial log-likelihood from a fitted survival model.
}
\usage{
PLL(object, newdata, newtime, newstatus, ...)
}
\arguments{
  \item{object}{fitted model of class \code{class}.}
  \item{newdata}{\code{n_new*p} matrix of covariates.}
  \item{newtime}{\code{n_new}-vector of censored survival times.}
  \item{newstatus}{\code{n_new}-vector of event status, coded with 0 for censoring and 1, if an event occurred.}
  \item{\dots}{additional arguments, for example complexity value, if necessary.}
}
\details{
The predictive partial log-likelihood measures the prediction performance of each model fitted in a boostrap sample, using the data not in this sample. Multiplying by (-2) leads to a deviance-like measure, which means that small values indicate good prediction performance.

\code{peperr} requires function \code{PLL.class} in case of survival response, for each model fit of class \code{class}.
At the time, \code{PLL.CoxBoost} is available.
}
\value{
Vector of length \code{n_new}
}
\keyword{models} \keyword{regression} \keyword{survival}