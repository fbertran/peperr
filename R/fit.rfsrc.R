fit.rfsrc <- function(response, x, cplx, ...) {
   .require_suggested_package("randomForestSRC", "fit.rfsrc()")

   fit_args <- c(
      list(
         formula = survival::Surv(time, status) ~ .,
         data = .peperr_survival_dataframe(response, x)
      ),
      if (is.list(cplx)) {
         cplx
      } else if (.peperr_is_missing_complexity(cplx)) {
         list()
      } else {
         list(mtry = cplx)
      },
      list(...)
   )

   res <- do.call(randomForestSRC::rfsrc, fit_args)
   .peperr_store_training_context(res, response, x)
}

complexity.oob.rfsrc <- function(response, x, full.data, mtry = unique(pmax(1L, c(floor(sqrt(ncol(x))), floor(ncol(x)/3), ncol(x)))), nodesize = c(5L, 15L), ntree = 200L, ...) {
   .require_suggested_package("randomForestSRC", "complexity.oob.rfsrc()")

   grid <- expand.grid(
      mtry = as.integer(mtry),
      nodesize = as.integer(nodesize),
      KEEP.OUT.ATTRS = FALSE
   )

   data <- .peperr_survival_dataframe(response, x)
   err <- vapply(
      seq_len(nrow(grid)),
      function(i) {
         fit <- randomForestSRC::rfsrc(
            formula = survival::Surv(time, status) ~ .,
            data = data,
            ntree = ntree,
            mtry = grid$mtry[i],
            nodesize = grid$nodesize[i],
            ...
         )

         as.numeric(fit$err.rate[length(fit$err.rate)])
      },
      numeric(1)
   )

   best <- which.min(err)
   list(mtry = grid$mtry[best], nodesize = grid$nodesize[best])
}
