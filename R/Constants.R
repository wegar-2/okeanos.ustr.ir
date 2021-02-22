lUrlDict <- list(
  "YieldCurveRates" = "http://data.treasury.gov/feed.svc/DailyTreasuryYieldCurveRateData?$filter=year(NEW_DATE)%20eq%20",
  "BillRates" = "http://data.treasury.gov/feed.svc/DailyTreasuryBillRateData?$filter=year(INDEX_DATE)%20eq%20",
  "LongTermRates" = "http://data.treasury.gov/feed.svc/DailyTreasuryLongTermRateData?$filter=year(QUOTE_DATE)%20eq%20"
)

lQuoteDateColname <- list(
  "YieldCurveRates" = "//d:NEW_DATE",
  "BillRates" = "//d:INDEX_DATE",
  "LongTermRates" = "//d:QUOTE_DATE"
)


lYieldCurveRatesGridDict <- list(
  "YCR_M1" = "//d:BC_1MONTH", "YCR_M2" = "//d:BC_2MONTH",
  "YCR_M3" = "//d:BC_3MONTH", "YCR_M6" = "//d:BC_6MONTH",
  "YCR_Y1" = "//d:BC_1YEAR", "YCR_Y2" = "//d:BC_2YEAR",
  "YCR_Y3" = "//d:BC_3YEAR", "YCR_Y5" = "//d:BC_5YEAR",
  "YCR_Y7" = "//d:BC_7YEAR", "YCR_Y10" = "//d:BC_10YEAR",
  "YCR_Y20" = "//d:BC_20YEAR", "YCR_Y30" = "//d:BC_30YEAR")

lBillRatesGridDict <- list(
  "BR_ROUND_B1_CLOSE_4WK_2" = "//d:ROUND_B1_CLOSE_4WK_2",
  "BR_ROUND_B1_YIELD_4WK_2" = "//d:ROUND_B1_YIELD_4WK_2",
  "BR_ROUND_B1_CLOSE_8WK_2" = "//d:ROUND_B1_CLOSE_8WK_2",
  "BR_ROUND_B1_YIELD_8WK_2" = "//d:ROUND_B1_YIELD_8WK_2",
  "BR_ROUND_B1_CLOSE_13WK_2" = "//d:ROUND_B1_CLOSE_13WK_2",
  "BR_ROUND_B1_YIELD_13WK_2" = "//d:ROUND_B1_YIELD_13WK_2",
  "BR_ROUND_B1_CLOSE_26WK_2" = "//d:ROUND_B1_CLOSE_26WK_2",
  "BR_ROUND_B1_YIELD_26WK_2" = "//d:ROUND_B1_YIELD_26WK_2",
  "BR_ROUND_B1_CLOSE_52WK_2" = "//d:ROUND_B1_CLOSE_52WK_2",
  "BR_ROUND_B1_YIELD_52WK_2" = "//d:ROUND_B1_YIELD_52WK_2"
)

lLongTermRatesGridDict <- list(
  "LTR_RateType" = "//d:RATE_TYPE",
  "LTR_RateValue" = "//d:RATE"
)



lXmlColsGridDict <- list(
  "YieldCurveRates" = lYieldCurveRatesGridDict,
  "BillRates" = lBillRatesGridDict,
  "LongTermRates" = lLongTermRatesGridDict
)
