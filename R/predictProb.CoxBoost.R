predictProb.CoxBoost <- function(object, response, x, times, complexity, ...)
{
    .require_suggested_package("CoxBoost", "predictProb.CoxBoost()")

    predict(
        object,
        type = "risk",
        newdata = x,
        times = times,
        at.step = .coxboost_stepno(complexity, "predictProb.CoxBoost()"),
        ...
    )
}
