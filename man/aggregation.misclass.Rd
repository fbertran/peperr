\name{aggregation.misclass}
\alias{aggregation.misclass}
\title{Determine the missclassification rate for a fitted model}
\description{
Evaluate the misclassification rate, i.e. prediction error, for a fitted model on new data. To use as argument \code{aggregation.fun} in \code{peperr} call. 
}
\usage{
aggregation.misclass(full.data=NULL, response, x, model, cplx=NULL,  
type=c("apparent", "noinf"), fullsample.attr = NULL, ...)
}
\arguments{
\item{full.data}{passed from \code{peperr}, but not used for calculation of the misclassification rate.}
\item{response}{vector of binary response.}
\item{x}{\code{n*p} matrix of covariates.}
\item{model}{model fitted with \code{fit.fun}.}
\item{cplx}{passed from \code{peperr}, but not necessary for calculation of the misclassification rate.}
\item{type}{character.}
\item{fullsample.attr}{passed from \code{peperr}, but not necessary for calculation of the misclassification rate.}
\item{\dots}{additional arguments, passed to \code{predict} function.}
}
\details{
Misclassification rate is the ratio of observations for which prediction of response is wrong. 
}
\value{
Scalar, indicating the misclassification rate.
}
\keyword{models} \keyword{regression} \keyword{survival}