# Define UI for application that draws a histogram
ui <- navbarPage("Voronoi-Diagramm",
  tabPanel("Data",
    shinyjs::useShinyjs(),
    sidebarPanel(
      h2("Select a df"),
      fluidRow(
        column(12, selectInput("selData", label="Select Dataframe",
          choices=c("ExampleGDP","canada")))
      ),
      fluidRow(
        column(12, p(id="name_of_dataset", ""))
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
      fluidRow(id="reset_row", column(12, actionButton("btn_reset", label="Reset choices")))
    ),
    mainPanel(
      fluidRow(
        column(12, DT::dataTableOutput("curdatadf"))
      )
    )
  ),
  tabPanel("Plot",
    fluidRow(column(12, h1("The Plot"))),
    fluidRow(column(12, vt_d3_output("vt")))
  )
)
