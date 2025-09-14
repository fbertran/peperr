test_that("package loads quietly", {
  expect_silent(suppressPackageStartupMessages(library(peperr)))

  # Ensure namespace is loaded
  expect_true(isNamespaceLoaded("peperr"))

  # Detach if attached (avoid side effects)
  if (paste0("package:peperr") %in% search()) {
    detach(paste0("package:peperr"), unload = TRUE, character.only = TRUE)
  }
})
