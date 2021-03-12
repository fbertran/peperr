complexity.LASSO <- function(response, x, full.data, ...){
   #requireNamespace(penalized)
   prof <- penalized::profL1(response=response, penalized=x, trace=FALSE, ...)
   lambda <- prof$lambda[which.max(prof$cvl)]
   lambda
}