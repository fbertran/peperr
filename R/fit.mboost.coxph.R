fit.mboost.coxph <- function(response, x, cplx, ...) {
   .require_suggested_package("mboost", "fit.mboost.coxph()")

   mstop <- if (.peperr_is_missing_complexity(cplx)) 100L else as.integer(cplx)[1L]
   fit_args <- c(
      list(
         formula = survival::Surv(time, status) ~ .,
         data = .peperr_survival_dataframe(response, x),
         family = mboost::CoxPH()
      ),
      list(...)
   )

   if (is.null(fit_args$control)) {
      fit_args$control <- mboost::boost_control(mstop = mstop)
   } else {
      fit_args$control$mstop <- mstop
   }

   res <- do.call(mboost::glmboost, fit_args)
   class(res) <- c("mboost_coxph", class(res))
   .peperr_store_training_context(res, response, x)
}

complexity.cvrisk.mboost <- function(response, x, full.data, max.mstop = 100L, folds = NULL, ...) {
   .require_suggested_package("mboost", "complexity.cvrisk.mboost()")

   data <- .peperr_survival_dataframe(response, x)
   fit <- mboost::glmboost(
      formula = survival::Surv(time, status) ~ .,
      data = data,
      family = mboost::CoxPH(),
      control = mboost::boost_control(mstop = max.mstop),
      ...
   )

   cvfit <- if (is.null(folds)) {
      mboost::cvrisk(fit)
   } else {
      mboost::cvrisk(fit, folds = folds)
   }

   selected <- tryCatch(
      as.integer(mboost::mstop(cvfit)),
      error = function(e) which.min(as.numeric(cvfit))
   )

   as.integer(selected)[1L]
}
