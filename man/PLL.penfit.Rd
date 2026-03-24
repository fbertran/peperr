\name{PLL.penfit}
\alias{PLL.penfit}
\title{Predictive partial log-likelihood for penalized Cox models}
\description{
Computes the predictive partial log-likelihood for \code{penfit} survival models.
}
\usage{
\method{PLL}{penfit}(object, newdata, newtime, newstatus, complexity = NULL, ...)
}
\arguments{
  \item{object}{a fitted \code{penfit} object.}
  \item{newdata}{new covariate matrix.}
  \item{newtime}{vector of follow-up times.}
  \item{newstatus}{vector of event indicators.}
  \item{complexity}{unused for fitted \code{penfit} objects; included for interface compatibility.}
  \item{\dots}{unused additional arguments.}
}
\value{
Numeric predictive partial log-likelihood.
}
\seealso{
\code{\link{PLL}}, \code{\link{fit.penalized}}, \code{\link{predictProb.penfit}}
}
\keyword{models} \keyword{regression} \keyword{survival}
