#' Fetch the US Treasury Data
#'
#' Fetching nominal interest rates published by US Treasury
#'
#' This function fetches the historical time series of nominal interest rates
#' as published by US Treasury at the site:
#' As only the nominal interest rates are handled, the following data types
#' are available (cf. parameter cDataType): 1) Yield Curve Rates,
#' 2) Bill Rates and 3) Long-Term Rates
#' @param cDataType - character scalar, one of the following three values:
#' "YieldCurveRates", "BillRates", "LongTermRates"
#' @param dateStartDate - class 'Date' scalar
#' @param dateEndDate - class 'Date' scalar; function checks if the dateEndDate
#' precedes dateStartDate and throws an error should this be the case
#' @export
dtFetchUsTreasuryYieldCurveData <- function(cDataType = "YieldCurveRates",
                                            dateStartDate, dateEndDate) {

  # 1. parameters validation ---------------------------------------------------
  # ----- 1.1. validate cDataType -----
  cDataType <- match.arg(arg = cDataType,
            choices = c("YieldCurveRates", "BillRates", "LongTermRates"),
            several.ok = FALSE)
  # ----- 1.2. dateStartDate -----
  if (!bIsScalarOfClass(objIn = dateStartDate, cClassName = "Date")) {
    stop("ERROR: function dtFetchUsTreasuryYieldCurveData parameter dateStartDate ",
         "is not Date class scalar! ")
  }
  # ----- 1.3. dateEndDate -----
  if (!bIsScalarOfClass(objIn = dateEndDate, cClassName = "Date")) {
    stop("ERROR: function dtFetchUsTreasuryYieldCurveData parameter dateEndDate ",
         "is not Date class scalar! ")
  }
  # ----- 1.4. dateStartDate vs. dateEndDate -----
  if (dateEndDate < dateStartDate) {
    stop("ERROR: function dtFetchUsTreasuryYieldCurveData parameter dateEndDate ",
         "is precedes the date dateStartDate! ")
  }

  # 2. determine the years scope -----------------------------------------------
  iYearsVector <- seq(from = lubridate::year(x = dateStartDate),
                      to = lubridate::year(x = dateEndDate) , by = 1L) %>%
    as.integer()

  # 3. fetch the data ----------------------------------------------------------
  lData <- list()
  for (iIterYear in iYearsVector) {
    dtIterData <- dtFetchUsTreasuryYieldCurveDataForYear(iYear = iIterYear,
                                                         cDataType = cDataType)
    lData <- c(lData, list(dtIterData))
  }

  # 4. concatenate and process the data ----------------------------------------
  # 4.1. check if there are only NULLs in lData
  bCheckIfNullsOnly <- all(sapply(X = lData, FUN = function(x) { is.null(x[[1]])  }))
  # 4.2. if there are only NULLs, print warning and return list(NULL)
  if (bCheckIfNullsOnly) {
    warning("WARNING: there are no data for the years requested in the call to ",
            "dtFetchUsTreasuryYieldCurveData function; returning list(NULL)!")
    return(list(NULL))
  }
  # 4.3. if there no-NULL elements of
  if (!bCheckIfNullsOnly) {
    # 4.3.1. concatenate data and set key
    dtDataOut <- dplyr::bind_rows(lData) %>% data.table::as.data.table()
    data.table::setkey(x = dtDataOut, "quote_date")
    # 4.3.2. set for the relevant time range only
    dtDataOut <- dtDataOut[dtDataOut[["quote_date"]] >= dateStartDate &
                             dtDataOut[["quote_date"]] <= dateEndDate, ]
    # 4.3.3. check if the output is not empty
    if (nrow(dtDataOut) == 0L) {
      warning("WARNING: the output set returned for the data type ", cDataType,
              "for the query for time range ", dateStartDate, " through ",
              dateEndDate, " returned no rows! Returning empty data.table ",
              "from dtFetchUsTreasuryYieldCurveData! ", immediate. = TRUE)
    }
    return(dtDataOut)
  }
}

