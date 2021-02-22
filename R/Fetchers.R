
dtFetchUsTreasuryYieldCurveDataForYear <- function(iYear, cDataType) {

  # 1. validate the input ------------------------------------------------------
  # ----- 1.1. iYear parameter -----
  if (!bIsScalarOfClass(objIn = iYear, cClassName = "integer")) {
    stop("Error inside the dtFetchUsTreasuryYieldCurveDataForYear function: ",
         "the function parameter iYear is not an integer scalar! ")
  }
  # ----- 1.2. cDataType -----
  cDataType <- match.arg(arg = cDataType,
                               choices = c("YieldCurveRates", "BillRates", "LongTermRates"),
                               several.ok = FALSE)

  # 2. Concatenate the URL to the data -----------------------------------------
  cUrl <- paste0(lUrlDict[[cDataType]], iYear)

  # 3. read XML file -----------------------------------------------------------
  # ----- 3.1. print general info -----
  message("Fetching US Treasury yield curve data of type ", cDataType,
          " for year ", iYear, " from the URL: ", cUrl)
  # ----- 3.2. do the data fetching -----
  objXmlContent <- try(expr = {
    xml2::read_xml(x = cUrl)
  }, silent = TRUE)
  # ----- 3.3. check if data returned is an error -----
  if (methods::is(object = objXmlContent, class2 = "try-error")) {
    stop("ERROR: failed to successfully fetch US Treasury yield curve data of type ",
         cDataType, " for year ", iYear, " from the URL: ", cUrl)
  }
  # ----- 3.4. if not an error, parse further - check if there are any data ----
  # -----       by searching for "entry" tag returned
  if (!any(xml2::xml_name(x = xml2::xml_children(x = objXmlContent)) == "entry")) {
    warning("WARNING: no data returned from fetch of US Treasury yield curve data of type ",
            cDataType, " for year ", iYear, " from the URL: ", cUrl,
            immediate. = TRUE)
    return(list(NULL))
  }

  # 4. parse XML file ----------------------------------------------------------
  # ----- 4.1. fetch the quote dates' vector -----
  cQuoteDates <- try(expr = {
    xml2::xml_text(xml2::xml_find_all(objXmlContent, lQuoteDateColname[[cDataType]]))
  }, silent = TRUE)
  if (methods::is(object = cQuoteDates, class2 = "try-error")) {
    stop("ERROR: failed to successfully fetch US Treasury yield curve quote ",
         "dates for data of type ", cDataType, " for year ", iYear, " from the URL: ", cUrl)
  }
  dateQuoteDates <- try(expr = {
    as.Date(as.POSIXct(x = cQuoteDates, tz = "GMT"))
  }, silent = TRUE)
  if (methods::is(object = dateQuoteDates, class2 = "try-error")) {
    stop("ERROR: failed to successfully cast to Date class US Treasury yield curve quote ",
         "dates for data of type ", cDataType, " for year ", iYear, " from the URL: ", cUrl)
  }
  # ----- 4.2. fetch the columns grid -----
  lDataColsGridDict <- lXmlColsGridDict[[cDataType]]
  lData <- vector(mode = "list", length = length(lDataColsGridDict))
  names(lData) <- names(lDataColsGridDict)
  # ----- 4.3. extract the values from the XML files -----
  for (cIterPillarName in names(lData)) {
    # try to fetch vector of yields for the pillar
    if (cDataType == "YieldCurveRates" | cDataType == "BillRates") {
      objIterValues <- try(expr = {
        xml2::xml_text(xml2::xml_find_all(objXmlContent, lDataColsGridDict[[cIterPillarName]])) %>%
          as.double()  })
      # check if extraction is successful
      if (methods::is(object = objIterValues, class2 = "try-error")) {
        # error occurred - store NULL
        lData[[cIterPillarName]] <- list(NULL)
        next
      }
    }
    if (cDataType == "LongTermRates") {
      # fetch the data
      objIterValues <- try(expr = {
        xml2::xml_text(xml2::xml_find_all(objXmlContent, lDataColsGridDict[[cIterPillarName]])) })
      # check if extraction is successful
      if (methods::is(object = objIterValues, class2 = "try-error")) {
        # error occurred - store NULL
        lData[[cIterPillarName]] <- list(NULL)
      }
      # cast to the right type
      if (cIterPillarName == "LTR_RateType") {
        # cast to character
        objIterValues <- as.character(objIterValues)
      } else if (cIterPillarName == "LTR_RateValue") {
        # cast to double
        objIterValues <- as.double(objIterValues)
      }
    }
    # save the extracted values
    lData[[cIterPillarName]] <- objIterValues
  }
  # ----- 4.4. check for presence of NAs in the lData list of data.tables -----
  cNullGridNames <- names(sapply(X = lData, FUN = is.null))[sapply(X = lData, FUN = is.null)]
  if (length(cNullGridNames) > 0) {
    warning("WARNING: failed fetch of US Treasury interest rates statistics of type ",
            cDataType, " for year ", iYear, " from the URL: ", cUrl, "for columns ",
            cNullGridNames, immediate. = TRUE)
    lData <- lData[setdiff(x = names(lData), y = cNullGridNames)]
  }
  # ----- 4.5. attach the dates to the list of vectors -----
  lData <- c(list("quote_date" = dateQuoteDates), lData)
  # --- 4.6. check if all vectors stored inside lData are of the same length ---
  if (length(unique(sapply(X = lData, FUN = length))) != 1L) {
    stop("ERROR: fetched US Treasury Interest Rate data of type ",
         cDataType, " for year ", iYear, " from the URL: ", cUrl,
         "; are inconsistent: unequal lengths of various data columns! ")
  }

  # 5. bind the columns --------------------------------------------------------
  if (cDataType == "YieldCurveRates" | cDataType == "BillRates") {
    dtDataOut <- dplyr::bind_cols(lData) %>% data.table::as.data.table()
    data.table::setkey(dtDataOut, "quote_date")
  }
  if (cDataType == "LongTermRates") {
    dtDataOut <- dplyr::bind_cols(lData) %>% data.table::as.data.table()
    dtDataOut <- dtDataOut[dtDataOut[["LTR_RateType"]] %in% c("BC_20year", "Over_10_Years"), ]
    quote_date <- NULL
    LTR_RateType <- NULL
    dtDataOut <- data.table::dcast.data.table(data = dtDataOut,
                                 formula = quote_date ~ LTR_RateType,
                                 value.var = "LTR_RateValue")
    data.table::setnames(x = dtDataOut, old = c("BC_20year", "Over_10_Years"),
                         new = c("LTR_BC_20Y", "LTR_Over10Y"))
  }

  return(dtDataOut)
}

