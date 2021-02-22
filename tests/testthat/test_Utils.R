
testthat::test_that(desc = "testing 'bIsScalarOfClass' function...", code = {

  testthat::expect_true(object = bIsScalarOfClass(objIn = 123L,
                                                  cClassName = "integer"))

  testthat::expect_true(object = bIsScalarOfClass(objIn = rnorm(n = 1),
                                                  cClassName = "numeric"))

  testthat::expect_false(object = bIsScalarOfClass(objIn = c(123L, 33L),
                                                  cClassName = "integer"))

})
