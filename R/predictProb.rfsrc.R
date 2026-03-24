predictProb.rfsrc <- function(object, response, x, times, complexity = NULL, ...) {
   .require_suggested_package("randomForestSRC", "predictProb.rfsrc()")

   pred <- randomForestSRC::predict.rfsrc(
      object,
      newdata = as.data.frame(x),
      ...
   )

   curve_times <- pred$time.interest
   if (is.null(curve_times)) {
      curve_times <- object$time.interest
   }

   .peperr_step_curve_matrix(
      curves = pred$survival,
      curve_times = curve_times,
      eval_times = times
   )
}
