fit.CoxBoost <- function(response, x, cplx, ...){
   .require_suggested_package("CoxBoost", "fit.CoxBoost()")

   time <- response[, "time"]
   status <- response[, "status"]

   .coxboost_fit_call(time = time, status = status, x = x, cplx = cplx, ...)
}
