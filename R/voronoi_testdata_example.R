#' vt_testdata
#'
#' @return returns a json-string as in the example
#' from https://bl.ocks.org/Kcnarf/fa95aa7b076f537c00aed614c29bb568
#' @export
#'
#' @examples
#' vt_testdata()
vt_testdata <- function() {
  n <- vt_create_node("Total")

  # continents
  cont <- c("Asia","North America","Europe","South America","Australia","Africa","Rest of the World")
  cols <-  c("#f58321","#ef1621","#77bc45","#4aaaea","#00acad","#f575a3","#592c94")
  cntrs <- c("Thailand","China","Vietnam","Malaysia")
  n <- vt_add_nodes(n, refnode="Total",node_names=cont,colors=cols)

  # Asian countries
  cntr_asia <- c("China","Japan","India","South Korea","Russia", "Indonesia","Turkey",
                 "Saudi Arabia","Iran","Thailand","United Arab Emirates","Hong Kong","Israel","Malaysia",
                 "Singapore", "Philipines")
  vals <- c(14.84,5.91,2.83,1.86,1.8,1.16,0.97,0.87,0.57,0.53,0.5,0.42,0.4,0.4,0.39,0.39)
  codes <- c("CN","JP","IN","KR","RU","ID","TR","SA","IR","TH","AE","HK","IL","MY","SG","PH")
  n <- vt_add_nodes(n, refnode="Asia",node_names=cntr_asia, weights=vals,codes=codes)

  # North America
  cntr_na <- c("United States","Canada","Mexico")
  vals <- c(24.32,2.09,1.54)
  codes <- c("US","CA","MX")
  n <- vt_add_nodes(n, refnode="North America",node_names=cntr_na, weights=vals,codes=codes)

  # Europe
  cntr_europe <- c("Germany","United Kingdom","France","Italy","Spain","Netherlands",
                   "Switzerland","Sweden","Poland","Belgium","Norway","Austria","Denmark","Ireland")
  vals <- c(4.54,3.85,3.26,2.46,1.62,1.01,0.9,0.67,0.64,0.61,0.52,0.51,0.4,0.38)
  codes <- c("DE","UK","FR","IT","ES","NL","CH","SE","PL","BE","NO","AT","DK","IE")
  n <- vt_add_nodes(n, refnode="Europe",node_names=cntr_europe, weights=vals,codes=codes)

  # South America
  cntr_sa <- c("Brazil","Argentinia","Venezuela","Colombia")
  vals <- c(2.39,0.79,0.5,0.39)
  codes <- c("BR","AR","VE","CO")
  n <- vt_add_nodes(n, refnode="South America",node_names=cntr_sa, weights=vals,codes=codes)

  # Australia
  n <- vt_add_nodes(n, refnode="Australia",node_names="Australia ", weights=1.81,codes="AU")

  # Africa
  cntr_africa <- c("Nigeria","Egypt","South Africa")
  vals <- c(0.65,0.45,0.42)
  codes <- c("NG","EG","ZA")
  n <- vt_add_nodes(n, refnode="Africa",node_names=cntr_africa, weights=vals,codes=codes)

  # Rest of the world
  n <- vt_add_nodes(n, refnode="Rest of the World",node_names="Rest of the World ", weights=9.41,codes="RotW")
  #  print(n, "weight", "code", "color")
  return(n)
}
