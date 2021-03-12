\name{predictProb.survfit}
\alias{predictProb.survfit}
\title{Extract predicted survival probabilities from a survfit object}
\description{
Extracts predicted survival probabilities for survival models fitted by \code{survfit}, providing an interface as required by \code{pmpec}. 
}
\usage{
\method{predictProb}{survfit}(object, response, x, times, train.data, \dots)
}
\arguments{
\item{object}{a fitted model of class \code{survfit}.}
\item{response}{survival object (with \code{Surv(time, status)}, where time is an \code{n}-vector of censored survival times and status an \code{n}-vector containing survival status, coded with 0 and 1.}
\item{x}{\code{n*p} matrix of covariates.}
\item{times}{vector of evaluation time points.}
\item{train.data}{not used.}
\item{\dots}{additional arguments, currently not used.}
}
\value{
Matrix with probabilities for each evaluation time point in \code{times}(columns) and each new observation (rows). 
}
\keyword{models} \keyword{regression} \keyword{survival}