fit.glmnet <- function(response, x, cplx, ...) {
   .require_suggested_package("glmnet", "fit.glmnet()")
   fit_response <- if (.peperr_is_survival_response(response)) .peperr_surv_object(response) else response

   fit_args <- c(
      list(
         x = as.matrix(x),
         y = fit_response,
         family = "cox"
      ),
      if (.peperr_is_missing_complexity(cplx)) {
         list()
      } else {
         list(lambda = cplx)
      },
      list(...)
   )

   res <- do.call(glmnet::glmnet, fit_args)
   attr(res, "peperr_lambda") <- if (.peperr_is_missing_complexity(cplx)) NULL else cplx
   .peperr_store_training_context(res, response, x)
}

complexity.cv.glmnet <- function(response, x, full.data, ...) {
   .require_suggested_package("glmnet", "complexity.cv.glmnet()")
   fit_response <- if (.peperr_is_survival_response(response)) .peperr_surv_object(response) else response

   cvfit <- glmnet::cv.glmnet(
      x = as.matrix(x),
      y = fit_response,
      family = "cox",
      ...
   )

   as.numeric(cvfit$lambda.min)
}
