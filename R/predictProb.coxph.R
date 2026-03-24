predictProb.coxph <- function (object, response, x, times, ...)
{
    newdata <- .peperr_survival_dataframe(response, x)
    survival.survfit.coxph <- getFromNamespace("survfit.coxph",
        ns = "survival")
    survfit.object <- survival.survfit.coxph(object, newdata = newdata,
        se.fit = FALSE, conf.int = FALSE)
    .peperr_survfit_to_matrix(
        survfit_object = survfit.object,
        times = times,
        nobs = NROW(newdata)
    )
}
