\name{resample.indices}
\alias{resample.indices}
\title{Generation of indices for resampling Procedure}
\description{
Generates training and test set indices for use in resampling estimation of prediction error, e.g. cross-validation or bootstrap (with and without replacement).
}
\usage{
resample.indices(n, sample.n = 100, method = c("no", "cv" ,"boot", "sub632"))
}
\arguments{
\item{n}{number of observations of the full data set.}
\item{sample.n}{the number of bootstrap samples in case of \code{method="boot"} and the number of cross-validation subsets in case of \code{method="cv"}, e.g. 10 for 10-fold cross-validation. Not considered if \code{method="no"}, where number of samples is one (the full data set) by definition.}
\item{method}{by default, the training set indices are the same as the test set indices, i.e. the model is assessed in the same data as fitted (\code{"no"}). \code{"cv"}: Cross-validation, \code{"boot"}: Bootstrap (with replacement), \code{"sub632"}: Boostrap without replacement, also called subsampling. In the latter case, the number of observations in each sample equals \code{round(0.632 * n)}, see Details.}
}

\value{
A list containing two lists of length \code{sample.n}:
\item{sample.index}{contains in each element the indices of observations of one training set.}
\item{not.in.sample}{contains in each element the indices of observations of one test set, corresponding to the training set in listelement \code{sample.index}.}
}
\details{
As each bootstrap sample should be taken as if new data, complexity selection should be carried out in each bootstrap sample. Binder and Schumacher show that when bootstrap samples are drawn with replacement, often too complex models are obtained in high-dimensional data settings. They recommend to draw bootstrap samples without replacement, each of size \code{round(0.632 * n)}, which equals the expected number of unique observations in one bootstrap sample drawn with replacement, to avoid biased complexity selection and improve predictive power of the resulting models. 
}
\references{Binder, H. and Schumacher, M. (2008) Adapting prediction error estimates for biased complexity selection in high-dimensional bootstrap samples. Statistical Applications in Genetics and Molecular Biology, 7:1.}

\seealso{\code{peperr}}

\examples{
# generate dataset: 100 patients, 20 covariates
data <- matrix(rnorm(2000), nrow=100)

# generate indices for training and test data for 10-fold cross-validation
indices <- resample.indices(n=100, sample.n = 10, method = "cv")

# create training and test data via indices
trainingsample1 <- data[indices$sample.index[[1]],]
testsample1 <- data[indices$not.in.sample[[1]],]
}
\keyword{models} \keyword{regression} \keyword{survival}