predictProb.SGL_cox <- function(object, response, x, times, complexity = NULL, ...) {
   .require_suggested_package("SGL", "predictProb.SGL_cox()")

   context <- .peperr_training_context(object, "predictProb.SGL_cox()")
   lp_new <- .SGL_linear_predictor(object, x, complexity, "predictProb.SGL_cox()")
   lp_train <- .SGL_linear_predictor(object, context$x, complexity, "predictProb.SGL_cox()")

   .peperr_breslow_survival(
      train_time = context$response[, "time"],
      train_status = context$response[, "status"],
      train_lp = lp_train,
      new_lp = lp_new,
      times = times
   )
}
