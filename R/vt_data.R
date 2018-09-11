#' ExampleGDP
#'
#' An example data.frame using GDP data to demonstrate the
#' voronoiTree package
#'
#' @docType data
#' @usage data(ExampleGDP)
#' @format A data frame with 42 rows and 6 variables:
#' \describe{
#'   \item{h1}{Name of first-level (redundant)}
#'   \item{h2}{Leaf names of second-level (continents)}
#'   \item{h3}{Leaf names of third-level values (countries)}
#'   \item{color}{colors in which the plot-regions will be filled}
#'   \item{weight}{GDP values in percent of the overall total}
#'   \item{codes}{short labels used for overlays in plotting}
#' }
#' @keywords datasets
#' @examples
#' data("ExampleGDP")
#' head(ExampleGDP)
"ExampleGDP"


#' canada
#'
#' An example data.frame using Canadian Consumer Price Index (CPI) to demonstrate the
#' voronoiTree package
#'
#' @docType data
#' @usage data(canada)
#' @format A data frame with 247 rows and 5 variables:
#' \describe{
#'   \item{h1}{Name of first-level (region)}
#'   \item{h2}{Leaf names of second-level (elementary_aggregate)}
#'   \item{h3}{Leaf names of third-level values (intermediate_aggregate)}
#'   \item{color}{colors in which the plot-regions will be filled}
#'   \item{weight}{CPI in percent of the overall total}
#'   \item{codes}{NAs}
#' }
#' @keywords datasets
#' @examples
#' data("canada")
#' head(canada)
"canada"
