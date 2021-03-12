fit.LASSO <- function(response, x, cplx, ...){
   data <- as.data.frame(x)
   data$response <- response
   res <- penalized::penalized(response=response, data=data, lambda1=cplx, penalized=x, trace=FALSE, ...)
   attr(res, "response") <- response
   attr(res, "x") <- x
   res
}