test_that("reference examples run (donttest allowed)", {
  skip_on_cran()
  # Some packages ship incomplete/corrupt help during development; skip gracefully.
  db <- try(tools::Rd_db("peperr"), silent = TRUE)
  if (inherits(db, "try-error")) skip("No Rd_db available or help is corrupt; skipping examples.")
  topics <- names(db)
  # Limit to a handful to avoid long runs
  topics <- unique(stats::na.omit(topics))
  if (length(topics) == 0) skip("No topics found in Rd_db.")
  # Try up to 10 topics
  topics <- head(topics, 10L)
  for (tp in topics) {
    expect_error(
      suppressWarnings(suppressMessages(
        example(topic = tp, package = "peperr", character.only = TRUE,
                run.donttest = TRUE, give.lines = FALSE, echo = FALSE)
      )),
      NA
    )
  }
})
