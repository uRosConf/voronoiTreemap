testdf <- function() {
  df <- data.frame(
    h1="Total",
    h2=c("Asia", "Asia", "Asia", "Asia", "Asia", "Asia", "Asia", "Asia", "Asia", "Asia", "Asia", "Asia", "Asia", "Asia", "Asia", "Asia", "North America", "North America", "North America", "Europe", "Europe", "Europe", "Europe", "Europe", "Europe", "Europe", "Europe", "Europe", "Europe", "Europe", "Europe", "Europe", "Europe", "South America", "South America", "South America", "South America", "Australia", "Africa", "Africa", "Africa", "Rest of the World"),
    h3=c("China", "Japan", "India", "South Korea", "Russia", "Indonesia", "Turkey", "Saudi Arabia", "Iran", "Thailand", "United Arab Emirates", "Hong Kong", "Israel", "Malasya", "Singapore", "Philippines", "United States", "Canada", "Mexico", "Germany", "United Kingdom", "France", "Italy", "Spain", "Netherlands", "Switzerland", "Sweden", "Poland", "Belgium", "Norway", "Austria", "Denmark", "Ireland", "Brazil", "Argentina", "Venezuela", "Colombia", "Australia ", "Nigeria", "Egypt", "South Africa", "Rest of the World"),
    color=NA,
    weight=NA,
    codes=NA)

  df[df$h2=="Asia", "color"] <- "#f58321"
  df[df$h2=="North America", "color"] <- "#ef1621"
  df[df$h2=="Europe", "color"] <- "#77bc45"
  df[df$h2=="South America", "color"] <- "#4aaaea"
  df[df$h2=="Australia", "color"] <- "#00acad"
  df[df$h2=="Africa", "color"] <- "#f575a3"
  df[df$h2=="Rest of the World", "color"] <- "#592c94"

  df$weight <- c(14.84, 5.91, 2.83, 1.86, 1.8, 1.16, 0.97, 0.87, 0.57, 0.53, 0.5, 0.42, 0.4, 0.4, 0.39, 0.39, 24.32, 2.09, 1.54, 4.54, 3.85, 3.26, 2.46, 1.62, 1.01, 0.9, 0.67, 0.64, 0.61, 0.52, 0.51, 0.4, 0.38, 2.39, 0.79, 0.5, 0.39, 1.81, 0.65, 0.45, 0.42, 9.41)
  df$codes <- c("CN","JP","IN","KR","RU","ID","TR","SA","IR","TH","AE","HK","IL","MY","SG","PH","US","CA","MX","DE","UK","FR","IT","ES","NL","CH","SE","PL","BE","NO","AT","DK","IE","BR","AR","VE","CO","AU","NG","EG","ZA","RotW")

  saveRDS(df, file="documentation/testdatadf.rds")
  inp <- readRDS("documentation/testdatadf.rds")

}

#input color (fill) for each cell

#' vt_input_from_df
#'
#' create a tree-structure from a data.frame
#'
#' @param inp a data.frame with specific format
#' @param scaleToPerc (logical) scale to percent
#'
#' @return a Node that can be written to json using \code{\link{vt_export_json}}
#' @export
#'
#' @examples
#' ## non yet
vt_input_from_df <- function(inp, scaleToPerc=FALSE) {
  inp$h1 <- as.character(inp$h1)
  inp$h2 <- as.character(inp$h2)
  inp$h3 <- as.character(inp$h3)

  stopifnot(is.data.frame(inp))
  stopifnot(ncol(inp)==6)
  stopifnot(colnames(inp)==c("h1","h2","h3","color","weight","codes"))
  stopifnot(length(unique(inp$h1))==1)
  stopifnot(sum(is.na(inp$weight))==0)
  stopifnot(is.numeric(inp$weight))

  if (scaleToPerc) {
    inp$weight <- inp$weight/sum(inp$weight)
  }

  n <- vt_create_node(inp[1,1])
  spl <- split(inp, factor(inp$h2, levels=unique(inp$h2)))

  if (any(sapply(spl, function(x) { length(!is.na(x$color)) })==0)) {
    stop("please specify at least one color for each second-level code (h2)")
  }

  for (i in seq_along(spl)) {
    tmp <- spl[[i]]
    # continent color
    ref <- as.character(tmp$h2[1])

    groupcol <- tmp$color[1]
    if (is.na(groupcol)) {
      groupcol <- tmp$color[!is.na(tmp$color)][1]
    }

    n <- vt_add_nodes(n, refnode=inp[1,1],node_names=ref, colors=groupcol)

    for (j in 1:nrow(tmp)) {
      curnode <- tmp$h3[j]
      if (curnode==ref) {
        curnode <- paste(curnode, " ")
      }

      curcol <- tmp$color[j]
      if (is.na(curcol)) {
        curcol <- groupcol
      }
      curcode <- tmp$codes[j]
      if (is.na(curcode)) {
        curcode <- substr(tmp$h3[j],1,2)
      }
      n <- vt_add_nodes(n, refnode=ref, node_names=as.character(curnode),
        weights=tmp$weight[j], codes=curcode, colors=curcol)
    }
  }
  n
}

#vt_export_json(vt_input_from_df(inp))

# n <- vt_create_node("Total")
# n <- vt_add_nodes(n, refnode="Total",node_names=c("Asia","Europe"), colors=c("red","blue"))
# n <- vt_add_nodes(n, refnode="Asia",node_names=c("China","Thailand"),
#                   weights=c(0.5, 0.8), codes=c("CN","TH"))
# n <- vt_add_nodes(n, refnode="Europe",node_names=c("Netherlands","Austria"),
#                   weights=c(0.9, 1.1), codes=c("NL","AT"))
# print(n, "weight", "code", "color")
#
# vt_export_json(n)
