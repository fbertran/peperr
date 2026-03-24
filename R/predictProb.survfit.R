predictProb.survfit <- function (object, response, x, times, train.data=NULL, ...){
   .peperr_survfit_to_matrix(
      survfit_object = object,
      times = times,
      nobs = nrow(x)
   )
}
