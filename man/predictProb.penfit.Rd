\name{predictProb.penfit}
\alias{predictProb.penfit}
\title{Predicted survival probabilities for penalized Cox models}
\description{
Extracts survival probabilities from a \code{penfit} survival model for use in \code{pmpec}.
}
\usage{
\method{predictProb}{penfit}(object, response, x, times, complexity = NULL, ...)
}
\arguments{
  \item{object}{a fitted \code{penfit} object.}
  \item{response}{survival response, passed for consistency with the \code{predictProb} interface.}
  \item{x}{new covariate matrix.}
  \item{times}{evaluation times.}
  \item{complexity}{unused for fitted \code{penfit} objects; included for interface compatibility.}
  \item{\dots}{additional arguments passed to the \pkg{penalized} prediction method.}
}
\value{
Matrix of survival probabilities with one row per observation and one column per evaluation time.
}
\seealso{
\code{\link{predictProb}}, \code{\link{fit.penalized}}, \code{\link{PLL.penfit}}
}
\keyword{models} \keyword{regression} \keyword{survival}
