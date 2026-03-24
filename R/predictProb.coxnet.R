predictProb.coxnet <- function(object, response, x, times, complexity = NULL, ...) {
   .require_suggested_package("glmnet", "predictProb.coxnet()")

   context <- .peperr_training_context(object, "predictProb.coxnet()")
   lambda <- .peperr_complexity_value(
      complexity = complexity,
      default = attr(object, "peperr_lambda"),
      caller = "predictProb.coxnet()"
   )

   survfit.object <- survival::survfit(
      object,
      s = lambda,
      x = context$x,
      y = survival::Surv(context$response[, "time"], context$response[, "status"]),
      newx = as.matrix(x),
      ...
   )

   .peperr_survfit_to_matrix(
      survfit_object = survfit.object,
      times = times,
      nobs = nrow(x)
   )
}
