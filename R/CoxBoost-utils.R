.require_suggested_package <- function(package, caller) {
   if (!requireNamespace(package, quietly = TRUE)) {
      stop(
         sprintf(
            "Package '%s' is required for %s. Install it with install.packages('%s').",
            package,
            caller,
            package
         ),
         call. = FALSE
      )
   }

   invisible(TRUE)
}

.coxboost_stepno <- function(complexity, caller) {
   if (is.list(complexity)) {
      if (is.null(complexity$stepno)) {
         stop(
            sprintf(
               "%s requires a list complexity with a 'stepno' element.",
               caller
            ),
            call. = FALSE
         )
      }

      return(complexity$stepno)
   }

   complexity
}

.coxboost_fit_call <- function(time, status, x, cplx, ...) {
   fit_args <- c(
      list(time = time, status = status, x = x),
      if (is.list(cplx)) cplx else list(stepno = cplx),
      list(...)
   )

   do.call(CoxBoost::CoxBoost, fit_args)
}
