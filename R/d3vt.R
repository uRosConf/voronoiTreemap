#' Voronoi Treemap in an htmlwidget
#'
#' Function to generate an htmlwidget with an htmlwidget
#'
#' @import htmlwidgets
#' @examples 
#' d3vt(vt_export_json(vt_testdata()))
#' d <- paste(readLines(file.path(system.file(package="voronoiTreemap"),"htmlwidgets/globalEconomyTest.json")),collapse="")
#' d3vt(d)
#' @note Remake of HowMuch.net's article 'The Global Economy by GDP' by _Kcnarf bl.ocks.org/Kcnarf/fa95aa7b076f537c00aed614c29bb568
#' @export
d3vt <- function(data, elementId = NULL,
                 width = NULL, height = NULL, seed = NULL,title = NULL,
                 legend = FALSE,legend_title = NULL,footer = NULL) {

  # forward options using x
  x = list(
    data= data,
    options = list(legend=legend,title=title,legend_title=legend_title,seed=seed,footer=footer)
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'd3vt',
    x,
    width = width,
    height = height,
    package = 'voronoiTreemap',
    elementId = elementId
  )
}

#' Shiny bindings for d3vt
#'
#' Output and render functions for using d3vt within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a d3vt
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name d3vt-shiny
#'
#' @export
d3vtOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'd3vt', width, height, package = 'voronoiTreemap')
}

#' @rdname d3vt-shiny
#' @export
renderD3vt <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, d3vtOutput, env, quoted = TRUE)
}
