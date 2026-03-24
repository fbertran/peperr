PLL.ncvsurv <- function(object, newdata, newtime, newstatus, complexity = NULL, ...) {
   .require_suggested_package("ncvreg", "PLL.ncvsurv()")

   lambda <- .ncvsurv_lambda(object, complexity, "PLL.ncvsurv()")
   lp <- stats::predict(
      object,
      X = as.matrix(newdata),
      type = "link",
      lambda = lambda,
      ...
   )

   .peperr_pll_from_linear_predictor(
      linear.predictor = lp,
      time = newtime,
      status = newstatus
   )
}
