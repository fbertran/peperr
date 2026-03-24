.complexity_bootstrap_coxboost <- function(response, x, boot.n.c = 10,
   boost.steps = 100, eval.times = NULL, smooth = FALSE, full.data,
   integral = c("km", "riemann"), ...)
{
   .require_suggested_package("CoxBoost", "CoxBoost complexity selection")
   if (smooth) {
      .require_suggested_package("locfit", "smoothed CoxBoost complexity selection")
   }

   integral <- match.arg(integral)
   actual.data.c <- as.data.frame(x)
   time <- response[, "time"]
   status <- response[, "status"]
   actual.data.c$time <- time
   actual.data.c$status <- status

   n.c <- length(time)
   boot.index.c <- matrix(
      sapply(seq_len(boot.n.c), function(b) sample.int(n.c, replace = TRUE)),
      byrow = TRUE,
      nrow = boot.n.c,
      ncol = n.c
   )
   not.in.sample.c <- vector("list", boot.n.c)
   for (i in seq_len(boot.n.c)) {
      not.in.sample.c[[i]] <- setdiff(seq_len(n.c), unique(boot.index.c[i, ]))
   }

   uncens <- which(status == 1)
   if (is.null(eval.times)) {
      if (length(unique(time[uncens])) < 100) {
         w.eval.times.c <- c(0, sort(time[uncens]))
      } else {
         w.quantile <- 90
         space <- round(length(time[uncens]) / 100)
         index <- (1:w.quantile) * space
         w.eval.times.c <- c(0, sort(time[uncens])[index[index < length(time[uncens])]])
      }
   } else {
      w.eval.times.c <- sort(eval.times)
   }
   w.eval.times.c <- unique(w.eval.times.c)

   if (integral == "km") {
      km.fit <- survfit(Surv(time, status) ~ 1, data = actual.data.c)
      km.pred <- summary(object = km.fit, times = w.eval.times.c)$surv
      km.weight <- -1 * diff(km.pred)
   }

   fullcoxboost <- .coxboost_fit_call(
      time = time,
      status = status,
      x = x,
      cplx = list(stepno = boost.steps),
      ...
   )

   w.full.apparent <- matrix(NA, nrow = boost.steps, ncol = length(w.eval.times.c))
   w.noinf.error <- matrix(NA, nrow = boost.steps, ncol = length(w.eval.times.c))

   for (m in seq_len(boost.steps)) {
      pe.w.full.apparent <- pmpec(
         object = fullcoxboost,
         data = actual.data.c,
         times = w.eval.times.c,
         model.args = list(complexity = m),
         external.time = full.data$time,
         external.status = full.data$status
      )
      w.full.apparent[m, ] <- pe.w.full.apparent

      pe.w.noinf.error <- pmpec(
         object = fullcoxboost,
         data = actual.data.c,
         times = w.eval.times.c,
         model.args = list(complexity = m),
         external.time = full.data$time,
         external.status = full.data$status,
         type = "NoInf"
      )
      w.noinf.error[m, ] <- pe.w.noinf.error
   }

   w.boot.error.wo <- array(dim = c(boost.steps, boot.n.c, length(w.eval.times.c)))

   for (actual.boot in seq_len(boot.n.c)) {
      oob_index <- not.in.sample.c[[actual.boot]]
      if (length(oob_index) == 0L) {
         next
      }

      boot.fit <- .coxboost_fit_call(
         time = time[boot.index.c[actual.boot, ]],
         status = status[boot.index.c[actual.boot, ]],
         x = x[boot.index.c[actual.boot, ], , drop = FALSE],
         cplx = list(stepno = boost.steps),
         ...
      )

      for (m in seq_len(boost.steps)) {
         w.pec.boot <- pmpec(
            object = boot.fit,
            data = actual.data.c[oob_index, , drop = FALSE],
            times = w.eval.times.c,
            model.args = list(complexity = m),
            external.time = full.data$time,
            external.status = full.data$status
         )
         w.boot.error.wo[m, actual.boot, ] <- w.pec.boot
      }
   }

   w.mean.boot.error.wo <- apply(w.boot.error.wo, c(1, 3), mean, na.rm = TRUE)
   w.boot632p.error.wo <- matrix(NA, nrow = boost.steps, ncol = length(w.eval.times.c))

   for (m in seq_len(boost.steps)) {
      w.relative.overfit.wo <- ifelse(
         w.noinf.error[m, ] > w.full.apparent[m, ],
         (
            ifelse(
               w.mean.boot.error.wo[m, ] < w.noinf.error[m, ],
               w.mean.boot.error.wo[m, ],
               w.noinf.error[m, ]
            ) - w.full.apparent[m, ]
         ) / (w.noinf.error[m, ] - w.full.apparent[m, ]),
         0
      )
      w.weights <- .632 / (1 - .368 * w.relative.overfit.wo)

      w.boot632p.error.wo[m, ] <- (1 - w.weights) * w.full.apparent[m, ] +
         w.weights * ifelse(
            w.mean.boot.error.wo[m, ] < w.noinf.error[m, ],
            w.mean.boot.error.wo[m, ],
            w.noinf.error[m, ]
         )
   }

   w.boot632p.error.smooth <- matrix(
      NA,
      ncol = length(w.eval.times.c),
      nrow = boost.steps
   )

   if (smooth) {
      for (i in seq_len(boost.steps)) {
         smoothdata <- data.frame(w.eval.times.c = w.eval.times.c)
         smoothdata$error <- w.boot632p.error.wo[i, ]
         smoother <- locfit::locfit(error ~ locfit::lp(w.eval.times.c), smoothdata)
         w.boot632p.error.smooth[i, ] <- predict(object = smoother, newdata = w.eval.times.c)
      }
   } else {
      w.boot632p.error.smooth <- w.boot632p.error.wo
   }

   if (integral == "km") {
      integrated.error <- apply(
         t(w.boot632p.error.smooth[, seq_along(km.weight), drop = FALSE]) * km.weight,
         2,
         sum
      )
   } else {
      integrated.error <- apply(
         t(w.boot632p.error.smooth[, seq_len(ncol(w.boot632p.error.smooth) - 1L), drop = FALSE]) *
            diff(w.eval.times.c),
         2,
         sum
      )
   }

   which.min(integrated.error)
}

complexity.ipec.CoxBoost <- function(response, x, boot.n.c = 10,
   boost.steps = 100, eval.times = NULL, smooth = FALSE, full.data, ...)
{
   .complexity_bootstrap_coxboost(
      response = response,
      x = x,
      boot.n.c = boot.n.c,
      boost.steps = boost.steps,
      eval.times = eval.times,
      smooth = smooth,
      full.data = full.data,
      integral = "km",
      ...
   )
}

complexity.ripec.CoxBoost <- function(response, x, boot.n.c = 10,
   boost.steps = 100, eval.times = NULL, smooth = FALSE, full.data, ...)
{
   .complexity_bootstrap_coxboost(
      response = response,
      x = x,
      boot.n.c = boot.n.c,
      boost.steps = boost.steps,
      eval.times = eval.times,
      smooth = smooth,
      full.data = full.data,
      integral = "riemann",
      ...
   )
}
