PLL.SGL_cox <- function(object, newdata, newtime, newstatus, complexity = NULL, ...) {
   .require_suggested_package("SGL", "PLL.SGL_cox()")

   lp <- .SGL_linear_predictor(object, newdata, complexity, "PLL.SGL_cox()")

   .peperr_pll_from_linear_predictor(
      linear.predictor = lp,
      time = newtime,
      status = newstatus
   )
}
