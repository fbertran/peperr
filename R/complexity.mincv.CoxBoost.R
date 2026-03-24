complexity.mincv.CoxBoost <- function(response, x, full.data, ...){
   .require_suggested_package("CoxBoost", "complexity.mincv.CoxBoost()")

   time <- response[, "time"]
   status <- response[, "status"]

   cv.res <- CoxBoost::cv.CoxBoost(time = time, status = status, x = x, ...)

   cv.res$optimal.step
}
