\name{aggregation.brier}
\alias{aggregation.brier}
\title{Determine the Brier score for a fitted model}
\description{
Evaluate the Brier score, i.e. prediction error, for a fitted model on new data. To be used as argument \code{aggregation.fun} in \code{peperr} call. 
}
\usage{
aggregation.brier(full.data=NULL, response, x, model, cplx=NULL,  
type=c("apparent", "noinf"), fullsample.attr = NULL, ...)
}
\arguments{
\item{full.data}{passed from \code{peperr}, but not used for calculation of the Brier score.}
\item{response}{vector of binary response.}
\item{x}{\code{n*p} matrix of covariates.}
\item{model}{model fitted as returned by a \code{fit.fun}, as used in a call to \code{peperr}.}
\item{cplx}{passed from \code{peperr}, but not necessary for calculation of the Brier score.}
\item{type}{character.}
\item{fullsample.attr}{passed from \code{peperr}, but not necessary for calculation of the Brier score.}
\item{\dots}{additional arguments, passed to \code{predict} function.}
}
\details{
The empirical Brier score is the mean of the squared difference of the risk prediction and the true value of all observations and takes values between 0 and 1, where small values indicate good prediction performance of the risk prediction model.
}
\value{
Scalar, indicating the empirical Brier score.
}
\keyword{models} \keyword{regression} \keyword{survival}