test_that("exported symbols exist and are callable or data", {
  ns <- asNamespace("peperr")
  ex <- getNamespaceExports("peperr")
  expect_type(ex, "character")
  # Ignore S3 method markers like 'print.foo' if any; still should exist as functions
  missing <- character(0)
  for (nm in ex) {
    if (!exists(nm, envir = ns, inherits = FALSE)) missing <- c(missing, nm)
  }
  expect(length(missing) == 0,
         failure_message = paste("Dangling exports in NAMESPACE:", paste(missing, collapse = ", ")))
})
