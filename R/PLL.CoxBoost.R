PLL.CoxBoost <- function(object, newdata, newtime, newstatus, complexity, ...){
   .require_suggested_package("CoxBoost", "PLL.CoxBoost()")

   predict(
      object,
      type = "logplik",
      newdata = newdata,
      newtime = newtime,
      newstatus = newstatus,
      at.step = .coxboost_stepno(complexity, "PLL.CoxBoost()"),
      ...
   )
}
