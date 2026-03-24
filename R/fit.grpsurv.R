fit.grpsurv <- function(response, x, cplx, group, ...) {
   .require_suggested_package("grpreg", "fit.grpsurv()")
   fit_response <- if (.peperr_is_survival_response(response)) .peperr_surv_object(response) else response

   if (missing(group)) {
      stop("fit.grpsurv() requires a 'group' vector.", call. = FALSE)
   }

   fit_args <- c(
      list(
         X = as.matrix(x),
         y = fit_response,
         group = group
      ),
      if (.peperr_is_missing_complexity(cplx)) {
         list()
      } else {
         list(lambda = cplx)
      },
      list(...)
   )

   res <- do.call(grpreg::grpsurv, fit_args)
   attr(res, "peperr_lambda") <- if (.peperr_is_missing_complexity(cplx)) NULL else cplx
   .peperr_store_training_context(res, response, x, extras = list(group = group))
}

complexity.cv.grpsurv <- function(response, x, full.data, group, ...) {
   .require_suggested_package("grpreg", "complexity.cv.grpsurv()")
   fit_response <- if (.peperr_is_survival_response(response)) .peperr_surv_object(response) else response

   if (missing(group)) {
      stop("complexity.cv.grpsurv() requires a 'group' vector.", call. = FALSE)
   }

   cvfit <- grpreg::cv.grpsurv(
      X = as.matrix(x),
      y = fit_response,
      group = group,
      ...
   )

   as.numeric(cvfit$lambda.min)
}
