test_that("basic package metadata is sane", {
  dcf <- read.dcf(system.file("DESCRIPTION", package = "peperr"))
  expect_true(ncol(dcf) > 0L)
  expect_true(any(colnames(dcf) == "Package"))
  expect_identical(dcf[1L, "Package"], c(Package="peperr"))
  # NAMESPACE should be readable
  nsfile <- system.file("NAMESPACE", package = "peperr")
  if (file.exists(nsfile)) {
    ns_txt <- readLines(nsfile, warn = FALSE)
    expect_true(length(ns_txt) > 0L)
  } else {
    skip("No NAMESPACE found in installed package (unusual).")
  }
})
