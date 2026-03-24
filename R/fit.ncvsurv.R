.ncvsurv_lambda <- function(object, complexity, caller) {
   lambda <- .peperr_complexity_value(
      complexity = complexity,
      default = attr(object, "peperr_lambda"),
      caller = caller
   )

   as.numeric(lambda)[1L]
}

fit.ncvsurv <- function(response, x, cplx, ...) {
   .require_suggested_package("ncvreg", "fit.ncvsurv()")
   fit_response <- if (.peperr_is_survival_response(response)) .peperr_surv_object(response) else response

   fit_args <- c(
      list(
         X = as.matrix(x),
         y = fit_response
      ),
      if (.peperr_is_missing_complexity(cplx)) {
         list()
      } else {
         list(lambda = cplx)
      },
      list(...)
   )

   res <- do.call(ncvreg::ncvsurv, fit_args)
   attr(res, "peperr_lambda") <- if (.peperr_is_missing_complexity(cplx)) NULL else as.numeric(cplx)[1L]
   .peperr_store_training_context(res, response, x)
}

complexity.cv.ncvsurv <- function(response, x, full.data, ...) {
   .require_suggested_package("ncvreg", "complexity.cv.ncvsurv()")
   fit_response <- if (.peperr_is_survival_response(response)) .peperr_surv_object(response) else response

   cvfit <- do.call(
      ncvreg::cv.ncvsurv,
      c(list(X = as.matrix(x), y = fit_response), list(...))
   )

   if (!is.null(cvfit$lambda.min)) {
      return(as.numeric(cvfit$lambda.min))
   }

   as.numeric(cvfit$fit$lambda[cvfit$min])
}
