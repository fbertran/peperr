PLL.grpsurv <- function(object, newdata, newtime, newstatus, complexity = NULL, ...) {
   .require_suggested_package("grpreg", "PLL.grpsurv()")

   lambda <- .peperr_complexity_value(
      complexity = complexity,
      default = attr(object, "peperr_lambda"),
      caller = "PLL.grpsurv()"
   )

   lp <- if (length(object$lambda) > 1L) {
      stats::predict(
         object,
         X = as.matrix(newdata),
         type = "link",
         lambda = lambda,
         ...
      )
   } else {
      stats::predict(
         object,
         X = as.matrix(newdata),
         type = "link",
         ...
      )
   }

   .peperr_pll_from_linear_predictor(
      linear.predictor = lp,
      time = newtime,
      status = newstatus
   )
}
