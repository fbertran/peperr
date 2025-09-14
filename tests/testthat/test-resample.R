
test_that("resample.indices returns consistent structures for CV and boot", {
  set.seed(123)
  n <- 20

  # CV with 5 folds
  cv <- resample.indices(n = n, sample.n = 5, method = "cv")
  expect_true(is.list(cv) && all(c("sample.index","not.in.sample") %in% names(cv)))
  expect_length(cv$sample.index, 5)
  expect_length(cv$not.in.sample, 5)
  # Each fold: OOB indices are disjoint and cover [1..n] with complements in sample.index
  all_oob <- sort(unique(unlist(cv$not.in.sample)))
  expect_equal(all_oob, 1:n)
  for (i in seq_along(cv$not.in.sample)) {
    expect_length(intersect(cv$sample.index[[i]], cv$not.in.sample[[i]]), 0L)
    expect_setequal(sort(c(cv$sample.index[[i]], cv$not.in.sample[[i]])), 1:n)
  }

  # Bootstrap: in-bag length n, OOB may be empty but average size > 0
  bt <- resample.indices(n = n, sample.n = 10, method = "boot")
  expect_true(is.list(bt) && length(bt$sample.index) == 10 && length(bt$not.in.sample) == 10)
  for (i in seq_along(bt$sample.index)) {
    expect_length(bt$sample.index[[i]], n)
    expect_true(all(bt$sample.index[[i]] >= 1 & bt$sample.index[[i]] <= n))
    expect_true(all(bt$not.in.sample[[i]] >= 1 & bt$not.in.sample[[i]] <= n))
  }
})
