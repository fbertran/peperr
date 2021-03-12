\name{plot.peperr}
\alias{plot.peperr}
\title{Plot method for peperr object}
\description{Plots, allowing to get a first impression of the prediction error estimates and to check complexity selection in bootstrap samples.}
\usage{
\method{plot}{peperr}(x, y, ...)
}
\arguments{
\item{x}{\code{peperr} object.}
\item{y}{not used.}
\item{\dots}{additional arguments, not used.}
}
\details{
The plots provide a simple and fast overview of the results of the estimation of the prediction error through resampling. Which plots are shown depends on if complexity was selected, i.e., a function was passed in the \code{peperr} call for \code{complexity}, or explicitly passed. In case of survival response, prediction error curves are shown. In case of binary response, where one complexity value is passed explicitly, no plot is available.
Especially in the case that complexity is selected in each bootstrap sample, these diagnostic plots help to check whether the resampling procedure works adequately and to detect specific problems due to high-dimensional data structures.

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

peperr.object1 <- peperr(response=Surv(time, status), x=x, 
   fit.fun=fit.CoxBoost, complexity=c(50, 75), 
   indices=resample.indices(n=length(time), method="sub632", sample.n=10))
plot(peperr.object1)

peperr.object2 <- peperr(response=Surv(time, status), x=x, 
   fit.fun=fit.CoxBoost, args.fit=list(penalty=100),
   complexity=complexity.mincv.CoxBoost, args.complexity=list(penalty=100),
   indices=resample.indices(n=length(time), method="sub632", sample.n=10),
   trace=TRUE)
plot(peperr.object2)

peperr.object3 <- peperr(response=Surv(time, status), x=x, 
   fit.fun=fit.CoxBoost, args.fit=list(penalty=100),
   complexity=complexity.mincv.CoxBoost, args.complexity=list(penalty=100),
   indices=resample.indices(n=length(time), method="sub632", sample.n=10),
   args.aggregation=list(times=seq(0, quantile(time, probs=0.9), length.out=100)),
   trace=TRUE)
plot(peperr.object3)
}
}
\keyword{models} \keyword{regression} \keyword{survival}