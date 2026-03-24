PLL.coxnet <- function(object, newdata, newtime, newstatus, complexity = NULL, ...) {
   .require_suggested_package("glmnet", "PLL.coxnet()")

   lambda <- .peperr_complexity_value(
      complexity = complexity,
      default = attr(object, "peperr_lambda"),
      caller = "PLL.coxnet()"
   )

   lp <- stats::predict(
      object,
      newx = as.matrix(newdata),
      s = lambda,
      type = "link",
      ...
   )

   .peperr_pll_from_linear_predictor(
      linear.predictor = lp,
      time = newtime,
      status = newstatus
   )
}
