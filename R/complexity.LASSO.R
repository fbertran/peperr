complexity.cv.penalized <- function(response, x, full.data, ...) {
   .require_suggested_package("penalized", "complexity.cv.penalized()")
   fit_response <- if (.peperr_is_survival_response(response)) .peperr_surv_object(response) else response

   prof <- penalized::profL1(
      response = fit_response,
      penalized = x,
      trace = FALSE,
      ...
   )

   prof$lambda[which.max(prof$cvl)]
}

complexity.LASSO <- function(response, x, full.data, ...) {
   complexity.cv.penalized(response = response, x = x, full.data = full.data, ...)
}

complexity.fusedLASSO <- function(response, x, full.data, ...) {
   complexity.cv.penalized(
      response = response,
      x = x,
      full.data = full.data,
      fusedl = TRUE,
      ...
   )
}
