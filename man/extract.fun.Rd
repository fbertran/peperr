\name{extract.fun}
\alias{extract.fun}
\title{Extract functions, libraries and global variables to be loaded onto a compute cluster}
\description{
Automatic extraction of functions, libraries and global variables employed passed functions. Designed for \code{peperr} call, see Details section there.
}
\usage{
extract.fun(funs = NULL)
}
\arguments{
\item{funs}{list of function names.}
}
\value{
list containing
  \item{packages}{vector containing quoted names of libraries}
  \item{functions}{vector containing quoted names of functions}
  \item{variables}{vector containing quoted names of global variables}

}
\details{
This function is necessary for compute cluster situations where for computation on nodes required functions, libraries and variables have to be loaded explicitly on each node. Avoids loading of whole global environment which might include the unnecessary loading of huge data sets. 

It might have problems in some cases, especially it is not able to extract the library of a function that has no namespace. Similarly, it can only extract a required library if it is loaded, or if the function contains a require or library call. 
}
\seealso{\code{peperr}}
\examples{
# 1. Simplified example for illustration
\dontrun{
library(CoxBoost)
a <- function(){
# some calculation
}

b<-function(){
# some other calculation
x <- cv.CoxBoost()
# z is global variable
y <- a(z)
}

# list with packages, functions and variables required for b:
extract.fun(list(b))

# 2. As called by default in peperr example
extract.fun(list(fit.CoxBoost, aggregation.pmpec))
}
}
\keyword{models} \keyword{regression} \keyword{survival}