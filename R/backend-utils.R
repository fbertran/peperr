.peperr_is_survival_response <- function(response) {
   is.Surv(response) ||
      (is.matrix(response) &&
         ncol(response) >= 2L &&
         all(c("time", "status") %in% colnames(response)))
}

.peperr_survival_response <- function(response) {
   surv <- as.matrix(response)

   if (ncol(surv) < 2) {
      stop("Survival responses must provide time and status columns.", call. = FALSE)
   }

   surv <- surv[, 1:2, drop = FALSE]
   colnames(surv) <- c("time", "status")
   surv
}

.peperr_surv_object <- function(response) {
   if (is.Surv(response)) {
      return(response)
   }

   surv <- .peperr_survival_response(response)
   survival::Surv(time = surv[, "time"], event = surv[, "status"])
}

.peperr_survival_dataframe <- function(response, x) {
   surv <- .peperr_survival_response(response)
   data <- as.data.frame(x)
   data$time <- surv[, "time"]
   data$status <- surv[, "status"]
   data
}

.peperr_store_training_context <- function(object, response, x, extras = NULL) {
   context <- c(
      list(
         response = .peperr_survival_response(response),
         x = as.matrix(x)
      ),
      extras
   )

   attr(object, "peperr_training_context") <- context
   object
}

.peperr_training_context <- function(object, caller) {
   context <- attr(object, "peperr_training_context")

   if (is.null(context$response) || is.null(context$x)) {
      stop(
         sprintf(
            "%s requires a model fitted through peperr so training data are available.",
            caller
         ),
         call. = FALSE
      )
   }

   context
}

.peperr_survfit_to_matrix <- function(survfit_object, times, nobs) {
   inflated.pred <- summary(survfit_object, times = times, extend = TRUE)
   surv <- inflated.pred$surv

   if (is.null(surv)) {
      stop("Prediction failed", call. = FALSE)
   }

   surv <- as.matrix(surv)

   if (nrow(surv) == length(times) && ncol(surv) == nobs) {
      p <- t(surv)
   } else if (nrow(surv) == nobs && ncol(surv) == length(times)) {
      p <- surv
   } else if (length(surv) == nobs * length(times)) {
      p <- matrix(as.numeric(surv), nrow = nobs, byrow = TRUE)
   } else if (length(surv) == length(times)) {
      p <- matrix(rep(as.numeric(surv), each = nobs), nrow = nobs)
   } else if (nobs == 1L && length(surv) == length(times)) {
      p <- matrix(as.numeric(surv), nrow = 1L)
   } else {
      stop("Prediction failed", call. = FALSE)
   }

   if ((miss.time <- (length(times) - NCOL(p))) > 0) {
      p <- cbind(
         p,
         matrix(NA_real_, nrow = NROW(p), ncol = miss.time)
      )
   }

   if (NROW(p) != nobs || NCOL(p) != length(times)) {
      stop("Prediction failed", call. = FALSE)
   }

   p
}

.peperr_step_curve_matrix <- function(curves, curve_times, eval_times, default = 1) {
   curves <- as.matrix(curves)
   curve_times <- as.numeric(curve_times)
   eval_times <- as.numeric(eval_times)

   if (ncol(curves) != length(curve_times)) {
      stop("Curve matrix and curve times do not align.", call. = FALSE)
   }

   ord <- order(curve_times)
   curve_times <- curve_times[ord]
   curves <- curves[, ord, drop = FALSE]

   keep <- !duplicated(curve_times, fromLast = TRUE)
   curve_times <- curve_times[keep]
   curves <- curves[, keep, drop = FALSE]

   idx <- findInterval(eval_times, curve_times)
   res <- matrix(default, nrow = nrow(curves), ncol = length(eval_times))

   for (j in seq_along(eval_times)) {
      if (idx[j] > 0L) {
         res[, j] <- curves[, idx[j]]
      }
   }

   res
}

.peperr_step_functions_to_matrix <- function(curve_functions, curve_times, eval_times) {
   if (is.function(curve_functions)) {
      curve_functions <- list(curve_functions)
   }

   curve_values <- t(vapply(
      curve_functions,
      function(fun) fun(curve_times),
      numeric(length(curve_times))
   ))

   .peperr_step_curve_matrix(
      curves = curve_values,
      curve_times = curve_times,
      eval_times = eval_times
   )
}

.peperr_breslow_baseline <- function(time, status, linear.predictor) {
   event_times <- sort(unique(time[status != 0]))

   if (!length(event_times)) {
      return(list(time = numeric(0), cumhaz = numeric(0)))
   }

   risk_score <- exp(as.numeric(linear.predictor))
   increments <- vapply(
      event_times,
      function(actual.time) {
         deaths <- sum(status != 0 & time == actual.time)
         at_risk <- sum(risk_score[time >= actual.time])
         deaths / at_risk
      },
      numeric(1)
   )

   list(time = event_times, cumhaz = cumsum(increments))
}

.peperr_breslow_survival <- function(train_time, train_status, train_lp, new_lp, times) {
   baseline <- .peperr_breslow_baseline(
      time = train_time,
      status = train_status,
      linear.predictor = train_lp
   )

   if (!length(baseline$time)) {
      return(matrix(1, nrow = length(new_lp), ncol = length(times)))
   }

   idx <- findInterval(times, baseline$time)
   cumhaz <- numeric(length(times))

   if (any(idx > 0L)) {
      cumhaz[idx > 0L] <- baseline$cumhaz[idx[idx > 0L]]
   }

   exp(-outer(exp(as.numeric(new_lp)), cumhaz))
}

.peperr_pll_from_linear_predictor <- function(linear.predictor, time, status) {
   linear.predictor <- as.matrix(linear.predictor)

   if (nrow(linear.predictor) != length(time)) {
      stop("Linear predictor length does not match survival outcome.", call. = FALSE)
   }

   logplik(
      x = linear.predictor,
      time = time,
      status = status,
      b = matrix(1, nrow = ncol(linear.predictor), ncol = 1L)
   )
}

.peperr_has_PLL_method <- function(object) {
   any(vapply(
      class(object),
      function(class_name) {
         exists(
            paste("PLL.", class_name, sep = ""),
            mode = "function",
            inherits = TRUE
         )
      },
      logical(1)
   ))
}

.peperr_complexity_value <- function(complexity, name = NULL, default = NULL, caller = "This function") {
   if (is.list(complexity)) {
      if (!is.null(name) && !is.null(complexity[[name]])) {
         return(complexity[[name]])
      }

      if (is.null(name) && length(complexity) >= 1L) {
         return(complexity[[1L]])
      }
   } else if (is.null(name)) {
      return(complexity)
   }

   if (!is.null(default)) {
      return(default)
   }

   if (is.null(name)) {
      stop(sprintf("%s requires a complexity value.", caller), call. = FALSE)
   }

   stop(
      sprintf("%s requires a '%s' complexity component.", caller, name),
      call. = FALSE
   )
}

.peperr_is_missing_complexity <- function(complexity) {
   is.null(complexity) || (length(complexity) == 1L && identical(complexity, 0))
}

.peperr_nearest_index <- function(values, target, caller) {
   if (!length(values)) {
      stop(sprintf("%s requires at least one fitted tuning value.", caller), call. = FALSE)
   }

   which.min(abs(values - target))
}
