library(voronoiTreemap)
orig__R_CHECK_LENGTH_1_LOGIC2_ <- Sys.getenv("_R_CHECK_LENGTH_1_LOGIC2_", unset = NA_character_)
Sys.setenv("_R_CHECK_LENGTH_1_LOGIC2_" = FALSE)
test_that("vt_testdata",{
  x <- vt_testdata()
  expect_equal(class(x)[1L],"Node")
})
test_that("vt_export_json",{
  x <- vt_export_json(vt_testdata())
  expect_equal(class(x)[1L],"character")
})
test_that("vt_d3 1",{
  x <- vt_d3(vt_export_json(vt_testdata()))
  expect_identical(class(x),c("d3vt", "htmlwidget"))
})

test_that("vt_d3 GDP",{
data(ExampleGDP)
gdp_json <- vt_export_json(vt_input_from_df(ExampleGDP))
vt_d3(gdp_json)
data(canada)
canada$codes <- canada$h3
canada <- canada[canada$h1=="Canada",]
canadaH <- vt_input_from_df(canada,scaleToPerc = FALSE)
vt_d3(vt_export_json(canadaH))
#without label
vt_d3(vt_export_json(canadaH), label=FALSE)
})

Sys.setenv("_R_CHECK_LENGTH_1_LOGIC2_" = orig__R_CHECK_LENGTH_1_LOGIC2_)
