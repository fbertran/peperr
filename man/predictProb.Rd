\name{predictProb}
\alias{predictProb}
\title{Generic function for extracting predicted survival probabilities}
\description{
Generic function for extraction of predicted survival probabilities from a fitted survival model conforming to the interface required by \code{pmpec}.
}
\usage{
predictProb(object, response, x, ...)
}
\arguments{
\item{object}{a fitted survival model.}
\item{response}{Either a survival object (with \code{Surv(time, status)}, where time is an \code{n}-vector of censored survival times and status an \code{n}-vector containing event status, coded with 0 and 1) or a matrix with columns \code{time} containing survival times and \code{status} containing integers, where 0 indicates censoring, 1 the interesting event and larger numbers other competing risks. In case of binary response, vector with entries 0 and 1.}
\item{x}{\code{n*p} matrix of covariates.}	  
\item{\dots}{additional arguments, for example model complexity or, in case of survival response, argument \code{times}, a vector containing evaluation times. }
}
\details{
\code{pmpec} requires a \code{predictProb.class} function for each model fit of class \code{class}. It extracts the predicted probability of survival from this model.

See existing \code{predictProb} functions, at the time \code{predictProb.CoxBoost}, \code{predictProb.coxph} and \code{predictProb.survfit}. 

If desired \code{predictProb} function for class \code{class} is not available in \pkg{peperr}, but implemented in package \pkg{pec} as \code{predictSurvProb.class}, it can easily be transformed as \code{predictProb} method.
}

\value{
Matrix with predicted probabilities for each evaluation time point in \code{times} (columns) and each new observation (rows). 
}
\keyword{models} \keyword{regression} \keyword{survival}