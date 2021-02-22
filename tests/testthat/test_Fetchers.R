
testthat::test_that(desc = "testing function 'dtFetchUsTreasuryYieldCurveDataForYear'", code = {

  # 1. testing for "YieldCurveRates" -------------------------------------------
  testthat::expect_equal(
    object = class(dtFetchUsTreasuryYieldCurveDataForYear(iYear = 2018L, cDataType = "YieldCurveRates")),
    expected = c("data.table", "data.frame"))
  testthat::expect_equal(
    object = suppressWarnings(expr = dtFetchUsTreasuryYieldCurveDataForYear(
      iYear = 1989L, cDataType = "YieldCurveRates")),
    expected = list(NULL))

  # 2. testing for "BillRates" -------------------------------------------------
  testthat::expect_equal(
    object = class(dtFetchUsTreasuryYieldCurveDataForYear(iYear = 2018L, cDataType = "BillRates")),
    expected = c("data.table", "data.frame"))
  testthat::expect_equal(
    object = suppressWarnings(expr = dtFetchUsTreasuryYieldCurveDataForYear(
      iYear = 1989L, cDataType = "BillRates")),
    expected = list(NULL))

  # 3. testing for "LongTermRates" ---------------------------------------------
  testthat::expect_equal(
    object = class(dtFetchUsTreasuryYieldCurveDataForYear(iYear = 2018L, cDataType = "BillRates")),
    expected = c("data.table", "data.frame"))
  testthat::expect_equal(
    object = suppressWarnings(expr = dtFetchUsTreasuryYieldCurveDataForYear(
      iYear = 1989L, cDataType = "BillRates")),
    expected = list(NULL))

  # 4. testing if error thrown where expected ----------------------------------
  testthat::expect_error(
    object = dtFetchUsTreasuryYieldCurveDataForYear(iYear = 1989, cDataType = "BillRates"),
    regexp = "iYear is not an integer")
  testthat::expect_error(
    object = dtFetchUsTreasuryYieldCurveDataForYear(iYear = 1989L, cDataType = "qwerty"),
    regexp = "should be one of")

})

