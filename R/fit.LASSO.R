fit.penalized <- function(response, x, cplx, ...) {
   .require_suggested_package("penalized", "fit.penalized()")
   fit_response <- if (.peperr_is_survival_response(response)) .peperr_surv_object(response) else response

   fit_args <- c(
      list(
         response = fit_response,
         penalized = x,
         data = as.data.frame(x),
         trace = FALSE
      ),
      if (is.list(cplx)) {
         cplx
      } else if (.peperr_is_missing_complexity(cplx)) {
         list()
      } else {
         list(lambda1 = cplx)
      },
      list(...)
   )

   res <- do.call(penalized::penalized, fit_args)

   if (.peperr_is_survival_response(response)) {
      return(.peperr_store_training_context(res, response, x))
   }

   attr(res, "response") <- response
   attr(res, "x") <- x
   res
}

fit.LASSO <- function(response, x, cplx, ...) {
   fit.penalized(response = response, x = x, cplx = cplx, ...)
}

fit.fusedLASSO <- function(response, x, cplx, ...) {
   fit.penalized(response = response, x = x, cplx = cplx, fusedl = TRUE, ...)
}
