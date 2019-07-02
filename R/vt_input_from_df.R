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
#' @param hierachyVar0 (character) variable name of toplevel hierachy (will be replaced with "Total" if empty)
#' @param hierachyVar1 (character) variable name of first level
#' @param hierachyVar2 (character) variable name of second level
#' @param colorVar (character) variable name of the color information
#' @param weightVar (character) variable name of the weight information
#' @param labelVar (character) variable name of (short) labels
#' 
#'
#' @return a Node that can be written to json using \code{\link{vt_export_json}}
#' @export
#'
#' @examples
#' data(canada)
#' canada <- canada[canada$h1=="Canada",]
#' canada$codes <- canada$h3
#' v1 <- vt_input_from_df(canada, hierachyVar0 = "h1", hierachyVar1 = "h2",
#'   hierachyVar2 = "h3", colorVar = "color",weightVar = "weight",
#'   labelVar = "codes")
#'  colnames(canada) <- c("hier1","hier2","hier3","col","w","cod")
#' v2 <- vt_input_from_df(canada, hierachyVar0 = "hier1", hierachyVar1 = "hier2",
#'     hierachyVar2 = "hier3", colorVar = "col",weightVar = "w",
#'     labelVar = "cod")
#'     
vt_input_from_df <- function(inp, scaleToPerc=FALSE, hierachyVar0 = NULL,
                             hierachyVar1, hierachyVar2,
                             colorVar, weightVar, labelVar = NULL) {
  
  inp[[hierachyVar1]] <- as.character(inp[[hierachyVar1]])
  inp[[hierachyVar2]] <- as.character(inp[[hierachyVar2]])

  stopifnot(is.data.frame(inp))
  stopifnot(sum(is.na(inp[[weightVar]]))==0)
  stopifnot(is.numeric(inp[[weightVar]]))

  if (scaleToPerc) {
    inp$weight <- inp[[weightVar]]/sum(inp[[weightVar]])
  }
  if(is.null(hierachyVar0)){
    n <- vt_create_node("Total")
  }else{
    n <- vt_create_node(as.character(inp[[hierachyVar0]][1]))
  }
  
  spl <- split(inp, factor(inp[[hierachyVar1]], levels=unique(inp[[hierachyVar1]])))

  if (any(sapply(spl, function(x) { length(!is.na(x[[colorVar]])) })==0)) {
    stop("please specify at least one color for each first-level code (hierachyVar1)")
  }

  for (i in seq_along(spl)) {
    tmp <- spl[[i]]
    # continent color
    ref <- as.character(tmp[[hierachyVar1]][1])

    groupcol <- tmp[[colorVar]][1]
    if (is.na(groupcol)) {
      groupcol <- tmp[[colorVar]][!is.na(tmp[[colorVar]])][1]
    }
    if(is.null(hierachyVar0)){
      n <- vt_add_nodes(n, refnode="Total", node_names=ref, colors=groupcol)
    }else{
      n <- vt_add_nodes(n, refnode=as.character(inp[[hierachyVar0]][1]), node_names=ref, colors=groupcol)  
    }
    

    for (j in 1:nrow(tmp)) {
      curnode <- tmp[[hierachyVar2]][j]
      if (curnode==ref) {
        curnode <- paste(curnode, " ")
      }

      curcol <- tmp[[colorVar]][j]
      if (is.na(curcol)) {
        curcol <- groupcol
      }
      if(is.null(colorVar)){
        curcode <- substr(tmp[[hierachyVar2]][j],1,2)
      }else{
        curcode <- tmp[[labelVar]][j]
        if (is.na(curcode)) {
          curcode <- substr(tmp[[hierachyVar2]][j],1,2)
        }  
      }
      n <- vt_add_nodes(n, refnode=ref, node_names=as.character(curnode),
        weights=tmp[[weightVar]][j], codes=curcode, colors=curcol)
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
