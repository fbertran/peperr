\name{pmpec}
\alias{pmpec}
\title{Calculate prediction error curves}
\description{Calculation of prediction error curve from a survival response and predicted probabilities of survival.}
\usage{
pmpec(object, response=NULL, x=NULL, times, model.args=NULL, 
    type=c("PErr","NoInf"), external.time=NULL, external.status=NULL, 
    data=NULL)
}
\arguments{
\item{object}{fitted model of a class for which the interface function \code{predictProb.class} is available.}
\item{response}{Either a survival object (with \code{Surv(time, status)}, where time is an \code{n}-vector of censored survival times and status an \code{n}-vector containing event status, coded with 0 and 1) or a matrix with columns \code{time} containing survival times and \code{status} containing integers, where 0 indicates censoring, 1 the interesting event and larger numbers other competing risks.}
\item{x}{\code{n*p} matrix of covariates.}
\item{times}{vector of time points at which the prediction error is to be estimated.}
\item{model.args}{named list of additional arguments, e.g. complexity value, which are to be passed to \code{predictProb} function.}
\item{type}{type of output: Estimated prediction error (default) or no information error (prediction error obtained by permuting the data).}
\item{external.time}{optional vector of time points, used for censoring distribution.}
\item{external.status}{optional vector of status values, used for censoring distribution.}
\item{data}{Data frame containing \code{n}-vector of observed times ('time'), \code{n}-vector of event status ('status') and \code{n*p} matrix of covariates (remaining entries). Alternatively to \code{response} and \code{x}, for compatibility to \pkg{pec}.}
}
\value{
Vector of prediction error estimates at each time point given in \code{time}.
}
\details{
Prediction error of survival data is measured by the Brier score, which considers the squared difference of the true event status at a given time point and the predicted event status by a risk prediction model at that time. A prediction error curve is the weighted mean Brier score as a function of time at time points in \code{times} (see References).

\code{pmpec} requires a \code{predictProb} method for the class of the fitted model, i.e. for a model of class \code{class} \code{predictProb.class}. 

\code{pmpec} is implemented to behave similar to function \code{pec} of package \pkg{pec}, which provides several \code{predictProb} methods.

In bootstrap framework, \code{data} contains only a part of the full data set. For censoring distribution, the full data should be used to avoid extreme variance in case of small data sets. For that, the observed times and status values can be passed as argument \code{external.time} and \code{external.status}.
}

\seealso{\code{predictProb}, \pkg{pec}}

\author{Harald Binder}

\references{
Gerds, A. and Schumacher, M. (2006) Consistent estimation of the expected Brier score in general survival models with right-censored event times. Biometrical Journal, 48, 1029--1040.

Schoop, R. (2008) Predictive accuracy of failure time models with longitudinal covariates. PhD thesis, University of Freiburg.  http://www.freidok.uni-freiburg.de/volltexte/4995/.
}
\keyword{models} \keyword{regression} \keyword{survival}