# Define UI for application that draws a histogram
ui <- navbarPage("Voronoi-Diagramm",
  tabPanel("Data",
    shinyjs::useShinyjs(),
    sidebarPanel(
      fluidRow(
        column(12, selectInput("selData", label="Select Data", choices=available_datasets()))
      ),
      fluidRow(
        column(12, selectInput("sel_level1", label="Var containing total", choices=NULL))
      ),
      fluidRow(
        column(12, selectInput("sel_level2", label="Var containing hierarchy 2", choices=NULL))
      ),
      fluidRow(
        column(12, selectInput("sel_level3", label="Var containing hierarchy 3", choices=NULL))
      ),
      fluidRow(
        column(12, selectInput("sel_color", label="Var holding colors", choices=NULL))
      ),
      fluidRow(
        column(12, selectInput("sel_weight", label="Var holding weights", choices=NULL))
      ),
      fluidRow(
        column(12, selectInput("sel_codes", label="Var holding labels", choices=NULL))
      ),
      fluidRow(
        column(12, selectInput("scaleToPerc", label="Scale weights to %", choices=c(FALSE,TRUE)))
      ),
      fluidRow(id="row_btn_reset", column(12, actionButton("btn_reset", label="Reset choices")))
    ),
    mainPanel(
      fluidRow(id="row_table",
        column(12,h2("Data")),
        column(12, DT::dataTableOutput("curdatadf"))
      ),

      shinyjs::hidden(fluidRow(id="row_error", h2("An Error has occured. Please re-map your variables"))),
      #shinyjs::hidden(fluidRow(id="row_btn_plot", column(12, actionButton("btn_plot", label="Create Plot", class="success")))),
      shinyjs::hidden(fluidRow(id="row_btn_showtable", column(12, actionButton("btn_showtable", label="Show Table", class="success")))),
      shinyjs::hidden(
        fluidRow(id="row_plot",
          column(12,h2("Treeplot")),
          column(12, vt_d3_output("vt"))))
    )
  )
)
