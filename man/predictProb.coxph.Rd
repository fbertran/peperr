\name{predictProb.coxph}
\alias{predictProb.coxph}
\title{Extract predicted survival probabilities from a coxph object}
\description{
Extracts predicted survival probabilities for survival models fitted by Cox proportional hazards model, providing an interface as required by \code{pmpec}. 
}
\usage{
\method{predictProb}{coxph}(object, response, x, times, \dots)
}
\arguments{
\item{object}{a fitted model of class \code{coxph}.}
\item{response}{survival object (with \code{Surv(time, status)}, where time is an \code{n}-vector of censored survival times and status an \code{n}-vector containing survival status, coded with 0 and 1.}
\item{x}{\code{n*p} matrix of covariates.}
\item{times}{vector of evaluation time points.}
\item{\dots}{additional arguments, currently not used.}
}
\value{
Matrix with probabilities for each evaluation time point in \code{times}(columns) and each new observation (rows). 
}
\keyword{models} \keyword{regression} \keyword{survival}