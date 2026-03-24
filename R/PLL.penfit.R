PLL.penfit <- function(object, newdata, newtime, newstatus, complexity = NULL, ...) {
   lp <- drop(as.matrix(newdata) %*% object@penalized)

   .peperr_pll_from_linear_predictor(
      linear.predictor = lp,
      time = newtime,
      status = newstatus
   )
}
