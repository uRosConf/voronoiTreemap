#' Voronoi Treemap in an htmlwidget
#'
#' Function to generate an htmlwidget with an htmlwidget
#' @param data a correct json data object
#' @param elementId optional a custom elementId to be returned
#' @param width width of the widget
#' @param height height of the widget
#' @param seed if defined, the plot is fixed
#' @param title NULL or a string for the title
#' @param legend TRUE/FALSE if a legend should be printed
#' @param legend_title NULL or a string for the title of the legend
#' @param footer NULL or a string for the footer text
#' @param color_circle color for the outer circle
#' @param color_border color for the inner lines
#' @param color_label color for the label in the plot
#' @param size_border thickness of the borders in css style, e.g. '1px'
#' @param size_border_hover thickness of the borders when hovering in css style, e.g. '3px'
#' @param size_circle thickness of the circle in css style, e.g. '2px'
#' @examples
#' vt_d3(vt_export_json(vt_testdata()))
#' data(ExampleGDP)
#' gdp_json <- vt_export_json(vt_input_from_df(ExampleGDP))
#' vt_d3(gdp_json)
#' data(canada)
#' canada$codes <- canada$h3
#' canada <- canada[canada$h1=="Canada",]
#' canadaH <- vt_input_from_df(canada,scaleToPerc = FALSE)
#' vt_d3(vt_export_json(canadaH))
#' @note Remake of HowMuch.net's article 'The Global Economy by GDP' by _Kcnarf bl.ocks.org/Kcnarf/fa95aa7b076f537c00aed614c29bb568
#' @export
vt_d3 <- function(data, elementId = NULL,
                 width = NULL, height = NULL, seed = NULL,title = NULL,
                 legend = FALSE,legend_title = NULL,footer = NULL, label = TRUE,
                 color_circle="#aaaaaa",color_border="#ffffff",color_label="#000000",
                 size_border="1px",size_border_hover="3px",size_circle="2px") {

  # forward options using x
  x = list(
    data= data,
    options = list(legend=legend,title=title,legend_title=legend_title,
                   seed=seed,footer=footer,label=label),
    colors = list(circle = color_circle, border = color_border, label = color_label),
    size = list(border=size_border,border_hover=size_border_hover,circle=size_circle)
  )

  # create widget
  createWidget(
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
#' @name vt_d3-shiny
#'
#' @export
vt_d3_output <- function(outputId, width = '100%', height = '400px'){
  shinyWidgetOutput(outputId, 'd3vt', width, height,
    package = 'voronoiTreemap')
}

#' @rdname vt_d3-shiny
#' @export
render_vt_d3 <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  shinyRenderWidget(expr, vt_d3_output, env, quoted = TRUE)
}
