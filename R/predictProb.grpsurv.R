predictProb.grpsurv <- function(object, response, x, times, complexity = NULL, ...) {
   .require_suggested_package("grpreg", "predictProb.grpsurv()")

   lambda <- .peperr_complexity_value(
      complexity = complexity,
      default = attr(object, "peperr_lambda"),
      caller = "predictProb.grpsurv()"
   )

   pred <- if (length(object$lambda) > 1L) {
      stats::predict(
         object,
         X = as.matrix(x),
         type = "survival",
         lambda = lambda,
         ...
      )
   } else {
      stats::predict(
         object,
         X = as.matrix(x),
         type = "survival",
         ...
      )
   }

   curve_times <- c(0, attr(pred, "time"))

   .peperr_step_functions_to_matrix(
      curve_functions = pred,
      curve_times = curve_times,
      eval_times = times
   )
}
