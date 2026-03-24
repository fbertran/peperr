.SGL_lambda_value <- function(object, complexity, caller) {
   lambda <- .peperr_complexity_value(
      complexity = complexity,
      default = attr(object, "peperr_lambda"),
      caller = caller
   )

   as.numeric(lambda)[1L]
}

.SGL_lambda_index <- function(object, complexity, caller) {
   lambda <- .SGL_lambda_value(object, complexity, caller)
   .peperr_nearest_index(object$lambdas, lambda, caller)
}

.SGL_prepare_newx <- function(object, newX) {
   X <- as.matrix(newX)
   X <- t(t(X) - object$X.transform$X.means)

   if (!is.null(object$X.transform$X.scale)) {
      X <- t(t(X) / object$X.transform$X.scale)
   }

   X
}

.SGL_linear_predictor <- function(object, newX, complexity, caller) {
   X <- .SGL_prepare_newx(object, newX)
   beta <- object$beta

   if (is.matrix(beta)) {
      beta <- beta[, .SGL_lambda_index(object, complexity, caller), drop = FALSE]
      return(drop(X %*% beta))
   }

   drop(X %*% beta)
}

fit.SGL.cox <- function(response, x, cplx, index, ...) {
   .require_suggested_package("SGL", "fit.SGL.cox()")

   if (missing(index)) {
      stop("fit.SGL.cox() requires an 'index' vector.", call. = FALSE)
   }

   surv <- .peperr_survival_response(response)
   data <- list(
      x = as.matrix(x),
      time = surv[, "time"],
      status = surv[, "status"]
   )

   fit_args <- c(
      list(
         data = data,
         index = index,
         type = "cox"
      ),
      if (.peperr_is_missing_complexity(cplx)) {
         list()
      } else {
         list(lambdas = cplx)
      },
      list(...)
   )

   res <- do.call(SGL::SGL, fit_args)
   class(res) <- c("SGL_cox", class(res))
   attr(res, "peperr_lambda") <- if (.peperr_is_missing_complexity(cplx)) NULL else as.numeric(cplx)[1L]
   .peperr_store_training_context(res, response, x, extras = list(index = index))
}

complexity.cvSGL.cox <- function(response, x, full.data, index, ...) {
   .require_suggested_package("SGL", "complexity.cvSGL.cox()")

   if (missing(index)) {
      stop("complexity.cvSGL.cox() requires an 'index' vector.", call. = FALSE)
   }

   surv <- .peperr_survival_response(response)
   data <- list(
      x = as.matrix(x),
      time = surv[, "time"],
      status = surv[, "status"]
   )

   cvfit <- do.call(
      SGL::cvSGL,
      c(list(data = data, index = index, type = "cox"), list(...))
   )

   as.numeric(cvfit$lambdas[which.max(cvfit$lldiff)])
}
