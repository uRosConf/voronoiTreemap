data(ExampleGDP, package="voronoiTreemap")
data(canada, package="voronoiTreemap")
canada <- canada[canada$h1=="Canada",]
library(DT)


available_datasets <- function() {
  c("ExampleGDP","canada")
}
