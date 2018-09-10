#' vt_app
#'
#' starts the graphical user interface developed with \emph{shiny}.
#'
#' @param maxRequestSize (numeric) number defining the maximum allowed filesize (in megabytes)
#' for uploaded files, defaults to 50MB
#' @return starts the interactive graphical user interface which may be used to perform the
#' anonymisation process.
#' @param ... arguments (e.g \code{host}) that are passed through
#' \code{\link[voronoiTreemap]{vt_app}} when starting the shiny application
#' @export
#'
#' @examples
#' \dontrun{
#' vt_app()
#' }
vt_app <- function(maxRequestSize=50, ...) {
  if (!is.numeric(maxRequestSize)) {
    stop("argument 'maxRequestSize' must be numeric!\n")
  }
  if (maxRequestSize < 1) {
    maxRequestSize <- 10
  }
  appDir <- system.file("shiny", "voronoiTreemapApp", package="voronoiTreemap")
  if (appDir == "") {
    stop("Could not find example directory. Try re-installing `voronoiTreemap`.", call.=FALSE)
  }
  options(shiny.maxRequestSize=ceiling(maxRequestSize)*1024^2)
  source_from_appdir <- function(filename){
    source(file.path(appDir, filename), local = parent.frame(), chdir = TRUE)$value
  }

  source_from_appdir("global.R")
  shinyApp(
    ui = source_from_appdir("ui.R"),
    server = source_from_appdir("server.R"),
    options = list(launch.browser=TRUE, ...)
  )
}
