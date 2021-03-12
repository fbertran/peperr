\name{ipec}
\alias{ipec}
\title{Integrated prediction error curve}
\description{
Summary measures of prediction error curves
}
\usage{
ipec(pe, eval.times, type=c("Riemann", "Lebesgue", "relativeLebesgue"), response=NULL)
}

\arguments{
  \item{pe}{prediction error at different time points. Vector of length of \code{eval.times} or matrix (columns correspond to evaluation time points, rows to different prediction error estimates)}
  \item{eval.times}{evalutation time points}
  \item{type}{type of integration. 'Riemann' estimates Riemann integral, 'Lebesgue' uses the probability density as weights, while 'relativeLebesgue' delivers the difference to the null model (using the same weights as for 'Lebesgue').}
  \item{response}{survival object (\code{Surv(time, status)}), required only if \code{type} is 'Lebesgue' or 'relativeLebesgue'}
}

\value{
\item{ipec}{Value of integrated prediction error curve. Integer or vector, if \code{pe} is vector or matrix, respectively, i.e. one entry per row of the passed matrix.}
}

\details{
For survival data, prediction error at each evaluation time point can be extracted of a \code{peperr} object by function \code{perr}. A summary measure can then be obtained via intgrating over time. Note that the time points used for evaluation are stored in list element \code{attribute} of the \code{peperr} object.
}

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
prederr <- perr(peperr.object)
# Integrated prediction error curve for both complexity values
ipec(prederr, eval.times=peperr.object$attribute, response=Surv(time, status))
}
}

\seealso{\code{\link{perr}}}

\keyword{models} \keyword{regression} \keyword{survival}
