#' @import htmlwidgets
#' @export
voroTree <- function(
                  width = NULL, height = NULL) {
  
  # create a list that contains the settings
  settings <- list(
    sett1=1,
    sett2=2
  )
  
  # pass the data and settings using 'x'
  x <- list(
    data = data.frame(1),
    settings = settings
  )
  
  # create the widget
  htmlwidgets::createWidget("d3vt", x, width = width, height = height,package="voronoiTreemap")
}