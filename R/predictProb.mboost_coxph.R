predictProb.mboost_coxph <- function(object, response, x, times, complexity = NULL, ...) {
   .require_suggested_package("mboost", "predictProb.mboost_coxph()")

   surv_pred <- try(
      mboost::survFit(object, newdata = as.data.frame(x), ...),
      silent = TRUE
   )

   if (!inherits(surv_pred, "try-error") && !is.null(surv_pred$surv) && !is.null(surv_pred$time)) {
      surv <- as.matrix(surv_pred$surv)

      if (nrow(surv) == length(surv_pred$time) && ncol(surv) == nrow(x)) {
         surv <- t(surv)
      } else if (!(nrow(surv) == nrow(x) && ncol(surv) == length(surv_pred$time))) {
         surv <- matrix(as.numeric(surv), nrow = nrow(x), byrow = TRUE)
      }

      return(.peperr_step_curve_matrix(
         curves = surv,
         curve_times = surv_pred$time,
         eval_times = times
      ))
   }

   context <- .peperr_training_context(object, "predictProb.mboost_coxph()")
   lp_new <- stats::predict(object, newdata = as.data.frame(x), type = "link")
   lp_train <- stats::predict(object, newdata = as.data.frame(context$x), type = "link")

   .peperr_breslow_survival(
      train_time = context$response[, "time"],
      train_status = context$response[, "status"],
      train_lp = lp_train,
      new_lp = lp_new,
      times = times
   )
}
