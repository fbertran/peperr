\name{perr}
\alias{perr}
\title{Prediction error estimates}
\description{
Extracts prediction error estimates from \code{peperr} objects. 
}
\usage{
perr(peperrobject, 
    type = c("632p", "632", "apparent", "NoInf", "resample", "nullmodel"))
}

\arguments{
  \item{peperrobject}{peperr object obtained by call to function \code{peperr}.}
  \item{type}{\code{"632p"} for the .632+ prediction error estimate (default), \code{"632"} for the .632 prediction error estimate. \code{"apparent"}, \code{"NoInf"}, \code{"resample"} and \code{"nullmodel"} return the apparent error, the no-information error, the mean sample error and the nullmodel fit, see Details.}
}

\value{
If \code{type="632p"} or \code{type="632"}: Prediction error: Matrix, with one row per complexity value.

If \code{type="apparent"}: Apparent error of the full data set. Matrix: One row per complexity value. In case of survival response, columns correspond to evaluation timepoints, which are given in attribute \code{addattr}.

If \code{type="NoInf"}: No-information error of the full data set, i. e. evaluation in permuted data. Matrix: One row per complexity value. Columns correspond to evaluation timepoints, which are given in attribute \code{addattr}.

If \code{type="resample"}: Matrix. Mean prediction error of resampling test samples, one row per complexity value.

If \code{type="nullmodel"}: Vector or scalar: Null model prediction error, i.e. of fit without information of covariates. In case of survival response Kaplan-Meier estimate at each time point, if response is binary logistic regression model, else not available.
}

\details{
The .632 and the .632+ prediction error estimates are weighted combinations of the apparent error and bootstrap cross-validation error estimate, for survival data at given time points.
}

\references{
Binder, H. and Schumacher, M. (2008) Adapting prediction error estimates for biased complexity selection in high-dimensional bootstrap samples. Statistical Applications in Genetics and Molecular Biology, 7:1.

Gerds, T. and Schumacher, M. (2007) Efron-type measures of prediction error for survival analysis. Biometrics, 63, 1283--1287.

Schumacher, M. and Binder, H., and Gerds, T. (2007) Assessment of Survival Prediction Models in High-Dimensional Settings. Bioinformatics, 23, 1768-1774.}

\seealso{\code{\link{peperr}}, \code{\link{ipec}}}

\examples{
\dontrun{
n <- 200
p <- 100
beta <- c(rep(1,10),rep(0,p-10))
x <- matrix(rnorm(n*p),n,p)
real.time <- -(log(runif(n)))/(10*exp(drop(x \%*\% beta)))
cens.time <- rexp(n,rate=1/10)
status <- ifelse(real.time <= cens.time,1,0)
time <- ifelse(real.time <= cens.time,real.time,cens.time)

# Example:
# Obtain prediction error estimate fitting a Cox proportional hazards model
# using CoxBoost 
# through 10 bootstrap samples 
# with fixed complexity 50 and 75
# and aggregate using prediction error curves
peperr.object <- peperr(response=Surv(time, status), x=x, 
   fit.fun=fit.CoxBoost, complexity=c(50, 75), 
   indices=resample.indices(n=length(time), method="sub632", sample.n=10))
# 632+ estimate for both complexity values at each time point
perr(peperr.object)

}
}
\keyword{models} \keyword{regression} \keyword{survival}
