predictProb.penfit <- function(object, response, x, times, complexity = NULL, ...) {
   .require_suggested_package("penalized", "predictProb.penfit()")

   breslow <- methods::getMethod("predict", "penfit")(
      object,
      penalized = x,
      data = as.data.frame(x),
      ...
   )

   .peperr_step_curve_matrix(
      curves = breslow@curves,
      curve_times = breslow@time,
      eval_times = times
   )
}
