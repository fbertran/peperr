\name{fit.penalized}
\alias{fit.penalized}
\alias{fit.LASSO}
\alias{fit.fusedLASSO}
\title{Penalized backend fitting wrappers}
\description{
Interface functions for fitting \pkg{penalized} models in \code{peperr}. The generic wrapper is \code{fit.penalized}; \code{fit.LASSO} and \code{fit.fusedLASSO} are convenience aliases for plain and fused lasso fits.
}
\usage{
fit.penalized(response, x, cplx, ...)
fit.LASSO(response, x, cplx, ...)
fit.fusedLASSO(response, x, cplx, ...)
}
\arguments{
  \item{response}{response. This can be a binary vector, a numeric response, a \code{Surv} object, or a two-column matrix with \code{time} and \code{status}.}
  \item{x}{\code{n * p} matrix of covariates.}
  \item{cplx}{complexity value. For the \pkg{penalized} backend this is usually \code{lambda1}, or a named list of tuning arguments.}
  \item{\dots}{additional arguments passed to \code{\link[penalized]{penalized}}.}
}
\value{
A fitted \code{penfit} object.
}
\details{
\code{fit.penalized} is the general wrapper around \code{\link[penalized]{penalized}}. For survival models it also stores the training design matrix and response so that \code{predictProb.penfit} and \code{PLL.penfit} can be used later by \code{pmpec} and \code{peperr}.

\code{fit.LASSO} simply calls \code{fit.penalized}. \code{fit.fusedLASSO} calls the same backend with \code{fusedl = TRUE}.
}
\seealso{
\code{\link{complexity.cv.penalized}}, \code{\link{predictProb.penfit}}, \code{\link{PLL.penfit}}, \code{\link[penalized]{penalized}}
}
\keyword{models} \keyword{regression} \keyword{survival}
