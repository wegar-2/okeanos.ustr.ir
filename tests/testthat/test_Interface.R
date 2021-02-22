
testthat::test_that(desc = "testing 'dtFetchUsTreasuryYieldCurveData' function ... ", code = {

  # 1. testing for "YieldCurveRates" -------------------------------------------
  testthat::expect_equal(
    object = class(dtFetchUsTreasuryYieldCurveData(cDataType = "YieldCurveRates",
                                             dateStartDate = as.Date("2003-03-01"),
                                             dateEndDate = as.Date("2007-04-11"))),
    expected = c("data.table", "data.frame"))
  testthat::expect_equal(
    object = suppressWarnings(
        expr = dtFetchUsTreasuryYieldCurveData(
          cDataType = "YieldCurveRates", dateStartDate = as.Date("1987-03-01"),
          dateEndDate = as.Date("1989-04-11"))), expected = list(NULL))

  # 2. testing for "BillRates" -------------------------------------------------
  testthat::expect_equal(
    object = class(dtFetchUsTreasuryYieldCurveData(cDataType = "BillRates",
                                                   dateStartDate = as.Date("2003-03-01"),
                                                   dateEndDate = as.Date("2007-04-11"))),
    expected = c("data.table", "data.frame"))
  testthat::expect_equal(
    object = suppressWarnings(
      expr = dtFetchUsTreasuryYieldCurveData(
        cDataType = "BillRates", dateStartDate = as.Date("1987-03-01"),
        dateEndDate = as.Date("1989-04-11"))), expected = list(NULL))

  # 3. testing for "LongTermRates" ---------------------------------------------
  testthat::expect_equal(
    object = class(dtFetchUsTreasuryYieldCurveData(cDataType = "LongTermRates",
                                                   dateStartDate = as.Date("2003-03-01"),
                                                   dateEndDate = as.Date("2007-04-11"))),
    expected = c("data.table", "data.frame"))
  testthat::expect_equal(
    object = suppressWarnings(
      expr = dtFetchUsTreasuryYieldCurveData(
        cDataType = "LongTermRates", dateStartDate = as.Date("1987-03-01"),
        dateEndDate = as.Date("1989-04-11"))), expected = list(NULL))

  # 4. testing if error thrown where expected ----------------------------------
  testthat::expect_error(
    object = dtFetchUsTreasuryYieldCurveData(
      cDataType = "LongTermRates", dateStartDate = as.Date("2018-01-03"),
      dateEndDate = as.Date("2017-01-03")),
    regexp = "parameter dateEndDate")
  testthat::expect_error(
    object = dtFetchUsTreasuryYieldCurveData(
      cDataType = "asdfqwer", dateStartDate = as.Date("2015-01-03"),
      dateEndDate = as.Date("2017-01-03")),
    regexp = "should be one of")
  testthat::expect_error(
    object = dtFetchUsTreasuryYieldCurveData(
      cDataType = "LongTermRates", dateStartDate = "qwerty",
      dateEndDate = as.Date("2017-01-03")),
    regexp = "is not Date class scalar")
  testthat::expect_error(
    object = dtFetchUsTreasuryYieldCurveData(
      cDataType = "LongTermRates", dateStartDate = as.Date("2017-01-03"),
      dateEndDate = "qwerty"),
    regexp = "is not Date class scalar")

})
