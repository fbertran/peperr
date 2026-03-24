PLL.mboost_coxph <- function(object, newdata, newtime, newstatus, complexity = NULL, ...) {
   .require_suggested_package("mboost", "PLL.mboost_coxph()")

   lp <- stats::predict(
      object,
      newdata = as.data.frame(newdata),
      type = "link",
      ...
   )

   .peperr_pll_from_linear_predictor(
      linear.predictor = lp,
      time = newtime,
      status = newstatus
   )
}
