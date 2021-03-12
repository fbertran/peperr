\name{predictProb.CoxBoost}
\alias{predictProb.CoxBoost}
\title{Extract predicted survival probabilities from a CoxBoost fit}
\description{
Extracts predicted survival probabilities from survival model fitted by CoxBoost, providing an interface as required by \code{pmpec}. 
}
\usage{
\method{predictProb}{CoxBoost}(object, response, x, times, complexity, \dots)
}
\arguments{
\item{object}{a fitted model of class \code{CoxBoost}.}
\item{response}{survival object (with \code{Surv(time, status)}, where time is an \code{n}-vector of censored survival times and status an \code{n}-vector containing survival status, coded with 0 and 1.}
\item{x}{\code{n*p} matrix of covariates.}
\item{times}{vector of evaluation time points.}
\item{complexity}{complexity value.}
\item{\dots}{additional arguments, currently not used.}
}

\value{
Matrix with probabilities for each evaluation time point in \code{times} (columns) and each new observation (rows). 
}
\keyword{models} \keyword{regression} \keyword{survival}