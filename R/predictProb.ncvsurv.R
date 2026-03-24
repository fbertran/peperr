predictProb.ncvsurv <- function(object, response, x, times, complexity = NULL, ...) {
   .require_suggested_package("ncvreg", "predictProb.ncvsurv()")

   context <- .peperr_training_context(object, "predictProb.ncvsurv()")
   lambda <- .ncvsurv_lambda(object, complexity, "predictProb.ncvsurv()")

   survival_pred <- try(
      stats::predict(
         object,
         X = as.matrix(x),
         type = "survival",
         lambda = lambda,
         ...
      ),
      silent = TRUE
   )

   if (!inherits(survival_pred, "try-error") && !is.null(attr(survival_pred, "time"))) {
      curve_times <- c(0, attr(survival_pred, "time"))
      return(.peperr_step_functions_to_matrix(
         curve_functions = survival_pred,
         curve_times = curve_times,
         eval_times = times
      ))
   }

   lp_new <- stats::predict(
      object,
      X = as.matrix(x),
      type = "link",
      lambda = lambda,
      ...
   )
   lp_train <- stats::predict(
      object,
      X = context$x,
      type = "link",
      lambda = lambda,
      ...
   )

   .peperr_breslow_survival(
      train_time = context$response[, "time"],
      train_status = context$response[, "status"],
      train_lp = lp_train,
      new_lp = lp_new,
      times = times
   )
}
